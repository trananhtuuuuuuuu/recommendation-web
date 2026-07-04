"""Round-2 pseudo-labelling: run the trained LayoutLMv3 over unlabelled real
CVs and emit high-confidence auto-labels in Label Studio format for training.

Why: we only have ~250 hand-labelled CVs. The current model is strong on
single-column CVs (avg conf ~0.96). We reuse it to auto-label the remaining
real CVs, keep only the confident ones, and feed them into STAGE-1 of the next
training round (broad, noisy) — while STAGE-2 fine-tune and validation stay
purely human-labelled.

Filenames stay ORIGINAL (the CV images are usually already uploaded to Drive —
no rename, no re-upload). Each task carries a `"pseudo": true` flag; the
notebook's `_is_real()` reads that flag straight from LS_EXPORTS (no separate
marker file) and keeps these CVs out of validation and the real-only stage-2
fine-tune. Pass --copy-images only if the images are NOT yet on Drive and you
want a folder to upload.

Speed: use Tesseract OCR here (AI_OCR_ENGINE=tesseract) — ~5s/CV vs PaddleOCR's
~70s/CV on CPU, with the same model confidence. The training notebook re-OCRs
every image with PaddleOCR in PHASE A, so only the pseudo-label *region boxes*
(percent) matter here, and the model predicts those just as confidently.

Output (under --out-dir):
  pseudo_labelstudio.json   Label Studio export (annotations format, ORIGINAL
                            names, each task flagged "pseudo": true) — add its
                            path to LS_EXPORTS in the notebook; that's all
  pseudo_stats.json         per-run summary (kept/skipped, label counts)
  images/<name>             (only with --copy-images) copies to upload to Drive

Run inside the model image (torch / transformers / tesseract present):
  docker run --rm \
    -v "$PWD/ai/app:/app/app" -v "$PWD/ai/scripts:/app/scripts" \
    -v "$PWD/ai/model:/app/model:ro" -v "$PWD/ai/data:/app/data:ro" \
    -v "/host/dataset/processed/images:/app/ds:ro" \
    -v "$PWD/ai/synthetic/pseudo_out:/app/out" \
    -e AI_MODEL_DIR=/app/model/layoutlmv3 -e AI_OCR_ENGINE=tesseract -e AI_OCR_LANGUAGES=eng \
    --entrypoint python recommendation-web-ai -m scripts.pseudo_label \
      --images-dir /app/ds --exclude "/app/data/data-labelstudio/*.json" \
      --out-dir /app/out --min-conf 0.92 --span-conf 0.85
"""
from __future__ import annotations

import argparse
import glob
import json
import os
import re
import shutil
from collections import Counter
from pathlib import Path

from PIL import Image

from app.parser import CvParser

IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tiff"}
LS_PREFIX = "/data/local-files/?d="


def _excluded_stems(patterns: list[str]) -> set[str]:
    """File stems already hand-labelled (skip them; we have gold labels).

    Matched by stem so a labelled `5.jpg` also excludes a candidate `5.png`.
    """
    stems: set[str] = set()
    for pat in patterns:
        for path in glob.glob(pat):
            try:
                tasks = json.load(open(path, encoding="utf-8"))
            except Exception:
                continue
            for task in tasks:
                img = task.get("data", {}).get("image", "")
                m = re.search(r"[?&]d=([^&]+)", img)
                name = os.path.basename(m.group(1) if m else img)
                stems.add(Path(name).stem)
    return stems


def _regions(entities, span_conf: float) -> list[dict]:
    """One Label Studio rectangle per confident merged span (box is 0-1000)."""
    out = []
    for s in entities:
        if s.confidence < span_conf or not s.box:
            continue
        x1, y1, x2, y2 = s.box  # normalised 0..1000  ->  percent = /10
        w, h = (x2 - x1) / 10.0, (y2 - y1) / 10.0
        if w <= 0 or h <= 0:
            continue
        out.append({"label": s.label, "x": x1 / 10.0, "y": y1 / 10.0, "w": w, "h": h})
    return out


