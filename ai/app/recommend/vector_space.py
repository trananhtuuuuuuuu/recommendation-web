"""Group 3 -- Vector Space Model for entity/keyword fields.

Scores SKILL, SOFT_SKILL, LANGUAGE, CERTIFICATION, JOB_TITLE, COMPANY, EDUCATION
by turning each into a vector and measuring CV-vs-JD similarity. TF-IDF + cosine
is the primary method; Word2Vec + WMD is available as a comparison baseline.
"""

from __future__ import annotations

from typing import Any

from .config import VECTOR_FIELDS
from .jd_fields import jd_field_text
from .schemas import FieldScore, JobDescriptionInput
from .vectorize import cosine_tfidf_batch, wmd_word2vec


def score_vector_fields(
    masked_entities: dict[str, list[str]],
    jd: JobDescriptionInput,
    *,
    method: str = "tfidf",
    keyed_vectors: Any | None = None,
) -> list[FieldScore]:
    """Return a per-field similarity score for every Group 3 field."""
    pairs = [
        (field, " ".join(masked_entities.get(field, [])), jd_field_text(field, jd))
        for field in VECTOR_FIELDS
    ]
    text_pairs = [(cv_text, jd_text) for _, cv_text, jd_text in pairs]
    if method == "word2vec" and keyed_vectors is not None:
        scores = [wmd_word2vec(cv_text, jd_text, keyed_vectors) for cv_text, jd_text in text_pairs]
    elif method == "embedding":
        from .embeddings import cosine_embed_batch

        scores = cosine_embed_batch(text_pairs)
    else:
        scores = cosine_tfidf_batch(text_pairs)

    return [
        FieldScore(field, cv_text, jd_text, score)
        for (field, cv_text, jd_text), score in zip(pairs, scores)
    ]
