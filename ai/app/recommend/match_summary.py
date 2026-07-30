"""Deterministic, role-aware explanation of a CV-to-JD match.

The content model intentionally scores only skills and experience/projects.
Language, years of experience, certificates, and title are reported separately
so users can see their status without silently turning them into correlated
model features.
"""

from __future__ import annotations

import re
import unicodedata
from typing import Any

from .language_match import language_requirement_status
from .schemas import HardFilterResult


def _normalize_phrase(value: Any) -> str:
    text = unicodedata.normalize("NFKD", str(value or "").lower())
    text = "".join(
        character
        for character in text
        if not unicodedata.combining(character)
    )
    return re.sub(r"[^a-z0-9]+", " ", text).strip()


def _value(payload: dict[str, Any], camel: str, snake: str) -> Any:
    value = payload.get(camel)
    return payload.get(snake) if value is None else value


def _string_list(value: Any) -> list[str]:
    if value is None:
        return []
    if isinstance(value, (list, tuple)):
        return [str(item).strip() for item in value if str(item or "").strip()]
    return [
        item.strip()
        for item in str(value).replace("\n", ",").replace(";", ",").split(",")
        if item.strip()
    ]


def certificate_keywords(jd: dict[str, Any]) -> list[str]:
    """Read preferred certificates from both the generic and language form."""
    output = _string_list(
        _value(jd, "certificateKeywords", "certificate_keywords")
    )
    requirements = (
        _value(jd, "languageRequirements", "language_requirements") or []
    )
    if isinstance(requirements, list):
        for requirement in requirements:
            if not isinstance(requirement, dict):
                continue
            for certificate in requirement.get("certificates") or []:
                if isinstance(certificate, dict):
                    name = (
                        certificate.get("certificateName")
                        or certificate.get("certificate_name")
                    )
                else:
                    name = certificate
                if name and str(name).strip():
                    output.append(str(name).strip())
    return list(dict.fromkeys(output))


def matched_certificates(
    cv: dict[str, Any],
    jd: dict[str, Any],
) -> tuple[list[str], list[str]]:
    requested = certificate_keywords(jd)
    evidence = " ".join(
        str(value)
        for value in (cv.get("entitiesByLabel") or {}).get(
            "CERTIFICATION",
            [],
        )
    )
    normalized_evidence = f" {_normalize_phrase(evidence)} "
    matched = [
        keyword
        for keyword in requested
        if _normalize_phrase(keyword)
        and f" {_normalize_phrase(keyword)} " in normalized_evidence
    ]
    return requested, matched


def _candidate_certificates(cv: dict[str, Any]) -> list[str]:
    return list(dict.fromkeys(
        str(value).strip()
        for value in (cv.get("entitiesByLabel") or {}).get(
            "CERTIFICATION",
            [],
        )
        if str(value or "").strip()
    ))


_DEGREE_LEVELS = {
    "high_school": 1,
    "associate": 2,
    "bachelor": 3,
    "master": 4,
    "phd": 5,
}


def _canonical_degree(value: Any) -> str | None:
    text = f" {_normalize_phrase(value)} "
    aliases = (
        ("phd", (" phd ", " doctorate ", " doctoral ")),
        ("master", (" master ", " masters ", " msc ")),
        ("bachelor", (" bachelor ", " bachelors ", " bsc ")),
        ("associate", (" associate ",)),
        ("high_school", (" high school ", " highschool ")),
    )
    for degree, tokens in aliases:
        if any(token in text for token in tokens):
            return degree
    return None


