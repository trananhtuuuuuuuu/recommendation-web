"""Semantic embedding similarity (sentence-transformers) for field scoring.

A higher-quality alternative to the lexical TF-IDF cosine: sentence embeddings
capture meaning across vocabulary gaps -- "Spark"/"Kafka" ~ "big data / ETL",
"Data Engineer" ~ "Database Developer" -- so the SKILL/EXPERIENCE features
discriminate match from non-match far better than word overlap does.

The model is lazy-loaded and cached, and per-text vectors are memoised so the
same JD column is not re-encoded for every CV. If sentence-transformers or the
model download is unavailable, ``cosine_embed_batch`` falls back to TF-IDF so the
pipeline keeps working.
"""

from __future__ import annotations

import os
from functools import lru_cache
from typing import Any


# Small, fast, well-benchmarked default; override with RECO_EMBED_MODEL (e.g.
# "sentence-transformers/all-mpnet-base-v2" for higher quality, slower on CPU).
EMBED_MODEL = os.getenv("RECO_EMBED_MODEL", "sentence-transformers/all-MiniLM-L6-v2")

# text -> normalized vector, so a JD column shared by many CVs is encoded once.
_VECTOR_CACHE: dict[str, Any] = {}


@lru_cache(maxsize=1)
def _load_model() -> Any | None:
    try:
        from sentence_transformers import SentenceTransformer

        return SentenceTransformer(EMBED_MODEL)
    except Exception:
        return None


def sentence_transformers_installed() -> bool:
    """Cheap check (no model load) that the embedding backend could run."""
    import importlib.util

    return importlib.util.find_spec("sentence_transformers") is not None


def embeddings_available() -> bool:
    """Whether the embedding model loaded (deps installed + weights reachable)."""
    return _load_model() is not None


def _encode(texts: list[str]) -> list[Any]:
    model = _load_model()
    missing = [text for text in texts if text not in _VECTOR_CACHE]
    if missing:
        vectors = model.encode(
            missing,
            normalize_embeddings=True,
            convert_to_numpy=True,
            batch_size=64,
            show_progress_bar=False,
        )
        for text, vector in zip(missing, vectors):
            _VECTOR_CACHE[text] = vector
    return [_VECTOR_CACHE[text] for text in texts]


def cosine_embed_batch(pairs: list[tuple[str, str]]) -> list[float]:
    """Cosine similarity per (cv, jd) pair using sentence embeddings.

    Mirrors ``vectorize.cosine_tfidf_batch`` so it is a drop-in scorer. Empty
    sides score 0.0; falls back to TF-IDF when the model is unavailable.
    """
    model = _load_model()
    if model is None:
        from .vectorize import cosine_tfidf_batch

        return cosine_tfidf_batch(pairs)

    unique = []
    seen: set[str] = set()
    for cv_text, jd_text in pairs:
        for text in (cv_text, jd_text):
            cleaned = (text or "").strip()
            if cleaned and cleaned not in seen:
                seen.add(cleaned)
                unique.append(cleaned)
    if not unique:
        return [0.0] * len(pairs)

    import numpy as np

    vectors = dict(zip(unique, _encode(unique)))
    scores: list[float] = []
    for cv_text, jd_text in pairs:
        cv_clean = (cv_text or "").strip()
        jd_clean = (jd_text or "").strip()
        if not cv_clean or not jd_clean:
            scores.append(0.0)
            continue
        similarity = float(np.dot(vectors[cv_clean], vectors[jd_clean]))
        scores.append(round(max(0.0, min(1.0, similarity)), 4))
    return scores
