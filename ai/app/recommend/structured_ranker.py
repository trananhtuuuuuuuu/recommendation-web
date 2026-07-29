"""Runtime feature builder and scorer for structured ranker v2.1/v2.2."""

from __future__ import annotations

import json
import re
import unicodedata
from typing import Any

import numpy as np

from .embeddings import cosine_embed_batch, embeddings_available


def normalize_phrase(value: Any) -> str:
    text = str(value or "").lower()
    replacements = {
        "asp.net": " aspnet ",
        ".net": " dotnet ",
        "c#": " csharp ",
        "c++": " cplusplus ",
        "ci/cd": " cicd ",
        "react.js": " react ",
        "node.js": " nodejs ",
        "scikit-learn": " scikit learn ",
    }
    for source, target in replacements.items():
        text = text.replace(source, target)
    text = unicodedata.normalize("NFKD", text)
    text = "".join(
        character
        for character in text
        if not unicodedata.combining(character)
    )
    return re.sub(r"[^a-z0-9]+", " ", text).strip()


def _payload_value(payload: dict[str, Any], camel: str, snake: str) -> Any:
    value = payload.get(camel)
    return payload.get(snake) if value is None else value


def _text(payload: dict[str, Any], camel: str, snake: str) -> str:
    value = _payload_value(payload, camel, snake)
    return str(value or "").strip()


def _string_list(value: Any) -> list[str]:
    if value is None:
        return []
    if isinstance(value, (list, tuple)):
        return [
            str(item).strip()
            for item in value
            if item is not None and str(item).strip()
        ]
    text = str(value).strip()
    if not text:
        return []
    try:
        parsed = json.loads(text)
    except json.JSONDecodeError:
        parsed = None
    if isinstance(parsed, list):
        return _string_list(parsed)
    return [
        item.strip()
        for item in re.split(r"[,;\n|]", text)
        if item.strip()
    ]


def _catalog(bundle: dict[str, Any]) -> dict[str, tuple[str, ...]]:
    return {
        str(canonical): tuple(str(alias) for alias in aliases)
        for canonical, aliases in (bundle.get("skill_catalog") or {}).items()
    }


def _extract_skills(
    text: str,
    catalog: dict[str, tuple[str, ...]],
) -> set[str]:
    normalized = f" {normalize_phrase(text)} "
    return {
        canonical
        for canonical, aliases in catalog.items()
        if any(f" {alias} " in normalized for alias in aliases if alias)
    }


def _required_units(
    jd: dict[str, Any],
    catalog: dict[str, tuple[str, ...]],
) -> tuple[set[str], str]:
    explicit = [
        *_string_list(_payload_value(jd, "requiredSkills", "required_skills")),
        *_string_list(_payload_value(jd, "techStack", "tech_stack")),
    ]
    if explicit:
        required: set[str] = set()
        for item in explicit:
            known = _extract_skills(item, catalog)
            required.update(known or {f"custom:{normalize_phrase(item)}"})
        return required, ". ".join(explicit)

    requirements = _text(jd, "requirements", "requirements")
    required_text, _ = _split_required_preferred(requirements)
    return _extract_skills(required_text, catalog), required_text


def _split_required_preferred(requirements: str) -> tuple[str, str]:
    trailing_plus = re.search(
        r"(?P<clause>(?:^|[.;])\s*[^.;]*?)\s+"
        r"(?:is|are|would\s+be)\s+a\s+plus\b",
        requirements,
        flags=re.IGNORECASE,
    )
    if trailing_plus:
        clause = trailing_plus.group("clause").lstrip(".; ").strip()
        remaining = requirements[trailing_plus.end() :].lstrip(".; ")
        preferred = ". ".join(
            part for part in (clause, remaining) if part
        )
        return requirements[: trailing_plus.start()].rstrip(), preferred
    match = re.search(
        r"\b(?:nice\s+to\s+have|preferred)\b",
        requirements,
        flags=re.IGNORECASE,
    )
    if not match:
        return requirements, ""
    return requirements[: match.start()], requirements[match.end() :]


