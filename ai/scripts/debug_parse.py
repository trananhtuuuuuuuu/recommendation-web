"""Dump raw LayoutLMv3 spans + the rule-aggregation output for sample CVs.

Run inside the model-enabled AI image so torch / transformers / paddleocr are
available. It prints, per CV:
  1. the raw entity spans the model tagged (label, confidence, reading order,
     text) -- this is how you judge the model's labelling quality;
  2. the rule-aggregated canonical structure (work/education/projects blocks);
  3. the flat legacy profile that /parse-cv returns.

Usage (from the repo root):
  docker run --rm \
    -v "$PWD/ai/app:/app/app" -v "$PWD/ai/scripts:/app/scripts" \
    -v "$PWD/ai/data:/app/data" -v "$PWD/ai/model:/app/model:ro" \
    -e AI_MODEL_DIR=/app/model/layoutlmv3 -e AI_OCR_ENGINE=paddle \
    --entrypoint python recommendation-web-ai -m scripts.debug_parse
"""

from __future__ import annotations

import json
import os
from collections import Counter
from pathlib import Path

from app.parser import CvParser
from app.postprocess import build_canonical, build_profile

CVS = [
    "data/CV_Nguyen_Van_Hien.pdf",
    "data/Le Thi Hong Ngoc_CV.pdf",
    "data/test (1).jpg",
]


def _rule(title: str) -> None:
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)


def main() -> None:
    parser = CvParser(
        model_dir=os.getenv("AI_MODEL_DIR", "/app/model/layoutlmv3"),
        max_pages=int(os.getenv("AI_MAX_PAGES", "3")),
        enable_model=True,
        ocr_languages=os.getenv("AI_OCR_LANGUAGES", "eng+vie"),
        ocr_engine=os.getenv("AI_OCR_ENGINE", "paddle"),
    )
    print("model_available:", parser.model_available)

    for rel in CVS:
        path = Path(rel)
        if not path.is_file():
            print(f"!! missing: {path}")
            continue
        content = path.read_bytes()
        entities, text, model_used = parser._collect(content, path.name)

        _rule(f"{path.name}   (model_used={model_used}, spans={len(entities)})")

        counts = Counter(span.label for span in entities)
        print("label counts:", dict(sorted(counts.items())))
        avg = (sum(s.confidence for s in entities) / len(entities)) if entities else 0.0
        print(f"avg confidence: {avg:.3f}")

        print("\n--- RAW SPANS (reading order) ---")
        for span in sorted(entities, key=lambda s: (s.page, s.order)):
            print(f"[{span.order:>4}] {span.label:<18} {span.confidence:.2f}  {span.text!r}")

        canonical = build_canonical(entities, text, model_used)
        print("\n--- RULE-AGGREGATED (build_canonical) ---")
        for key in ("personal_information", "work_experience", "education_history",
                    "projects", "skills_and_expertise", "certifications",
                    "totalExperienceYears"):
            print(f"{key}: {json.dumps(canonical[key], ensure_ascii=False)}")

        profile = build_profile(entities, text, model_used)
        print("\n--- LEGACY PROFILE (/parse-cv) experience ---")
        print(json.dumps(profile["experience"], ensure_ascii=False, indent=1))


if __name__ == "__main__":
    main()
