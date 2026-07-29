"""Group 5 -- Decision model (aggregate score + explainable recommendation).

Aggregates the per-field similarity scores from Groups 3 and 4 into a single
match score. A trained LinearSVC (Field-to-Field Weighting) is used when present;
otherwise a heuristic weighted average provides a sensible cold-start score.
The recommendation reason picks the field with the highest weight x score.
"""

from __future__ import annotations

import math
import logging
from dataclasses import dataclass
from functools import lru_cache
from typing import Any

from .config import (
    FIELD_ORDER,
    STRUCTURED_MODEL_PATHS,
    display_name_en,
    load_field_weights,
    recommender_sequence,
    svm_model_path,
)
from .structured_ranker import score_structured_ranker


LOGGER = logging.getLogger(__name__)


@dataclass
class DecisionOutcome:
    score: float
    reason: str
    model_used: str
    scoring_method: str
    per_field_scores: dict[str, float]


def to_feature_vector(
    per_field_scores: dict[str, float],
    field_order=FIELD_ORDER,
) -> list[float]:
    """Order the per-field scores into the SVM feature vector (missing -> 0)."""
    return [float(per_field_scores.get(field, 0.0)) for field in field_order]


def load_model(method: str = "tfidf", path=None) -> dict | None:
    """Load the trained SVM bundle {pipeline, weights} for ``method``, or None.

    The model must match the scoring method (its features were computed that way),
    so the path is chosen per method unless an explicit ``path`` is given.
    """
    target = path or svm_model_path(method)
    try:
        import joblib
    except ImportError:
        return None
    try:
        if not target.exists():
            return None
        return joblib.load(target)
    except (OSError, ValueError):
        return None


def decide(per_field_scores: dict[str, float], *, method: str = "tfidf") -> tuple[float, str, str]:
    """Return (match_score in [0,1], reason, model_used)."""
    bundle = load_model(method)
    if bundle is not None:
        weights = bundle.get("weights") or load_field_weights()
        model_field_order = bundle.get("field_order") or FIELD_ORDER
        score = _svm_score(
            bundle.get("pipeline"),
            to_feature_vector(per_field_scores, model_field_order),
        )
        model_used = "svm"
    else:
        weights = load_field_weights()
        score = _heuristic_score(per_field_scores, weights)
        model_used = "heuristic"
    return score, _explain(per_field_scores, weights), model_used


@lru_cache(maxsize=2)
def load_structured_model(model_id: str) -> dict | None:
    target = STRUCTURED_MODEL_PATHS.get(model_id)
    if target is None:
        return None
    try:
        import joblib

        if not target.exists():
            return None
        bundle = joblib.load(target)
        if bundle.get("model_id") != model_id:
            return None
        return bundle
    except (ImportError, OSError, ValueError, KeyError):
        return None


def decide_registered(
    cv: dict[str, Any],
    jd: dict[str, Any],
    legacy_scores_provider: Any,
    *,
    method: str,
) -> DecisionOutcome:
    """Use the configured primary and fall back only on technical failure."""
    failures: list[str] = []
    for model_id in recommender_sequence():
        try:
            if model_id in STRUCTURED_MODEL_PATHS:
                bundle = load_structured_model(model_id)
                if bundle is None:
                    raise RuntimeError("artifact unavailable or incompatible")
                score, reason, scores = score_structured_ranker(
                    cv,
                    jd,
                    bundle,
                )
                return DecisionOutcome(
                    score=score,
                    reason=reason,
                    model_used=f"structured_svm_{model_id}",
                    scoring_method="structured_embedding",
                    per_field_scores=scores,
                )

            if load_model(method) is None:
                raise RuntimeError(
                    f"legacy {method} artifact unavailable or incompatible"
                )
            legacy_scores = legacy_scores_provider()
            score, reason, engine = decide(legacy_scores, method=method)
            return DecisionOutcome(
                score=score,
                reason=reason,
                model_used=f"legacy_{engine}_{method}",
                scoring_method=method,
                per_field_scores=legacy_scores,
            )
        except Exception as exception:
            failures.append(f"{model_id}: {exception}")
            LOGGER.warning(
                "Recommender %s failed (%s); trying configured fallback",
                model_id,
                exception,
            )
    raise RuntimeError(
        "No recommender in the configured sequence succeeded: "
        + "; ".join(failures)
    )


def recommender_health() -> dict[str, Any]:
    sequence = recommender_sequence()
    status = {
        model_id: (
            load_structured_model(model_id) is not None
            if model_id in STRUCTURED_MODEL_PATHS
            else load_model("embedding") is not None
        )
        for model_id in sequence
    }
    return {
        "primary": sequence[0] if sequence else None,
        "fallbacks": list(sequence[1:]),
        "available": status,
    }


def strong_fields(per_field_scores: dict[str, float], limit: int = 3) -> list[str]:
    """Field names with the highest similarity (the candidate's strengths)."""
    ranked = sorted(
        per_field_scores,
        key=lambda field: per_field_scores.get(field, 0.0),
        reverse=True,
    )
    return [field for field in ranked if per_field_scores.get(field, 0.0) >= 0.30][:limit]


def weak_fields(per_field_scores: dict[str, float], threshold: float = 0.15) -> list[str]:
    """Field names scoring below ``threshold`` (gaps to improve)."""
    return [
        field
        for field, score in per_field_scores.items()
        # Optional bonuses can lift a score when present, but their absence must
        # never be presented to the applicant/recruiter as a missing requirement.
        if not field.endswith("_bonus") and score < threshold
    ]


def _heuristic_score(per_field_scores: dict[str, float], weights: dict[str, float]) -> float:
    total_weight = sum(weights.get(field, 0.0) for field in FIELD_ORDER)
    if total_weight <= 0:
        return 0.0
    weighted = sum(
        weights.get(field, 0.0) * per_field_scores.get(field, 0.0) for field in FIELD_ORDER
    )
    return round(weighted / total_weight, 4)


def _svm_score(pipeline: Any, features: list[float]) -> float:
    if pipeline is None:
        return 0.0
    sample = [features]
    if hasattr(pipeline, "predict_proba"):
        return round(float(pipeline.predict_proba(sample)[0][1]), 4)
    margin = float(pipeline.decision_function(sample)[0])
    return round(1.0 / (1.0 + math.exp(-margin)), 4)


def _explain(per_field_scores: dict[str, float], weights: dict[str, float]) -> str:
    """A natural-language reason, English, highlighting the top contributing fields.

    Fields are ranked by weight x score (their pull on the decision) and the top 5
    with a positive contribution are named, each with its own match strength.
    """
    contributions = {
        field: weights.get(field, 0.0) * per_field_scores.get(field, 0.0)
        for field in FIELD_ORDER
    }
    ranked = sorted(contributions.items(), key=lambda item: item[1], reverse=True)
    top = [(field, per_field_scores.get(field, 0.0)) for field, value in ranked if value > 0][:5]
    if not top:
        return (
            "There isn't enough overlap between this CV and the job description "
            "to point to a clear match yet."
        )
    lead_field, lead_score = top[0]
    lead = f"{display_name_en(lead_field)} ({lead_score:.0%})"
    if len(top) == 1:
        return f"This candidate fits the role best on {lead}."
    rest = [f"{display_name_en(field)} ({score:.0%})" for field, score in top[1:]]
    rest_text = ", ".join(rest[:-1]) + (" and " if len(rest) > 1 else "") + rest[-1]
    return (
        f"This candidate lines up strongly with the role — most of all on {lead}, "
        f"with solid alignment on {rest_text}."
    )
