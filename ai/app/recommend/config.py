"""Single source of truth for recommender fields, weights, and JD mappings."""

from __future__ import annotations

import json
import os
from pathlib import Path


DATA_DIR = Path(__file__).resolve().parent / "data"
MODEL_DIR = Path(__file__).resolve().parents[2] / "model"
SVM_MODEL_PATH = MODEL_DIR / "recommender_svm.joblib"
WORD2VEC_PATH = MODEL_DIR / "word2vec.kv"
STRUCTURED_MODEL_PATHS = {
    "logistic": MODEL_DIR / "content_logistic_primary.joblib",
    "v21": MODEL_DIR / "recommender_svm_v21_primary.joblib",
    "v22": MODEL_DIR / "recommender_svm_v22_backup.joblib",
}

# Group 1 -- PII labels removed before any scoring.
MASK_LABELS = ("NAME", "EMAIL", "PHONE", "LINK")

# Group 2 -- labels consumed by the rule-based hard filter.
LOCATION_LABELS = ("CANDIDATE_LOCATION", "LOCATION")

# Group 3 -- entity/keyword fields scored with the vector space model.
VECTOR_FIELDS = (
    "SKILL", "SOFT_SKILL", "LANGUAGE", "CERTIFICATION", "JOB_TITLE", "COMPANY", "EDUCATION",
)

# Group 4 -- long free-text fields scored with semantic (TF-IDF) matching.
SEMANTIC_FIELDS = ("SUMMARY", "EXPERIENCE", "PROJECT")

# Group 5 -- feature-vector column order for the SVM / heuristic decision.
FIELD_ORDER = VECTOR_FIELDS + SEMANTIC_FIELDS

# Which JD column(s) each CV field is compared against (the JD arrives already
# filled into these structured tags, so no JD parsing is required).
JD_FIELD_SOURCES: dict[str, tuple[str, ...]] = {
    # Keyword fields draw from the keyword-dense requirements column; prose is
    # left to the semantic fields to avoid diluting short keyword vectors.
    "SKILL": ("requirements",),
    "SOFT_SKILL": ("requirements", "benefits"),
    "LANGUAGE": ("requirements",),
    "CERTIFICATION": ("requirements",),
    "JOB_TITLE": ("job_title", "experience_level"),
    "COMPANY": ("about_company", "industry"),
    "EDUCATION": ("requirements",),
    "SUMMARY": ("job_description", "about_company"),
    "EXPERIENCE": ("job_description", "requirements"),
    "PROJECT": ("job_description", "requirements"),
}

# Reader-facing English display names used in match explanations.
FIELD_DISPLAY_NAMES: dict[str, str] = {
    "SKILL": "technical skills",
    "SOFT_SKILL": "soft skills",
    "LANGUAGE": "languages",
    "CERTIFICATION": "certifications",
    "JOB_TITLE": "job title",
    "COMPANY": "company background",
    "EDUCATION": "education",
    "SUMMARY": "professional summary",
    "EXPERIENCE": "work experience",
    "PROJECT": "projects",
    "required_skill_coverage": "required-skill coverage",
    "weighted_required_skill_coverage": "weighted required-skill coverage",
    "required_skill_f1": "required-skill balance",
    "responsibility_similarity": "responsibility alignment",
    "experience_task_similarity": "experience-task alignment",
    "project_evidence": "project evidence",
    "experience_present": "experience evidence",
    "role_alignment": "role alignment",
    "skill_semantic_similarity": "semantic skill alignment",
    "skill_exact_coverage": "required-skill coverage",
    "skill_hybrid_mean": "hybrid skill alignment",
    "experience_project_direct_similarity": "experience and project alignment",
    "content_model_score": "content model score",
}

FIELD_DISPLAY_NAMES_EN = FIELD_DISPLAY_NAMES

