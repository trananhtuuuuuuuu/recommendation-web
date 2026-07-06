"""Single source of truth for recommender fields, weights, and JD mappings."""

from __future__ import annotations

import json
from pathlib import Path


DATA_DIR = Path(__file__).resolve().parent / "data"
MODEL_DIR = Path(__file__).resolve().parents[2] / "model"
SVM_MODEL_PATH = MODEL_DIR / "recommender_svm.joblib"
WORD2VEC_PATH = MODEL_DIR / "word2vec.kv"

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

# Tolerance (years) applied before penalising on experience.
EXPERIENCE_TOLERANCE_YEARS = 0.5

# Years of experience is a noisy proxy for knowledge (and is itself derived from
# error-prone DATE entities), while the candidate's real knowledge is already
# scored directly via SKILL / EXPERIENCE / PROJECT / EDUCATION. So experience is
# a SOFT penalty, not a hard gate: a shortfall scales the final score down via
# exp_fit in [FLOOR, 1.0] instead of rejecting. Only an egregious gap -- short by
# more than EXPERIENCE_HARD_GAP_YEARS -- still hard-rejects (e.g. a fresher
# applying to a senior role).
EXPERIENCE_HARD_GAP_YEARS = 3.0
EXPERIENCE_FIT_FLOOR = 0.5

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
