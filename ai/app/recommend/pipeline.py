"""Orchestration -- run the five groups end to end.

mask -> hard filter -> (short-circuit if rejected) -> vector + semantic ->
decision -> LLM suggestion.
"""

from __future__ import annotations

from .config import svm_model_path
from .decision import decide, strong_fields, weak_fields
from .embeddings import sentence_transformers_installed
from .hard_filter import run_hard_filter
from .llm_suggest import suggest
from .masking import mask_entities
from .schemas import JobDescriptionInput, MatchResult
from .semantic import score_semantic_fields
from .vector_space import score_vector_fields
from .vectorize import load_word2vec


def run_match(
    cv_canonical: dict,
    jd: JobDescriptionInput | dict,
    *,
    today=None,
    method: str = "tfidf",
    enable_llm: bool = False,
) -> MatchResult:
    """Score a canonical CV against a structured JD and explain the result."""
    if isinstance(jd, dict):
        jd = JobDescriptionInput.from_dict(jd)

    # Embedding is the preferred method, but degrade to TF-IDF when the backend
    # (sentence-transformers + the embedding-trained model) is not present, so the
    # features always match the model that scores them.
    if method == "embedding" and not (
        sentence_transformers_installed() and svm_model_path("embedding").exists()
    ):
        method = "tfidf"

    hard = run_hard_filter(cv_canonical, jd, today=today)
    if not hard.passed:
        return MatchResult(
            passed_filter=False,
            hard_filter=hard,
            per_field_scores={},
            match_score=0.0,
            scoring_method=method,
            reason=hard.reasons[0] if hard.reasons else "Không vượt qua bộ lọc cứng.",
            model_used="n/a",
            suggestions=None,
        )

    masked = mask_entities(cv_canonical.get("entitiesByLabel", {}))
    keyed_vectors = load_word2vec() if method == "word2vec" else None
    field_scores = score_vector_fields(
        masked, jd, method=method, keyed_vectors=keyed_vectors
    ) + score_semantic_fields(masked, jd, method=method)
    per_field = {score.field: score.score for score in field_scores}

    match_score, reason, model_used = decide(per_field, method=method)
    suggestions = suggest(
        match_score=match_score,
        jd_title=jd.job_title,
        strong=strong_fields(per_field),
        weak=weak_fields(per_field),
        reason=reason,
        use_llm=enable_llm,
        per_field_scores=per_field,
        jd_requirements=jd.requirements,
        cv_skills=", ".join(masked.get("SKILL", [])[:15]),
        cv_summary=cv_canonical.get("summary") or "",
    )

    return MatchResult(
        passed_filter=True,
        hard_filter=hard,
        per_field_scores=per_field,
        match_score=match_score,
        scoring_method=method,
        reason=reason,
        model_used=model_used,
        suggestions=suggestions,
    )