def _join_entities(cv: dict[str, Any], labels: tuple[str, ...]) -> str:
    by_label = cv.get("entitiesByLabel") or {}
    return ". ".join(
        str(value)
        for label in labels
        for value in (by_label.get(label) or [])
        if str(value).strip()
    )


def _matched_required(
    required: set[str],
    cv_skills: set[str],
    cv_evidence: str,
) -> set[str]:
    normalized_evidence = f" {normalize_phrase(cv_evidence)} "
    matched = required & cv_skills
    matched.update(
        skill
        for skill in required
        if skill.startswith("custom:")
        and skill.removeprefix("custom:")
        and f" {skill.removeprefix('custom:')} " in normalized_evidence
    )
    return matched


def _role_taxonomy(text: str) -> str:
    normalized = normalize_phrase(text)
    rules = (
        ("product_design", ("product designer", "ux designer", "ui designer")),
        ("qa", ("qa ", "quality assurance", "test automation", "tester")),
        ("mobile", ("mobile developer", "android", "ios developer", "flutter")),
        ("frontend", ("frontend", "front end", "react developer", "ui developer")),
        ("integration", ("integration engineer", "middleware", "biztalk")),
        ("devops_cloud", ("devops", "cloud architect", "cloud engineer", "infrastructure")),
        ("machine_learning", ("machine learning", "data scientist", "ai engineer", "ml engineer")),
        ("data_engineering", ("data engineer", "data platform", "database developer", "big data")),
        ("data_analytics", ("data analyst", "business intelligence", "bi analyst")),
        ("business_analysis", ("business analyst",)),
        ("backend", ("backend", "back end", "dotnet developer", "java developer", "software engineer")),
    )
    for role, keywords in rules:
        if any(keyword in normalized for keyword in keywords):
            return role
    return "unknown"


def _role_alignment(cv_titles: list[Any], jd_title: str) -> float:
    jd_role = _role_taxonomy(jd_title)
    cv_roles = {
        _role_taxonomy(str(title))
        for title in cv_titles
        if _role_taxonomy(str(title)) != "unknown"
    }
    if jd_role == "unknown" or not cv_roles:
        return 0.0
    if jd_role in cv_roles:
        return 1.0
    related = {
        "data_engineering": {"data_analytics", "machine_learning", "backend"},
        "data_analytics": {"data_engineering", "machine_learning", "business_analysis"},
        "machine_learning": {"data_engineering", "data_analytics"},
        "integration": {"backend", "devops_cloud"},
        "backend": {"integration", "frontend"},
        "frontend": {"backend", "mobile"},
        "devops_cloud": {"integration", "backend"},
        "business_analysis": {"data_analytics"},
        "mobile": {"frontend"},
    }
    return 0.5 if cv_roles & related.get(jd_role, set()) else 0.0