def _to_task(image_ref: str, regions: list[dict], W: int, H: int) -> dict:
    result = []
    for g in regions:
        result.append({
            "type": "rectanglelabels", "from_name": "label", "to_name": "image",
            "original_width": W, "original_height": H, "image_rotation": 0,
            "value": {"x": g["x"], "y": g["y"], "width": g["w"], "height": g["h"],
                      "rotation": 0, "rectanglelabels": [g["label"]]},
        })
    # "pseudo": true travels WITH the task -> the notebook reads it straight from
    # LS_EXPORTS (no separate marker file) to keep these out of val / stage-2.
    return {"data": {"image": image_ref}, "annotations": [{"result": result}],
            "pseudo": True}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--images-dir", required=True, help="folder of unlabelled CV images")
    ap.add_argument("--out-dir", required=True)
    ap.add_argument("--exclude", nargs="*", default=[], help="LS json glob(s) of already-labelled CVs")
    ap.add_argument("--drive-subdir", default="dataset_new",
                    help="d= subdir the notebook serves images from (basename is what matters)")
    ap.add_argument("--copy-images", action="store_true",
                    help="also copy kept images into out/images (only if not already on Drive)")
    ap.add_argument("--min-conf", type=float, default=0.92, help="keep CV only if mean span conf >= this")
    ap.add_argument("--span-conf", type=float, default=0.85, help="drop individual spans below this")
    ap.add_argument("--min-spans", type=int, default=6, help="skip CVs with too few kept spans")
    ap.add_argument("--require", nargs="*", default=["NAME"], help="labels that must be present")
    ap.add_argument("--limit", type=int, default=0, help="0 = all candidates")
    ap.add_argument("--max-pages", type=int, default=1)
    args = ap.parse_args()

    parser = CvParser(
        model_dir=os.getenv("AI_MODEL_DIR", "/app/model/layoutlmv3"),
        max_pages=args.max_pages, enable_model=True,
        ocr_languages=os.getenv("AI_OCR_LANGUAGES", "eng"),
        ocr_engine=os.getenv("AI_OCR_ENGINE", "tesseract"),
    )
    assert parser.model_available, "model not available — check AI_MODEL_DIR"

    exclude = _excluded_stems(args.exclude)
    cands = sorted(
        p for p in Path(args.images_dir).iterdir()
        if p.suffix.lower() in IMAGE_EXTS and p.stem not in exclude
    )
    if args.limit:
        cands = cands[: args.limit]

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    img_out = out_dir / "images"
    if args.copy_images:
        img_out.mkdir(parents=True, exist_ok=True)
    ls_prefix = f"{LS_PREFIX}{args.drive_subdir}/"

    tasks: list[dict] = []
    kept_names: list[str] = []
    label_counts: Counter = Counter()
    skips: Counter = Counter()
    print(f"candidates={len(cands)} exclude={len(exclude)} ocr={parser.ocr_engine} "
          f"min_conf={args.min_conf} span_conf={args.span_conf}", flush=True)

    for i, path in enumerate(cands, 1):
        try:
            content = path.read_bytes()
            entities, _text, model_used = parser._collect(content, path.name)
        except Exception as exc:
            skips["error"] += 1
            print(f"  !! {path.name}: {exc}", flush=True)
            continue
        if not model_used or not entities:
            skips["no_spans"] += 1
        else:
            mean_conf = sum(s.confidence for s in entities) / len(entities)
            regions = _regions(entities, args.span_conf)
            present = {r["label"] for r in regions}
            if mean_conf < args.min_conf:
                skips["low_conf"] += 1
            elif len(regions) < args.min_spans:
                skips["few_spans"] += 1
            elif any(r not in present for r in args.require):
                skips["missing_required"] += 1
            else:
                with Image.open(path) as im:
                    W, H = im.size
                if args.copy_images:
                    shutil.copyfile(path, img_out / path.name)
                tasks.append(_to_task(ls_prefix + path.name, regions, W, H))
                kept_names.append(path.name)
                label_counts.update(r["label"] for r in regions)

        if i % 50 == 0 or i == len(cands):
            print(f"[{i}/{len(cands)}] kept={len(tasks)} skips={dict(skips)}", flush=True)

    json.dump(tasks, open(out_dir / "pseudo_labelstudio.json", "w", encoding="utf-8"),
              ensure_ascii=False)
    stats = {
        "candidates": len(cands), "kept": len(tasks), "skipped": dict(skips),
        "label_boxes": dict(sorted(label_counts.items())),
        "params": {"min_conf": args.min_conf, "span_conf": args.span_conf,
                   "min_spans": args.min_spans, "require": args.require,
                   "drive_subdir": args.drive_subdir, "ocr": parser.ocr_engine},
    }
    json.dump(stats, open(out_dir / "pseudo_stats.json", "w"), ensure_ascii=False, indent=2)
    print("\n=== DONE ===")
    print(f"kept {len(tasks)}/{len(cands)} CVs")
    print("skips:", dict(skips))
    print("label boxes:", dict(sorted(label_counts.items())))
    print("labelstudio ->", out_dir / "pseudo_labelstudio.json",
          f"({len(kept_names)} tasks, each flagged \"pseudo\": true)")
    if args.copy_images:
        print("images ->", img_out)


if __name__ == "__main__":
    main()
