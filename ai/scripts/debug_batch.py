"""Run LayoutLMv3 + rule aggregation over an arbitrary list of CV images.

Paths come from AI_CV_LIST (comma-separated, inside the container). Prints, per
CV: label counts, avg confidence, the raw spans (reading order) and the
rule-aggregated canonical blocks -- a compact quality read-out.
"""
from __future__ import annotations

import json
import os
from collections import Counter
from pathlib import Path

from app.parser import CvParser
from app.postprocess import build_canonical


def main() -> None:
    parser = CvParser(
        model_dir=os.getenv("AI_MODEL_DIR", "/app/model/layoutlmv3"),
        max_pages=int(os.getenv("AI_MAX_PAGES", "3")),
        enable_model=True,
        ocr_languages=os.getenv("AI_OCR_LANGUAGES", "eng+vie"),
        ocr_engine=os.getenv("AI_OCR_ENGINE", "paddle"),
    )
    print("model_available:", parser.model_available)

    cvs = [p.strip() for p in os.getenv("AI_CV_LIST", "").split(",") if p.strip()]
    for rel in cvs:
        path = Path(rel)
        if not path.is_file():
            print(f"!! missing: {path}")
            continue
        content = path.read_bytes()
        entities, text, model_used = parser._collect(content, path.name)

        print("\n" + "=" * 78)
        print(f"{path.name}   (model_used={model_used}, spans={len(entities)})")
        print("=" * 78)
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


if __name__ == "__main__":
    main()
