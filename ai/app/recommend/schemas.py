"""Data contracts for the recommendation pipeline."""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any


# Mapping of dataclass fields to the camelCase keys the Java backend may send.
_JD_ALIASES = {
    "job_title": "jobTitle",
    "about_company": "aboutCompany",
    "job_description": "jobDescription",
    "salary_range": "salaryRange",
    "job_type": "jobType",
    "experience_level": "experienceLevel",
}


@dataclass
class JobDescriptionInput:
    """A job description already filled into structured tags."""

    job_title: str = ""
    about_company: str = ""
    job_description: str = ""
    requirements: str = ""
    benefits: str = ""
    location: str = ""
    salary_range: str = ""
    job_type: str = ""
    experience_level: str = ""
    industry: str = ""

    @classmethod
    def from_dict(cls, payload: dict[str, Any] | None) -> "JobDescriptionInput":
        payload = payload or {}

        def pick(name: str) -> str:
            value = payload.get(name)
            if value is None and name in _JD_ALIASES:
                value = payload.get(_JD_ALIASES[name])
            return str(value).strip() if value is not None else ""

        return cls(**{name: pick(name) for name in cls.__dataclass_fields__})


@dataclass
class HardFilterResult:
    """Outcome of the rule-based gate (Group 2)."""

    passed: bool
    reasons: list[str] = field(default_factory=list)
    candidate_years: float = 0.0
    required_years: float = 0.0
    location_ok: bool = True
    gpa_ok: bool = True
    # Soft experience-fit multiplier in [FLOOR, 1.0]; < 1.0 means the candidate is
    # short on years but not enough to be rejected -- the final score is scaled by it.
    exp_fit: float = 1.0


@dataclass
class FieldScore:
    """A per-field similarity score with the texts it was computed from."""

    field: str
    cv_text: str
    jd_text: str
    score: float


@dataclass
class MatchResult:
    """Full result returned by the pipeline / the /match endpoint."""

    passed_filter: bool
    hard_filter: HardFilterResult
    per_field_scores: dict[str, float] = field(default_factory=dict)
    match_score: float = 0.0
    scoring_method: str = "tfidf"
    reason: str = ""
    model_used: str = "heuristic"
    suggestions: list[str] | None = None