def education_status(
    cv: dict[str, Any],
    jd: dict[str, Any],
) -> tuple[str, str]:
    """Evaluate structured education separately from the content model.

    Returns ``(state, detail)`` where state is one of ``not_required``,
    ``met``, ``missing``, ``degree_gap`` or ``major_gap``.
    """
    mode = str(
        _value(jd, "educationMode", "education_mode") or ""
    ).strip().upper()
    required_degrees = _string_list(
        _value(jd, "degrees", "education_degrees")
        or _value(jd, "educationLevel", "education_level")
    )
    required_majors = _string_list(
        _value(jd, "educationMajors", "education_majors")
    )
    if mode == "NOT_REQUIRED" or (
        not mode and not required_degrees and not required_majors
    ):
        return "not_required", ""

    education_values = _string_list(
        (cv.get("entitiesByLabel") or {}).get("EDUCATION", [])
    )
    if not education_values:
        return "missing", "No education evidence is stored in the CV."

    education_text = " ".join(education_values)
    candidate_degree = _canonical_degree(education_text)
    canonical_required = [
        degree
        for value in required_degrees
        if (degree := _canonical_degree(value)) is not None
    ]
    degree_ok = True
    if canonical_required:
        if candidate_degree is None:
            degree_ok = False
        elif mode == "MINIMUM":
            degree_ok = _DEGREE_LEVELS[candidate_degree] >= min(
                _DEGREE_LEVELS[degree]
                for degree in canonical_required
            )
        else:
            degree_ok = candidate_degree in canonical_required
    if not degree_ok:
        return (
            "degree_gap",
            "Accepted degree: " + ", ".join(required_degrees) + ".",
        )

    normalized_education = f" {_normalize_phrase(education_text)} "
    major_ok = not required_majors or any(
        normalized_major
        and f" {normalized_major} " in normalized_education
        for major in required_majors
        if (normalized_major := _normalize_phrase(major))
    )
    if not major_ok:
        return (
            "major_gap",
            "Relevant major: " + ", ".join(required_majors) + ".",
        )
    return "met", ""


def language_status(
    cv: dict[str, Any],
    jd: dict[str, Any],
) -> tuple[
    str,
    list[str],
    list[str],
    list[str],
    dict[str, float | None],
]:
    values = (
        (cv.get("entitiesByLabel") or {}).get("LANGUAGE", [])
        + (cv.get("entitiesByLabel") or {}).get("CERTIFICATION", [])
    )
    return language_requirement_status(values, jd)


def _component(
    per_field_scores: dict[str, float],
    *keys: str,
) -> float | None:
    for key in keys:
        if key in per_field_scores:
            return float(per_field_scores[key])
    return None


