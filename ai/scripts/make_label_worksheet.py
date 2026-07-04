"""Build a human-friendly labelling worksheet for the SVM training pairs.

Phương án B: the local LLM punted to UNSURE on 85% of the boundary pairs, so the
378 "middle" pairs need human labels to break the anchor-derived, JOB_TITLE-
dominated weighting. This joins CV/JD context (titles, skills, requirements) onto
labeled_pairs.csv so each pair can be judged by eye, sorts the middle rows to the
top by anchor desc, and pre-fills a *starting* label only from the LLM YES/NO
hints (UNSURE stays blank). train_svm reads columns by NAME and ignores the extra
context columns, so you train directly on the saved worksheet:

    python -m scripts.make_label_worksheet
    # ... fill the 'label' column (1=match, 0=not, blank=skip) for the top rows ...
    python -m scripts.train_svm --data data/label_worksheet.csv --out model/recommender_svm.joblib
"""

from __future__ import annotations

import argparse
import csv
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from app.recommend.config import FIELD_ORDER  # noqa: E402

AI_DIR = pathlib.Path(__file__).resolve().parents[1]
SCORE_COLS = [field.lower() for field in FIELD_ORDER]
CONTEXT_COLS = [
    "label", "llm_hint", "sim_anchor", "jd_id", "jd_title",
    "cv_id", "cv_title", "cv_skills", "jd_requirements", "source",
]


def _cv_context(cv: dict) -> tuple[str, str]:
    work = cv.get("work_experience") or []
    title = next((entry.get("job_title", "") for entry in work if entry.get("job_title")), "")
    skills = ", ".join((cv.get("skills_and_expertise") or {}).get("skill", [])[:10])
    return title, skills


def _starting_label(row: dict) -> str:
    """Keep auto labels; seed middle rows from the LLM YES/NO only (UNSURE blank)."""
    if row.get("label"):
        return row["label"]
    return {"YES": "1", "NO": "0"}.get(row.get("llm_hint", ""), "")


def main() -> None:
    parser = argparse.ArgumentParser(description="Build the manual-labelling worksheet.")
    parser.add_argument("--pairs", type=pathlib.Path, default=AI_DIR / "data" / "labeled_pairs.csv")
    parser.add_argument("--cvs", type=pathlib.Path, default=AI_DIR / "data" / "cvs_display.json")
    parser.add_argument("--jds", type=pathlib.Path, default=AI_DIR / "data" / "jds.json")
    parser.add_argument("--out", type=pathlib.Path, default=AI_DIR / "data" / "label_worksheet.csv")
    args = parser.parse_args()

    cvs = {str(cv.get("id")): cv for cv in json.loads(args.cvs.read_text(encoding="utf-8"))}
    jds = {jd.get("id"): jd for jd in json.loads(args.jds.read_text(encoding="utf-8"))}

    enriched: list[tuple[bool, float, dict]] = []
    for row in csv.DictReader(args.pairs.open(encoding="utf-8")):
        cv = cvs.get(row["cv_id"], {})
        jd = jds.get(row["jd_id"], {})
        cv_title, cv_skills = _cv_context(cv)
        out = {
            "label": _starting_label(row),
            "llm_hint": row.get("llm_hint", ""),
            "sim_anchor": row.get("sim_anchor", ""),
            "jd_id": row["jd_id"],
            "jd_title": jd.get("jobTitle", ""),
            "cv_id": row["cv_id"],
            "cv_title": cv_title,
            "cv_skills": cv_skills,
            "jd_requirements": (jd.get("requirements", "") or "")[:160].replace("\n", " "),
            "source": row.get("source", ""),
        }
        for column in SCORE_COLS:
            out[column] = row.get(column, "")
        is_middle = row.get("source") == "middle"
        enriched.append((is_middle, float(row.get("sim_anchor") or 0.0), out))

    # Rows needing review (middle) first, by anchor desc; auto-labelled rows after.
    enriched.sort(key=lambda item: (not item[0], -item[1]))

    with args.out.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=CONTEXT_COLS + SCORE_COLS)
        writer.writeheader()
        for _, _, out in enriched:
            writer.writerow(out)

    middle = [out for is_middle, _, out in enriched if is_middle]
    prefilled = sum(1 for out in middle if out["label"])
    print(f"Wrote {len(enriched)} rows -> {args.out}")
    print(f"  middle rows to review : {len(middle)} (sorted to top by anchor desc)")
    print(f"  pre-filled from LLM   : {prefilled} (YES/NO only -- REVIEW, the LLM is weak)")
    print(f"  blank UNSURE to label : {len(middle) - prefilled}")
    print("\nLabel the top rows (1=match, 0=not, blank=skip), then:")
    print("  python -m scripts.train_svm --data data/label_worksheet.csv --out model/recommender_svm.joblib")


if __name__ == "__main__":
    main()
