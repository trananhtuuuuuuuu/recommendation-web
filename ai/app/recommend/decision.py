"""Group 5 -- Decision model (aggregate score + explainable recommendation).

Aggregates the per-field similarity scores from Groups 3 and 4 into a single
match score. A trained LinearSVC (Field-to-Field Weighting) is used when present;
otherwise a heuristic weighted average provides a sensible cold-start score.
The "Lý do khuyến nghị" picks the field with the highest weight x score.
"""

from __future__ import annotations

import math
from typing import Any

from .config import FIELD_ORDER, display_name_en, load_field_weights, svm_model_path


def to_feature_vector(per_field_scores: dict[str, float]) -> list[float]:
    """Order the per-field scores into the SVM feature vector (missing -> 0)."""
    return [float(per_field_scores.get(field, 0.0)) for field in FIELD_ORDER]


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
        score = _svm_score(bundle.get("pipeline"), to_feature_vector(per_field_scores))
        model_used = "svm"
    else:
        weights = load_field_weights()
        score = _heuristic_score(per_field_scores, weights)
        model_used = "heuristic"
    return score, _explain(per_field_scores, weights), model_used


def strong_fields(per_field_scores: dict[str, float], limit: int = 3) -> list[str]:
    """Field names with the highest similarity (the candidate's strengths)."""
    ranked = sorted(FIELD_ORDER, key=lambda field: per_field_scores.get(field, 0.0), reverse=True)
    return [field for field in ranked if per_field_scores.get(field, 0.0) >= 0.30][:limit]


def weak_fields(per_field_scores: dict[str, float], threshold: float = 0.15) -> list[str]:
    """Field names scoring below ``threshold`` (gaps to improve)."""
    return [field for field in FIELD_ORDER if per_field_scores.get(field, 0.0) < threshold]


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