def build_structured_features(
    cv: dict[str, Any],
    jd: dict[str, Any],
    bundle: dict[str, Any],
) -> dict[str, float]:
    """Build the exact feature schema declared by a structured artifact."""
    if not embeddings_available():
        raise RuntimeError("Structured embedding model is unavailable")

    catalog = _catalog(bundle)
    required, required_text = _required_units(jd, catalog)
    cv_evidence = _join_entities(
        cv,
        ("SKILL", "CERTIFICATION", "SUMMARY", "EXPERIENCE", "PROJECT"),
    )
    cv_skills = _extract_skills(cv_evidence, catalog)
    matched = _matched_required(required, cv_skills, cv_evidence)
    coverage = len(matched) / len(required) if required else 0.0
    cv_skill_count = len(cv_skills | {skill for skill in matched if skill.startswith("custom:")})
    precision = len(matched) / cv_skill_count if cv_skill_count else 0.0
    skill_f1 = (
        2.0 * coverage * precision / (coverage + precision)
        if coverage + precision
        else 0.0
    )

    description = _text(jd, "jobDescription", "job_description")
    legacy_requirements = _text(jd, "requirements", "requirements")
    semantic_requirements = ". ".join(
        part for part in (legacy_requirements, required_text) if part
    )
    responsibility_labels = tuple(
        bundle.get("responsibility_labels")
        or ("SUMMARY", "EXPERIENCE", "PROJECT")
    )
    responsibility_text = _join_entities(cv, responsibility_labels)
    experience_text = _join_entities(cv, ("EXPERIENCE",))
    project_text = _join_entities(cv, ("PROJECT",))
    responsibility, experience, project = cosine_embed_batch(
        [
            (responsibility_text, description),
            (experience_text, description),
            (project_text, f"{description}. {semantic_requirements}"),
        ]
    )

    skill_idf = bundle.get("skill_idf") or {}
    denominator = sum(float(skill_idf.get(skill, 1.0)) for skill in required)
    numerator = sum(float(skill_idf.get(skill, 1.0)) for skill in matched)
    weighted_coverage = numerator / denominator if denominator else 0.0
    by_label = cv.get("entitiesByLabel") or {}
    features = {
        "required_skill_coverage": coverage,
        "weighted_required_skill_coverage": weighted_coverage,
        "required_skill_f1": skill_f1,
        "responsibility_similarity": responsibility,
        "experience_task_similarity": experience,
        "project_evidence": project,
        "experience_present": float(bool(experience_text.strip())),
        "role_alignment": _role_alignment(
            list(by_label.get("JOB_TITLE") or []),
            _text(jd, "jobTitle", "job_title"),
        ),
    }
    return {name: float(value) for name, value in features.items()}


def _calibrated_probability(bundle: dict[str, Any], vector: list[float]) -> float:
    model = bundle["model"]
    calibrator = bundle["calibrator"]
    margin = np.asarray(model.decision_function([vector]), dtype=float)
    if hasattr(calibrator, "predict_proba"):
        probability = calibrator.predict_proba(margin.reshape(-1, 1))[0][1]
    else:
        probability = calibrator.predict(margin)[0]
    return max(0.0, min(1.0, float(probability)))


def score_structured_ranker(
    cv: dict[str, Any],
    jd: dict[str, Any],
    bundle: dict[str, Any],
) -> tuple[float, str, dict[str, float]]:
    features = build_structured_features(cv, jd, bundle)
    order = tuple(bundle["feature_order"])
    probability = _calibrated_probability(
        bundle,
        [features[name] for name in order],
    )
    title_bonus = 0.0
    title_cap = float(bundle.get("title_cap") or 0.0)
    title_gate = float(bundle.get("title_coverage_gate") or 0.4)
    if features["required_skill_coverage"] >= title_gate:
        title_bonus = title_cap * features["role_alignment"]
    certification_bonus = 0.0
    certification_mode = _text(
        jd,
        "certificationMode",
        "certification_mode",
    ).upper()
    certificate_keywords = _string_list(
        _payload_value(
            jd,
            "certificateKeywords",
            "certificate_keywords",
        )
    )
    if certification_mode == "PREFERRED" and certificate_keywords:
        certificate_text = f" {normalize_phrase(_join_entities(cv, ('CERTIFICATION',)))} "
        matched_certificates = sum(
            bool(
                normalize_phrase(keyword)
                and f" {normalize_phrase(keyword)} " in certificate_text
            )
            for keyword in certificate_keywords
        )
        certification_bonus = float(
            bundle.get("certification_cap") or 0.03
        ) * matched_certificates / len(certificate_keywords)
    score = min(1.0, probability + title_bonus + certification_bonus)
    visible = {
        name: round(features[name], 4)
        for name in order
    }
    visible["role_alignment"] = round(features["role_alignment"], 4)
    visible["title_bonus"] = round(title_bonus, 4)
    visible["certification_bonus"] = round(certification_bonus, 4)
    reason = (
        f"{bundle['model_id']} content-first score: required skills "
        f"{features['required_skill_coverage']:.0%}, responsibilities "
        f"{features['responsibility_similarity']:.0%}, experience tasks "
        f"{features['experience_task_similarity']:.0%}, projects "
        f"{features['project_evidence']:.0%}."
    )
    return round(score, 4), reason, visible
