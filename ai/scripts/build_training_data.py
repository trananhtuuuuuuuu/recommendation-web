"""Build the SVM training table from CVs x JDs with anchor-threshold labelling.

Now that the JDs match the CV pool, the anchor similarity (SKILL + JOB_TITLE +
EXPERIENCE + EDUCATION) is a reliable labeller at the two extremes:
  * anchor >= --hi  -> label 1 (clear same-role match)
  * anchor <= --lo  -> label 0 (clear non-match)
  * in between       -> left blank for manual review (needs_manual.csv).

The optional --llm flag adds a (advisory only) Ollama YES/NO/UNSURE hint for the
middle rows; it is NOT used as the label because a small local model is noisy.

Usage:
    python -m scripts.build_training_data                 # anchor bands only
    python -m scripts.build_training_data --llm           # + advisory LLM hint on middle
"""

from __future__ import annotations

import argparse
import csv
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from app.recommend.config import FIELD_ORDER  # noqa: E402
from app.recommend.hard_filter import run_hard_filter  # noqa: E402
from app.recommend.llm_suggest import ollama_available, ollama_generate  # noqa: E402
from app.recommend.masking import mask_entities  # noqa: E402
from app.recommend.schemas import JobDescriptionInput  # noqa: E402
from app.recommend.semantic import score_semantic_fields  # noqa: E402
from app.recommend.vector_space import score_vector_fields  # noqa: E402

AI_DIR = pathlib.Path(__file__).resolve().parents[1]
ANCHOR_FIELDS = ("SKILL", "JOB_TITLE", "EXPERIENCE", "EDUCATION")


def score_pair(cv: dict, jd: JobDescriptionInput) -> dict[str, float]:
    masked = mask_entities(cv.get("entitiesByLabel", {}))
    field_scores = score_vector_fields(masked, jd) + score_semantic_fields(masked, jd)
    return {score.field: score.score for score in field_scores}


def cv_preview(cv: dict) -> str:
    by_label = cv.get("entitiesByLabel", {})
    title = (by_label.get("JOB_TITLE") or [""])[0]
    skills = ", ".join(by_label.get("SKILL", [])[:3])
    return f"{title} | {skills}".strip(" |")


def _cv_text(cv: dict) -> str:
    by_label = cv.get("entitiesByLabel", {})
    titles = ", ".join(by_label.get("JOB_TITLE", [])[:3])
    skills = ", ".join(by_label.get("SKILL", [])[:15])
    experience = " ".join(by_label.get("EXPERIENCE", [])[:3])[:400]
    return f"TITLE: {titles}\nSKILLS: {skills}\nEXPERIENCE: {experience}"


def _jd_text(jd: JobDescriptionInput) -> str:
    return f"TITLE: {jd.job_title}\nREQUIREMENTS: {jd.requirements[:500]}"


def llm_hint(cv: dict, jd: JobDescriptionInput, model: str) -> str:
    """Advisory only: YES/NO/UNSURE from a local model to help manual review."""
    prompt = (
        "You are a technical recruiter matching a resume to a job. Reply with ONLY one "
        "word: YES, NO, or UNSURE.\nYES = same role/field with overlapping skills. "
        "NO = clearly different field. UNSURE = related but not clearly the same.\n\n"
        f"=== JOB ===\n{_jd_text(jd)}\n\n=== CANDIDATE ===\n{_cv_text(cv)}\n\nAnswer:"
    )
    try:
        response = ollama_generate(prompt, model=model, num_predict=4).strip().upper()
    except Exception:
        return ""
    if response.startswith("YES"):
        return "YES"
    if response.startswith("NO"):
        return "NO"
    return "UNSURE"


