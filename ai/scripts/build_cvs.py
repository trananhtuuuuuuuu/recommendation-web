"""Convert the labelled OCR training examples into canonical CVs.

Reads ``data/train_examples.json`` (each item: words + boxes + ner_tags, the
ground-truth BIO labels from Label Studio + OCR) and writes ``data/cvs.json`` --
a list of canonical CVs (same shape as ``POST /aggregate``), ready for the
recommender. No LayoutLM inference is needed; the labels are ground truth.

Usage:
    python -m scripts.build_cvs
"""

from __future__ import annotations

import argparse
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from app.postprocess import ENTITY_LABELS, EntitySpan, build_canonical, to_display  # noqa: E402

AI_DIR = pathlib.Path(__file__).resolve().parents[1]


def _id2label() -> dict[int, str]:
    """Rebuild the id->label map exactly like train_layoutlmv3_cv.ipynb."""
    labels = ["O"]
    for entity in ENTITY_LABELS:
        labels += [f"B-{entity}", f"I-{entity}"]
    return {index: label for index, label in enumerate(labels)}


def _to_spans(words, boxes, ner_tags, id2label) -> list[EntitySpan]:
    """Collapse per-word BIO tags into entity spans carrying box + reading order."""
    spans: list[EntitySpan] = []
    current_label = None
    current_words: list[str] = []
    current_boxes: list[list[int]] = []
    current_order = 0

    def flush() -> None:
        nonlocal current_label, current_words, current_boxes, current_order
        if current_label and current_words:
            box = (
                min(b[0] for b in current_boxes),
                min(b[1] for b in current_boxes),
                max(b[2] for b in current_boxes),
                max(b[3] for b in current_boxes),
            )
            spans.append(
                EntitySpan(current_label, " ".join(current_words), 1.0, 0, box, current_order)
            )
        current_label = None
        current_words = []
        current_boxes = []
        current_order = 0

    for index, (word, box, tag) in enumerate(zip(words, boxes, ner_tags)):
        label = id2label.get(int(tag), "O")
        if label == "O":
            flush()
            continue
        bio, entity = label.split("-", 1)
        if bio == "B" or current_label != entity:
            flush()
            current_label = entity
            current_order = index
        current_words.append(word)
        current_boxes.append(box)
    flush()
    return spans


def main() -> None:
    parser = argparse.ArgumentParser(description="Build canonical CVs from labelled OCR.")
    parser.add_argument("--src", type=pathlib.Path, default=AI_DIR / "data" / "train_examples.json")
    parser.add_argument("--out", type=pathlib.Path, default=AI_DIR / "data" / "cvs.json")
    parser.add_argument(
        "--display-out", type=pathlib.Path, default=AI_DIR / "data" / "cvs_display.json"
    )
    args = parser.parse_args()

    id2label = _id2label()
    examples = json.loads(args.src.read_text(encoding="utf-8"))

    cvs = []
    for index, example in enumerate(examples):
        spans = _to_spans(example["words"], example["boxes"], example["ner_tags"], id2label)
        canonical = build_canonical(spans, " ".join(example["words"]), model_used=True)
        canonical["id"] = pathlib.Path(example.get("image_file", f"cv_{index:03d}")).stem
        cvs.append(canonical)

    args.out.write_text(json.dumps(cvs, ensure_ascii=False, indent=2), encoding="utf-8")

    display = [to_display(cv) for cv in cvs]
    args.display_out.write_text(json.dumps(display, ensure_ascii=False, indent=2), encoding="utf-8")

    with_experience = sum(1 for cv in cvs if cv["totalExperienceYears"] > 0)
    with_skill = sum(1 for cv in cvs if cv["entitiesByLabel"]["SKILL"])
    print(f"Wrote {len(cvs)} canonical CVs (full, for recommender) to {args.out}")
    print(f"Wrote {len(display)} clean display CVs (for DB/website) to {args.display_out}")
    print(f"  with computed experience years : {with_experience}")
    print(f"  with at least one SKILL        : {with_skill}")


if __name__ == "__main__":
    main()
