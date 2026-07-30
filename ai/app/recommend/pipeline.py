"""Orchestration -- run the five groups end to end.

mask -> hard-filter audit -> optional enforcement -> vector + semantic ->
decision -> LLM suggestion.
"""

from __future__ import annotations

from .config import hard_filter_enabled, svm_model_path
from .decision import decide_registered, strong_fields, weak_fields
from .embeddings import sentence_transformers_installed
from .hard_filter import run_hard_filter
from .llm_suggest import suggest
from .match_summary import build_match_summary
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
    viewer_role: str = "APPLICANT",
) -> MatchResult:
    """Score a canonical CV against a structured JD and explain the result."""
    raw_jd = jd if isinstance(jd, dict) else {
        "jobTitle": jd.job_title,
        "jobDescription": jd.job_description,
        "requirements": jd.requirements,
        "experienceLevel": jd.experience_level,
        "minimumYearsExperience": jd.minimum_years_experience,
    }
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
    enforce_hard_filter = hard_filter_enabled()
    if enforce_hard_filter and not hard.passed:
        summary = build_match_summary(
            match_score=0.0,
            per_field_scores={},
            hard_filter=hard,
            cv=cv_canonical,
            jd=raw_jd,
            viewer_role=viewer_role,
            content_scored=False,
        )
        return MatchResult(
            passed_filter=False,
            hard_filter=hard,
            hard_filter_enforced=True,
            per_field_scores={},
            match_score=0.0,
            scoring_method=method,
            reason=hard.reasons[0] if hard.reasons else "Did not pass the hard filter.",
            model_used="n/a",
            suggestions=summary,
        )

    masked = mask_entities(cv_canonical.get("entitiesByLabel", {}))
    legacy_cache: dict[str, float] | None = None

    def legacy_scores() -> dict[str, float]:
        nonlocal legacy_cache
        if legacy_cache is None:
            keyed_vectors = load_word2vec() if method == "word2vec" else None
            field_scores = score_vector_fields(
                masked,
                jd,
                method=method,
                keyed_vectors=keyed_vectors,
            ) + score_semantic_fields(masked, jd, method=method)
            legacy_cache = {
                score.field: score.score for score in field_scores
            }
        return legacy_cache

    outcome = decide_registered(
        cv_canonical,
        raw_jd,
        legacy_scores,
        method=method,
    )
    match_score = outcome.score
    reason = outcome.reason
    model_used = outcome.model_used
    per_field = outcome.per_field_scores
    summary = build_match_summary(
        match_score=match_score,
        per_field_scores=per_field,
        hard_filter=hard,
        cv=cv_canonical,
        jd=raw_jd,
        viewer_role=viewer_role,
    )
    guidance = suggest(
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
        viewer_role=viewer_role,
    )
    # Keep the factual form stable even when the optional LLM is unavailable or
    # varies its wording. Optional status lines are omitted when they add no
    # decision value; at most two role-specific actions follow the summary.
    suggestions = summary + guidance[:2]

    return MatchResult(
        # When disabled, the original hard-filter result remains in ``hard_filter``
        # for audit/reporting but cannot reject or penalise the candidate.
        passed_filter=hard.passed if enforce_hard_filter else True,
        hard_filter=hard,
        hard_filter_enforced=enforce_hard_filter,
        per_field_scores=per_field,
        match_score=match_score,
        scoring_method=outcome.scoring_method,
        reason=reason,
        model_used=model_used,
        suggestions=suggestions,
    )
