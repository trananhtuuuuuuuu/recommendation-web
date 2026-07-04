"""Recompute the training table's per-field scores with sentence embeddings.

The labels (anchor bands + Claude's domain judgements) stay fixed; only the
feature columns are recomputed with ``method="embedding"`` so we can train and
compare an embedding-based SVM against the TF-IDF one. Reads the labelled
worksheet, rescores every pair from the full canonical CVs in cvs.json, and
writes label_worksheet_emb.csv (same columns, embedding scores).

    python -m scripts.rescore_embeddings
    python -m scripts.train_svm --data data/label_worksheet_emb.csv --out model/recommender_svm.joblib
"""

from __future__ import annotations

import csv
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from app.recommend.config import FIELD_ORDER  # noqa: E402
from app.recommend.masking import mask_entities  # noqa: E402
from app.recommend.schemas import JobDescriptionInput  # noqa: E402
from app.recommend.semantic import score_semantic_fields  # noqa: E402
from app.recommend.vector_space import score_vector_fields  # noqa: E402

AI_DIR = pathlib.Path(__file__).resolve().parents[1]
SCORE_COLS = [field.lower() for field in FIELD_ORDER]


def main() -> None:
    worksheet = AI_DIR / "data" / "label_worksheet.csv"
    out = AI_DIR / "data" / "label_worksheet_emb.csv"
    cvs = {str(cv.get("id")): cv for cv in json.loads((AI_DIR / "data" / "cvs.json").read_text("utf-8"))}
    jds = {jd["id"]: JobDescriptionInput.from_dict(jd)
           for jd in json.loads((AI_DIR / "data" / "jds.json").read_text("utf-8"))}

    rows = list(csv.DictReader(worksheet.open(encoding="utf-8")))
    print(f"rescoring {len(rows)} pairs with embeddings (first run downloads the model)...")
    for index, row in enumerate(rows):
        cv = cvs.get(row["cv_id"])
        jd = jds.get(row["jd_id"])
        if cv is None or jd is None:
            continue
        masked = mask_entities(cv.get("entitiesByLabel", {}))
        field_scores = (
            score_vector_fields(masked, jd, method="embedding")
            + score_semantic_fields(masked, jd, method="embedding")
        )
        per_field = {score.field: score.score for score in field_scores}
        for field in FIELD_ORDER:
            row[field.lower()] = round(per_field.get(field, 0.0), 4)
        if (index + 1) % 100 == 0:
            print(f"  {index + 1}/{len(rows)}")

    with out.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