# Heuristic fallback weights (used before an SVM is trained). Sum ~= 1.0.
_DEFAULT_WEIGHTS: dict[str, float] = {
    "SKILL": 0.20,
    "JOB_TITLE": 0.15,
    "EXPERIENCE": 0.15,
    "EDUCATION": 0.10,
    "SUMMARY": 0.10,
    "CERTIFICATION": 0.08,
    "PROJECT": 0.08,
    "LANGUAGE": 0.07,
    "SOFT_SKILL": 0.04,
    "COMPANY": 0.03,
}

# Seniority keyword -> minimum years of experience (Group 2).
# Keys are accent-stripped so they match normalize()d text.
SENIORITY_YEARS: dict[str, float] = {
    "intern": 0.0, "internship": 0.0, "fresher": 0.0, "entry": 0.0, "thuc tap": 0.0,
    "junior": 1.0, "mid": 3.0, "middle": 3.0, "intermediate": 3.0,
    "senior": 5.0, "lead": 8.0, "principal": 8.0, "manager": 8.0, "head": 10.0,
}

# YOE is handled before content scoring. A candidate may be up to one year below
# the form's minimum; a larger confirmed gap is ineligible. There is no second
# experience multiplier inside/after the content model.
EXPERIENCE_TOLERANCE_YEARS = 1.0

# Tokens that mean a location requirement is open (auto-pass the hard filter).
REMOTE_TOKENS = ("remote", "tu xa", "anywhere", "wfh", "hybrid")

# Common location aliases (accent-stripped) treated as equivalent.
LOCATION_ALIASES: dict[str, str] = {
    "hcm": "ho chi minh",
    "hcmc": "ho chi minh",
    "tphcm": "ho chi minh",
    "tp hcm": "ho chi minh",
    "sai gon": "ho chi minh",
    "saigon": "ho chi minh",
    "hn": "ha noi",
    "hanoi": "ha noi",
    "da nang": "da nang",
    "danang": "da nang",
}


def load_field_weights() -> dict[str, float]:
    """Load heuristic weights from data/field_weights.json, falling back to defaults."""
    path = DATA_DIR / "field_weights.json"
    try:
        loaded = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return dict(_DEFAULT_WEIGHTS)
    return {field: float(loaded.get(field, _DEFAULT_WEIGHTS[field])) for field in FIELD_ORDER}


def display_name(field: str) -> str:
    return FIELD_DISPLAY_NAMES.get(field, field)


def display_name_en(field: str) -> str:
    """Reader-facing English name for a field (match reason + LLM suggestions)."""
    return FIELD_DISPLAY_NAMES_EN.get(field, field.replace("_", " ").lower())


def svm_model_path(method: str = "tfidf") -> Path:
    """Model file for a scoring method -- the features must match how it was trained.

    The default TF-IDF model is ``recommender_svm.joblib``; an embedding-trained
    model lives beside it as ``recommender_svm_embedding.joblib`` so the two never
    get mixed up (TF-IDF features fed to an embedding-trained SVM would be wrong).
    """
    if method == "embedding":
        return MODEL_DIR / "recommender_svm_embedding.joblib"
    return SVM_MODEL_PATH


def recommender_sequence() -> tuple[str, ...]:
    """Configured primary followed by technical fallbacks, without duplicates."""
    primary = os.getenv("AI_RECOMMENDER_PRIMARY", "logistic").strip().lower()
    fallbacks = os.getenv(
        "AI_RECOMMENDER_FALLBACKS",
        "v21,v22,legacy",
    ).split(",")
    ordered = [primary, *(item.strip().lower() for item in fallbacks)]
    allowed = {*STRUCTURED_MODEL_PATHS, "legacy"}
    return tuple(
        model
        for index, model in enumerate(ordered)
        if model in allowed and model not in ordered[:index]
    )


def hard_filter_enabled() -> bool:
    """Whether hard-filter results are enforced instead of retained for audit only."""
    return os.getenv("AI_HARD_FILTER_ENABLED", "true").strip().lower() not in {
        "0",
        "false",
        "no",
        "off",
    }
