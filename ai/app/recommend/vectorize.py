"""Similarity primitives shared by the vector-space and semantic groups.

TF-IDF + cosine is the primary, always-available scorer. Word2Vec + Word Mover's
Distance is an optional comparison baseline (gensim is imported lazily so the
default build does not require it).
"""

from __future__ import annotations

from pathlib import Path
from typing import Any

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

from .config import WORD2VEC_PATH
from .textnorm import tokenize


def _new_vectorizer() -> TfidfVectorizer:
    return TfidfVectorizer(
        tokenizer=tokenize,
        token_pattern=None,
        lowercase=False,
        ngram_range=(1, 2),
        sublinear_tf=True,
    )


def cosine_tfidf_batch(pairs: list[tuple[str, str]]) -> list[float]:
    """Cosine similarity for each (cv, jd) pair using one TF-IDF space.

    The vectorizer is fit over *all* texts in the batch (the field collection of
    a single match), so IDF is meaningful and shared terms are not penalised the
    way a per-pair, two-document fit would penalise them.
    """
    corpus = [text.strip() for pair in pairs for text in pair if text and text.strip()]
    if not corpus:
        return [0.0] * len(pairs)

    vectorizer = _new_vectorizer()
    try:
        vectorizer.fit(corpus)
    except ValueError:
        return [0.0] * len(pairs)

    scores: list[float] = []
    for cv_text, jd_text in pairs:
        if not (cv_text or "").strip() or not (jd_text or "").strip():
            scores.append(0.0)
            continue
        matrix = vectorizer.transform([cv_text, jd_text])
        score = float(cosine_similarity(matrix[0], matrix[1])[0][0])
        scores.append(round(max(0.0, min(1.0, score)), 4))
    return scores


def cosine_tfidf(cv_text: str, jd_text: str) -> float:
    """Cosine TF-IDF similarity for a single (cv, jd) pair."""
    return cosine_tfidf_batch([(cv_text, jd_text)])[0]


def wmd_word2vec(cv_text: str, jd_text: str, keyed_vectors: Any) -> float:
    """Similarity from Word Mover's Distance, mapped to [0, 1] via 1/(1+d)."""
    cv_tokens = [token for token in tokenize(cv_text) if token in keyed_vectors]
    jd_tokens = [token for token in tokenize(jd_text) if token in keyed_vectors]
    if not cv_tokens or not jd_tokens:
        return 0.0

    distance = keyed_vectors.wmdistance(cv_tokens, jd_tokens)
    if distance is None or distance == float("inf") or distance != distance:
        return 0.0
    return round(1.0 / (1.0 + distance), 4)


def load_word2vec(path: Path = WORD2VEC_PATH) -> Any | None:
    """Load saved KeyedVectors for the WMD baseline, or None if unavailable."""
    if not Path(path).exists():
        return None
    try:
        from gensim.models import KeyedVectors
    except ImportError:
        return None
    return KeyedVectors.load(str(path))
