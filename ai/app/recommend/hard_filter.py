"""Group 2 -- Hard filter (rule-based, no ML).

Cheap if-else gate that rejects obviously unsuitable CVs before the expensive
vector/semantic steps run. Checks work location, years of experience (derived
from DATE entities), and an optional GPA threshold.
"""

from __future__ import annotations

import re

from ..dates import total_experience_years
from .config import (
    EXPERIENCE_TOLERANCE_YEARS,
    REMOTE_TOKENS,
    LOCATION_ALIASES,
    SENIORITY_YEARS,
)
from .schemas import HardFilterResult, JobDescriptionInput
from .textnorm import normalize


_YEARS_RE = re.compile(r"(\d+(?:\.\d+)?)\s*\+?\s*(?:year|yr|nam)", re.IGNORECASE)
_GPA_RE = re.compile(r"(\d+(?:\.\d+)?)\s*(?:/\s*(\d+(?:\.\d+)?))?")
_GPA_REQ_RE = re.compile(r"gpa[^\d]{0,8}(\d+(?:\.\d+)?)\s*(?:/\s*(\d+(?:\.\d+)?))?")
_LOCATION_STOPWORDS = {
    "city", "province", "tinh", "thanh", "pho", "quan", "district", "the",
}


def run_hard_filter(
    cv: dict,
    jd: JobDescriptionInput,
    *,
    today=None,
    check_location: bool = True,
) -> HardFilterResult:
    """Apply the rule-based gate and return a pass/fail with reasons.

    ``check_location=False`` skips the location gate -- useful when building
    training data from CVs whose locations are out of scope (e.g. foreign
    Kaggle CVs) so pairs can still be scored on the remaining fields.
    """
    by_label = cv.get("entitiesByLabel", {})

    # Prefer the canonical's precomputed work-only years: it was derived with the
    # spans' reading order, so it excludes education periods. The flat DATE list
    # here has no order, so recomputing would re-count a degree's "2022 - Present"
    # as experience. Fall back to it only when the field is absent (e.g. raw dicts).
    precomputed_years = cv.get("totalExperienceYears")
    candidate_years = (
        float(precomputed_years)
        if precomputed_years is not None
        else total_experience_years(by_label.get("DATE", []), today=today)
    )
    required_years = _required_years(jd.experience_level)
    years_ok = candidate_years + EXPERIENCE_TOLERANCE_YEARS >= required_years

    cv_locations = list(by_label.get("CANDIDATE_LOCATION", [])) + list(by_label.get("LOCATION", []))
    location_ok = _location_match(cv_locations, jd.location) if check_location else True

    required_gpa = _required_gpa(jd.requirements)
    candidate_gpa = _parse_gpa(cv.get("gpa") or _first(by_label.get("GPA")))
    gpa_ok = True
    if required_gpa is not None and candidate_gpa is not None:
        gpa_ok = candidate_gpa + 1e-3 >= required_gpa

    reasons: list[str] = []
    if not years_ok:
        reasons.append(
            f"Thiếu kinh nghiệm: ứng viên có {candidate_years:.1f} năm, "
            f"yêu cầu {required_years:.0f} năm."
        )
    if not location_ok:
        reasons.append(f"Địa điểm không phù hợp: vị trí yêu cầu '{jd.location}'.")
    if not gpa_ok:
        reasons.append("GPA chưa đạt mức tối thiểu mà JD yêu cầu.")

    return HardFilterResult(
        passed=years_ok and location_ok and gpa_ok,
        reasons=reasons,
        candidate_years=candidate_years,
        required_years=required_years,
        location_ok=location_ok,
        gpa_ok=gpa_ok,
    )


def _required_years(experience_level: str) -> float:
    text = normalize(experience_level)
    match = _YEARS_RE.search(text)
    if match:
        return float(match.group(1))
    matched = [years for keyword, years in SENIORITY_YEARS.items() if keyword in text]
    return max(matched) if matched else 0.0


def _canonical_location(text: str) -> str:
    cleaned = re.sub(r"[^a-z0-9]+", " ", normalize(text)).strip()
    for alias, canonical in LOCATION_ALIASES.items():
        cleaned = re.sub(rf"\b{re.escape(alias)}\b", canonical, cleaned)
    tokens = [token for token in cleaned.split() if token not in _LOCATION_STOPWORDS]
    return " ".join(tokens)


def _location_match(cv_locations: list[str], jd_location: str) -> bool:
    jd_canonical = _canonical_location(jd_location)
    if not jd_canonical or any(token in jd_canonical for token in REMOTE_TOKENS):
        return True

    candidate = [_canonical_location(loc) for loc in cv_locations if loc.strip()]
    candidate = [loc for loc in candidate if loc]
    if not candidate:
        # Unknown candidate location -- do not hard-reject on missing data.
        return True

    jd_tokens = set(jd_canonical.split())
    for location in candidate:
        if location in jd_canonical or jd_canonical in location:
            return True
        if jd_tokens & set(location.split()):
            return True
    return False


def _required_gpa(requirements: str) -> float | None:
    match = _GPA_REQ_RE.search(normalize(requirements))
    return _gpa_value(match) if match else None


def _parse_gpa(text: str | None) -> float | None:
    if not text:
        return None
    match = _GPA_RE.search(str(text))
    return _gpa_value(match) if match else None


def _gpa_value(match: re.Match) -> float | None:
    value = float(match.group(1))
    denominator = float(match.group(2)) if match.group(2) else None
    if denominator:
        return value / denominator
    if value <= 4.0:
        return value / 4.0
    if value <= 10.0:
        return value / 10.0
    return value / 100.0


def _first(values: list[str] | None) -> str:
    return values[0] if values else ""
