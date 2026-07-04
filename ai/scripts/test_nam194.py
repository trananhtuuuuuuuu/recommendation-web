"""Download nam194/resume_parsing_layoutlmv3_version1 (LayoutLMv3-large, 20-class
key/value schema) and run it on the 3 sample CVs. Same Tesseract OCR + box
normalisation we feed our own model, for a fair comparison.
"""
from __future__ import annotations

import os
from collections import Counter
from pathlib import Path

import torch
from huggingface_hub import snapshot_download
from transformers import AutoModelForTokenClassification, AutoProcessor

from app.parser import CvParser

REPO = "nam194/resume_parsing_layoutlmv3_version1"
CVS = ["data/CV_Nguyen_Van_Hien.pdf", "data/Le Thi Hong Ngoc_CV.pdf", "data/test (1).jpg"]
BG = {"undefined"}       # background / non-entity class
MAXW = 90


def main() -> None:
    print(f"downloading {REPO} (weights only) ...", flush=True)
    d = snapshot_download(
        REPO,
        ignore_patterns=["*optimizer*", "*scheduler*", "*rng_state*",
                         "*training_args*", "*trainer_state*", "*.pt", "*.pth"],
    )
    proc = AutoProcessor.from_pretrained(d, apply_ocr=False)
    model = AutoModelForTokenClassification.from_pretrained(d)
    model.eval()
    id2 = model.config.id2label
    print("loaded. labels:", list(id2.values()), flush=True)

    ocr = CvParser(model_dir="/app/model/layoutlmv3", enable_model=False,
                   ocr_engine="tesseract", ocr_languages="eng")

    for rel in CVS:
        path = Path(rel)
        content = path.read_bytes()
        img = ocr._load_visual_pages(content, path.suffix.lower())[0]
        words, pboxes = ocr._ocr_words(img)
        W, H = img.size
        boxes = [ocr._normalize_box(b, W, H) for b in pboxes]

        enc = proc(images=img, text=words, boxes=boxes, truncation=True,
                   padding="max_length", max_length=512, return_tensors="pt")
        word_ids = enc.word_ids(0)
        inputs = {k: v for k, v in enc.items() if isinstance(v, torch.Tensor)}
        with torch.no_grad():
            probs = torch.softmax(model(**inputs).logits[0], dim=-1)

        spans, seen, cur = [], set(), None
        for ti, wid in enumerate(word_ids):
            if wid is None or wid in seen or wid >= len(words):
                continue
            seen.add(wid)
            pid = int(probs[ti].argmax()); conf = float(probs[ti].max()); lab = id2[pid]
            if lab in BG or conf < 0.45:
                if cur: spans.append(cur); cur = None
                continue
            if cur and cur["label"] == lab:
                cur["words"].append(words[wid]); cur["scores"].append(conf)
            else:
                if cur: spans.append(cur)
                cur = {"label": lab, "words": [words[wid]], "scores": [conf], "order": wid}
        if cur: spans.append(cur)

        print("\n" + "=" * 78)
        print(f"{path.name}   (spans={len(spans)}, ocr_words={len(words)})")
        print("=" * 78)
        counts = Counter(s["label"] for s in spans)
        print("label counts:", dict(sorted(counts.items())))
        avg = sum(sc for s in spans for sc in s["scores"]) / max(sum(len(s["scores"]) for s in spans), 1)
        print(f"avg token confidence: {avg:.3f}")
        print("\n--- SPANS (reading order) ---")
        for s in spans:
            text = " ".join(s["words"])
            if len(text) > MAXW:
                text = text[:MAXW] + " …"
            c = sum(s["scores"]) / len(s["scores"])
            print(f"[{s['order']:>4}] {s['label']:<20} {c:.2f}  {text!r}")


if __name__ == "__main__":
    main()