def build_match_summary(
    *,
    match_score: float,
    per_field_scores: dict[str, float],
    hard_filter: HardFilterResult,
    cv: dict[str, Any],
    jd: dict[str, Any],
    viewer_role: str,
    content_scored: bool = True,
) -> list[str]:
    """Return stable summary lines for applicant or recruiter UI."""
    recruiter = str(viewer_role).strip().upper() == "RECRUITER"
    subject = "Candidate" if recruiter else "You"
    possessive = "the candidate's" if recruiter else "your"

    skill = _component(
        per_field_scores,
        "skill_hybrid_mean",
        "required_skill_coverage",
        "SKILL",
    )
    experience_project = _component(
        per_field_scores,
        "experience_project_direct_similarity",
        "experience_task_similarity",
        "EXPERIENCE",
    )
    bonus = float(per_field_scores.get("certification_bonus", 0.0))
    title_bonus = float(per_field_scores.get("title_bonus", 0.0))
    content_score = _component(per_field_scores, "content_model_score")
    if content_scored and skill is not None and experience_project is not None:
        score_line = f"Overall match: {match_score:.1%}"
        if content_score is not None:
            score_line += f" = content model {content_score:.1%}"
        if bonus > 0:
            score_line += f" + certificate bonus {bonus:.1%}"
        if title_bonus > 0:
            score_line += f" + title bonus {title_bonus:.1%}"
        if (
            content_score is not None
            and content_score + bonus + title_bonus > 1.0
        ):
            score_line += " (capped at 100%)"
        score_line += (
            f"; inputs: skills {skill:.1%}, "
            f"experience/projects {experience_project:.1%}."
        )
    else:
        score_line = (
            f"Overall match: {match_score:.1%} — content scoring was not run "
            "because an eligibility rule was not met."
        )

    lines = [score_line]

    if (
        hard_filter.required_years > 0
        and hard_filter.candidate_years + 1e-9 < hard_filter.required_years
    ):
        shortfall = hard_filter.required_years - hard_filter.candidate_years
        gate_note = (
            " It is still within the allowed one-year tolerance."
            if hard_filter.exp_fit >= 1
            else " The YOE eligibility rule is not met."
        )
        experience_line = (
            f"Experience: currently short by {shortfall:.1f} years — "
            f"{possessive} confirmed "
            f"{hard_filter.candidate_years:.1f} years vs "
            f"{hard_filter.required_years:.1f} required."
            + gate_note
        )
        lines.append(experience_line)

    education_state, education_detail = education_status(cv, jd)
    if education_state == "missing":
        lines.append(
            "Education: the JD has a structured education requirement, but "
            f"{possessive} CV has no education evidence."
        )
    elif education_state == "degree_gap":
        lines.append(
            "Education: the stored degree does not meet the JD's accepted "
            f"degree rule. {education_detail}"
        )
    elif education_state == "major_gap":
        lines.append(
            "Education: the stored major does not match the JD's listed "
            f"relevant majors. {education_detail}"
        )

    (
        language_state,
        met_languages,
        language_gaps,
        unknown_languages,
        language_evidence_map,
    ) = (
        language_status(cv, jd)
    )
    if language_state == "met":
        language_line = (
            f"Language: requirement met ({', '.join(met_languages)})."
        )
        lines.append(language_line)
    elif language_state == "gap":
        language_line = (
            "Language: missing or below the required level "
            f"({', '.join(language_gaps)})."
        )
        if met_languages:
            language_line += f" Already met: {', '.join(met_languages)}."
        lines.append(language_line)
    elif language_state == "unknown":
        lines.append(
            "Language: evidence was found in the CV/certificate, but its "
            "level or score is not recorded for "
            f"{', '.join(unknown_languages)}; verify the required level."
        )
    elif recruiter and language_evidence_map:
        languages = ", ".join(
            language.title()
            for language in sorted(language_evidence_map)
        )
        lines.append(
            f"Additional language evidence: {languages}; the JD does not "
            "require it and it is not included in the core score."
        )

    requested_certificates, found_certificates = matched_certificates(cv, jd)
    candidate_certificates = _candidate_certificates(cv)
    if requested_certificates and found_certificates:
        verb = "has" if recruiter else "have"
        certificate_line = (
            f"Certificates: {subject.lower()} {verb} evidence for "
            f"{', '.join(found_certificates)}; bonus applied: +{bonus:.1%}."
        )
        lines.append(certificate_line)
    elif requested_certificates:
        certificate_line = (
            f"Certificates: {', '.join(requested_certificates)} is listed but "
            f"not found in {possessive} CV; it is bonus-only, not a rejection rule."
        )
        lines.append(certificate_line)
    elif recruiter and candidate_certificates:
        lines.append(
            "Additional certificates: "
            f"{', '.join(candidate_certificates)}; the JD does not request "
            "them and no certificate bonus is applied."
        )

    role_alignment = _component(per_field_scores, "role_alignment", "JOB_TITLE")
    jd_title = str(_value(jd, "jobTitle", "job_title") or "").strip()
    cv_titles = [
        str(value).strip()
        for value in (cv.get("entitiesByLabel") or {}).get("JOB_TITLE", [])
        if str(value or "").strip()
    ]
    if not jd_title:
        title_line = "Job title: the JD has no title to compare."
    elif not cv_titles:
        title_line = (
            f"Job title: no reliable title was found in {possessive} CV; "
            "title does not reduce the core score."
        )
    elif role_alignment is None:
        title_line = (
            f"Job title: {cv_titles[0]} vs {jd_title}; semantic title "
            "comparison was not run because an eligibility rule stopped "
            "content scoring."
        )
    else:
        if _normalize_phrase(cv_titles[0]) == _normalize_phrase(jd_title):
            status = "matches exactly"
        elif role_alignment >= 0.75:
            status = "is in the same role family as"
        elif role_alignment >= 0.25:
            status = "is related to"
        else:
            status = "does not match"
        title_line = (
            f"Job title: {cv_titles[0]} {status} {jd_title}; "
            "title is suggestion-only and does not reduce the core score."
        )

    lines.append(title_line)
    return lines