def main() -> None:
    parser = argparse.ArgumentParser(description="Build the SVM training table (anchor bands).")
    parser.add_argument("--cvs", type=pathlib.Path, default=AI_DIR / "data" / "cvs.json")
    parser.add_argument("--jds", type=pathlib.Path, default=AI_DIR / "data" / "jds.json")
    parser.add_argument("--out", type=pathlib.Path, default=AI_DIR / "data" / "labeled_pairs.csv")
    parser.add_argument("--manual-out", type=pathlib.Path, default=AI_DIR / "data" / "needs_manual.csv")
    parser.add_argument("--hi", type=float, default=0.50, help="anchor >= hi -> label 1")
    parser.add_argument("--lo", type=float, default=0.12, help="anchor <= lo -> label 0")
    parser.add_argument("--llm", action="store_true", help="add advisory LLM hint to middle rows")
    parser.add_argument("--model", default="qwen2.5:3b", help="Ollama model for the advisory hint")
    parser.add_argument("--keep-location", action="store_true", help="enforce the location gate")
    parser.add_argument("--limit-cvs", type=int, default=0, help="use only the first N CVs (0=all)")
    args = parser.parse_args()

    cvs = json.loads(args.cvs.read_text(encoding="utf-8"))
    if args.limit_cvs:
        cvs = cvs[: args.limit_cvs]
    jds = json.loads(args.jds.read_text(encoding="utf-8"))
    use_llm = args.llm and ollama_available()
    if args.llm and not use_llm:
        print("⚠️  Ollama not reachable -- skipping the advisory hint.")

    rows: list[dict] = []
    pruned = pos = neg = middle = 0

    for jd_raw in jds:
        jd_id = jd_raw.get("id", jd_raw.get("jobTitle", "jd"))
        jd = JobDescriptionInput.from_dict(jd_raw)

        survivors = []
        for cv in cvs:
            if not run_hard_filter(cv, jd, check_location=args.keep_location).passed:
                pruned += 1
                continue
            scores = score_pair(cv, jd)
            anchor = sum(scores.get(field, 0.0) for field in ANCHOR_FIELDS)
            survivors.append((cv, scores, anchor))

        survivors.sort(key=lambda item: item[2], reverse=True)
        for cv, scores, anchor in survivors:
            hint = ""
            if anchor >= args.hi:
                label, source = "1", "auto-pos"
                pos += 1
            elif anchor <= args.lo:
                label, source = "0", "auto-neg"
                neg += 1
            else:
                label, source = "", "middle"
                middle += 1
                if use_llm:
                    hint = llm_hint(cv, jd, args.model)

            row = {field.lower(): round(scores.get(field, 0.0), 4) for field in FIELD_ORDER}
            row.update(
                label=label,
                source=source,
                llm_hint=hint,
                sim_anchor=round(anchor, 4),
                cv_id=cv.get("id", ""),
                jd_id=jd_id,
                cv_preview=cv_preview(cv),
            )
            rows.append(row)

    fieldnames = (
        [field.lower() for field in FIELD_ORDER]
        + ["label", "source", "llm_hint", "sim_anchor", "cv_id", "jd_id", "cv_preview"]
    )
    with args.out.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    manual_rows = sorted(
        (row for row in rows if not row["label"]),
        key=lambda row: row["sim_anchor"],
        reverse=True,
    )
    manual_fields = ["cv_id", "jd_id", "sim_anchor", "llm_hint", "cv_preview"]
    with args.manual_out.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=manual_fields)
        writer.writeheader()
        writer.writerows({key: row[key] for key in manual_fields} for row in manual_rows)

    print(f"\nWrote {len(rows)} rows to {args.out}")
    print(f"  hard-filter pruned : {pruned} pairs")
    print(f"  auto label 1 (>= {args.hi}) : {pos}")
    print(f"  auto label 0 (<= {args.lo}) : {neg}")
    print(f"  middle (manual)    : {middle}  -> {args.manual_out}")
    print(f"\n{pos + neg} confident labels are ready to train on now. Review the middle to add more.")
    print("Edit the 'label' column (1/0, blank=skip) in labeled_pairs.csv, then run scripts.train_svm.")


if __name__ == "__main__":
    main()
