"""Group 4 -- Semantic matching for long free-text fields.

Scores SUMMARY, EXPERIENCE, PROJECT. TF-IDF + cosine is the default; passing
``method="embedding"`` swaps in sentence-transformer similarity, which captures
meaning across vocabulary gaps far better on these prose fields.
"""

from __future__ import annotations

from .config import SEMANTIC_FIELDS
from .jd_fields import jd_field_text
from .schemas import FieldScore, JobDescriptionInput
from .vectorize import cosine_tfidf_batch


def score_semantic_fields(
    masked_entities: dict[str, list[str]],
    jd: JobDescriptionInput,
    *,
    method: str = "tfidf",
) -> list[FieldScore]:
    """Return a per-field similarity score for every Group 4 field."""
    pairs = [
        (field, " ".join(masked_entities.get(field, [])), jd_field_text(field, jd))
        for field in SEMANTIC_FIELDS
    ]
    text_pairs = [(cv_text, jd_text) for _, cv_text, jd_text in pairs]
    if method == "embedding":
        from .embeddings import cosine_embed_batch

        scores = cosine_embed_batch(text_pairs)
    else:
        scores = cosine_tfidf_batch(text_pairs)
    return [
        FieldScore(field, cv_text, jd_text, score)
        for (field, cv_text, jd_text), score in zip(pairs, scores)
    ]
