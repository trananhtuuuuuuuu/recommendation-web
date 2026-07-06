"""Parse one real CV image and match it against the JD pool end to end.

Runs the full recommender pipeline (mask -> hard filter -> vector + semantic ->
decision -> Ollama suggestion) for a single uploaded CV, ranks the JDs by match
score, and prints what the LayoutLMv3 parser extracted so the result is auditable.

Usage (from the ai/ directory, env `datn`):
    AI_WITH_MODEL=true OLLAMA_MODEL=qwen2.5:3b \
        python -m scripts.match_my_cv --cv data/CV_Nguyen_Van_Hien.jpg --llm
"""

from __future__ import annotations

import argparse
import json
import os
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from app.parser import CvParser  # noqa: E402
from app.postprocess import to_display  # noqa: E402
from app.recommend import run_match  # noqa: E402
from app.recommend.config import display_name  # noqa: E402
from app.recommend.decision import decide  # noqa: E402
from app.recommend.masking import mask_entities  # noqa: E402
from app.recommend.schemas import JobDescriptionInput  # noqa: E402
from app.recommend.semantic import score_semantic_fields  # noqa: E402
from app.recommend.vector_space import score_vector_fields  # noqa: E402

AI_DIR = pathlib.Path(__file__).resolve().parents[1]


def _fmt_scores(scores: dict[str, float]) -> str:
    ordered = sorted(scores.items(), key=lambda item: item[1], reverse=True)
    return ", ".join(f"{display_name(field)}={value:.2f}" for field, value in ordered)


def main() -> None:
    parser = argparse.ArgumentParser(description="Match one CV image against the JD pool.")
    parser.add_argument("--cv", type=pathlib.Path, default=AI_DIR / "data" / "CV_Nguyen_Van_Hien.jpg")
    parser.add_argument("--jds", type=pathlib.Path, default=AI_DIR / "data" / "jds.json")
    parser.add_argument(
        "--model-dir",
        default=os.getenv("AI_MODEL_DIR", str(AI_DIR / "model" / "layoutlmv3")),
    )
    parser.add_argument("--method", default="tfidf", choices=["tfidf", "word2vec", "embedding"])
    parser.add_argument("--llm", action="store_true", help="use Ollama for English suggestions")
    parser.add_argument(
        "--save-canonical",
        type=pathlib.Path,
        default=AI_DIR / "data" / "my_cv_canonical.json",
    )
    args = parser.parse_args()

    cv_parser = CvParser(
        model_dir=args.model_dir,
        enable_model=os.getenv("AI_WITH_MODEL", "false").lower() == "true",
        ocr_languages=os.getenv("AI_OCR_LANGUAGES", "eng+vie"),
        ocr_engine=os.getenv("AI_OCR_ENGINE", "paddle"),
    )
    print(f"CV file        : {args.cv}")
    print(f"model dir      : {args.model_dir}")
    print(f"model_available: {cv_parser.model_available}")

    canonical = cv_parser.parse_canonical(args.cv.read_bytes(), args.cv.name)
    args.save_canonical.write_text(
        json.dumps(canonical, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    by_label = canonical.get("entitiesByLabel", {})
    print("\n================ CV EXTRACTION ================")
    print(f"extractionMode : {canonical.get('extractionMode')}")
    print(f"confidence     : {canonical.get('confidence')}")
    print(f"total exp years: {canonical.get('totalExperienceYears')}")
    print("entity counts  :", {label: len(values) for label, values in by_label.items() if values})
    print("\n--- structured (display) ---")
    print(json.dumps(to_display(canonical), ensure_ascii=False, indent=2))
    print(f"\n(saved canonical CV -> {args.save_canonical})")

    jds = json.loads(args.jds.read_text(encoding="utf-8"))
    masked = mask_entities(canonical.get("entitiesByLabel", {}))
    rows = []
    for jd_raw in jds:
        jd = JobDescriptionInput.from_dict(jd_raw)
        # Official pipeline result: applies the hard filter and runs suggestions.
        result = run_match(canonical, jd_raw, method=args.method, enable_llm=args.llm)
        # Raw semantic score (ignores the hard filter) so every JD can still be
        # ranked even when the gate rejects it -- "fit if the gate were lifted".
        field_scores = score_vector_fields(masked, jd, method=args.method) + score_semantic_fields(masked, jd, method=args.method)
        per_field = {score.field: score.score for score in field_scores}
        raw_score, _, _ = decide(per_field, method=args.method)
        rows.append((jd_raw, jd, result, per_field, raw_score))

    rows.sort(key=lambda row: row[4], reverse=True)

    print("\n\n========== RANKING by semantic fit (5 JD) ==========")
    print("(semantic = ignores hard filter; Gate = whether the hard filter passed)")
    print(f"hard-filter input: totalExperienceYears = {canonical.get('totalExperienceYears')}\n")
    for rank, (jd_raw, jd, result, per_field, raw_score) in enumerate(rows, start=1):
        gate = "PASS ✅" if result.passed_filter else "FILTERED ⛔"
        print(f"#{rank}  [{jd_raw.get('id')}] {jd.job_title:24} semantic={raw_score:6.1%}  Gate={gate}")
        print(f"      fields: {_fmt_scores(per_field)}")
        if not result.passed_filter:
            print(f"      filter reasons: {'; '.join(result.hard_filter.reasons)}")
        if result.suggestions:
            print("      Suggestions:")
            for suggestion in result.suggestions:
                print(f"        - {suggestion}")


if __name__ == "__main__":
    main()
