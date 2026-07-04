"""Compare TF-IDF vs Word2Vec/WMD on the Group 3 fields (thesis evaluation).

Prints a per-field comparison table averaged over a set of CV/JD pairs. Pairs are
read from a JSON file (list of {"cv": {...canonical...}, "jd": {...}}); a small
built-in sample is used when no file is given.

Usage:
    python -m scripts.evaluate_vectors [--pairs pairs.json]
"""

from __future__ import annotations

import argparse
import json
import pathlib
import statistics
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from app.recommend.config import VECTOR_FIELDS, display_name  # noqa: E402
from app.recommend.masking import mask_entities  # noqa: E402
from app.recommend.schemas import JobDescriptionInput  # noqa: E402
from app.recommend.vector_space import score_vector_fields  # noqa: E402
from app.recommend.vectorize import load_word2vec  # noqa: E402


_SAMPLE = [
    {
        "cv": {
            "entitiesByLabel": {
                "SKILL": ["Java", "Spring Boot", "PostgreSQL"],
                "JOB_TITLE": ["Backend Software Engineer"],
                "CERTIFICATION": ["AWS Cloud Practitioner"],
                "EDUCATION": ["HCMUS - Computer Science"],
            }
        },
        "jd": {
            "jobTitle": "Backend Software Engineer",
            "requirements": "Java, Spring Boot, PostgreSQL. AWS is a plus.",
        },
    },
    {
        "cv": {
            "entitiesByLabel": {
                "SKILL": ["Photoshop", "Illustrator"],
                "JOB_TITLE": ["Graphic Designer"],
            }
        },
        "jd": {
            "jobTitle": "Backend Software Engineer",
            "requirements": "Java, Spring Boot, PostgreSQL.",
        },
    },
]


def load_pairs(path: pathlib.Path | None) -> list[dict]:
    if path is None:
        return _SAMPLE
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> None:
    parser = argparse.ArgumentParser(description="Compare TF-IDF vs Word2Vec/WMD.")
    parser.add_argument("--pairs", type=pathlib.Path, default=None)
    args = parser.parse_args()

    pairs = load_pairs(args.pairs)
    keyed_vectors = load_word2vec()
    if keyed_vectors is None:
        print("(Word2Vec model not found -- run scripts.train_word2vec for the w2v column)")

    tfidf: dict[str, list[float]] = {field: [] for field in VECTOR_FIELDS}
    word2vec: dict[str, list[float]] = {field: [] for field in VECTOR_FIELDS}

    for pair in pairs:
        cv = pair["cv"]
        masked = mask_entities(cv.get("entitiesByLabel", cv))
        jd = JobDescriptionInput.from_dict(pair["jd"])
        for score in score_vector_fields(masked, jd, method="tfidf"):
            tfidf[score.field].append(score.score)
        if keyed_vectors is not None:
            for score in score_vector_fields(masked, jd, method="word2vec", keyed_vectors=keyed_vectors):
                word2vec[score.field].append(score.score)

    print(f"\n{'Field':16}{'TF-IDF':>10}{'Word2Vec':>10}")
    print("-" * 36)
    for field in VECTOR_FIELDS:
        tfidf_mean = statistics.mean(tfidf[field]) if tfidf[field] else 0.0
        if word2vec[field]:
            w2v_text = f"{statistics.mean(word2vec[field]):>10.3f}"
        else:
            w2v_text = f"{'n/a':>10}"
        print(f"{display_name(field):16}{tfidf_mean:>10.3f}{w2v_text}")


if __name__ == "__main__":
    main()
