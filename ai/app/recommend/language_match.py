"""Deterministic matching for conditional JD language requirements."""

from __future__ import annotations

import re
import unicodedata
from collections.abc import Iterable, Mapping
from typing import Any


LANGUAGE_ALIASES = {
    "english": ("english", "anglais"),
    "vietnamese": ("vietnamese", "tieng viet"),
    "japanese": ("japanese", "nihongo", "tieng nhat"),
    "chinese": ("chinese", "mandarin", "tieng trung"),
    "korean": ("korean", "tieng han"),
    "french": ("french", "francais", "tieng phap"),
    "spanish": ("spanish", "espanol", "tieng tay ban nha"),
    "german": ("german", "deutsch", "tieng duc"),
    "italian": ("italian", "tieng y"),
    "dutch": ("dutch",),
    "indonesian": ("indonesian", "bahasa indonesia"),
    "norwegian": ("norwegian", "norsk"),
    "finnish": ("finnish",),
    "hindi": ("hindi",),
    "urdu": ("urdu",),
    "arabic": ("arabic",),
}

CEFR_SCORES = {
    "a1": 1 / 6,
    "a2": 2 / 6,
    "b1": 3 / 6,
    "b2": 4 / 6,
    "c1": 5 / 6,
    "c2": 1.0,
}

WORD_LEVEL_SCORES = {
    "beginner": 0.25,
    "elementary": 0.33,
    "conversational": 0.50,
    "intermediate": 0.55,
    "upper intermediate": 0.67,
    "business conversational": 0.75,
    "professional": 0.80,
    "advanced": 0.85,
    "fluent": 0.90,
    "native": 1.0,
}


def normalize_text(value: Any) -> str:
    text = unicodedata.normalize("NFKD", str(value or "").lower())
    text = "".join(
        character
        for character in text
        if not unicodedata.combining(character)
    )
    return re.sub(r"[^a-z0-9.]+", " ", text).strip()


def canonical_language(value: Any) -> str | None:
    normalized = f" {normalize_text(value)} "
    for language, aliases in LANGUAGE_ALIASES.items():
        if any(f" {alias} " in normalized for alias in aliases):
            return language
    return None


def _score_ielts(text: str) -> float | None:
    match = re.search(
        r"(?:\bielts\b[^0-9]{0,24}(\d(?:\.\d)?)\b|"
        r"\b(\d(?:\.\d)?)\s*(?:overall\s*)?\bielts\b)",
        text,
    )
    if not match:
        return None
    score = float(match.group(1) or match.group(2))
    if score >= 8.5:
        return 1.0
    if score >= 7.0:
        return CEFR_SCORES["c1"]
    if score >= 5.5:
        return CEFR_SCORES["b2"]
    if score >= 4.0:
        return CEFR_SCORES["b1"]
    return CEFR_SCORES["a2"]


def _score_toeic(text: str) -> float | None:
    match = re.search(
        r"(?:\btoeic\b[^0-9]{0,40}(\d{3})\b|"
        r"\b(\d{3})\s*(?:points?\s*)?\btoeic\b)",
        text,
    )
    if not match:
        return None
    score = int(match.group(1) or match.group(2))
    if score >= 945:
        return CEFR_SCORES["c1"]
    if score >= 785:
        return CEFR_SCORES["b2"]
    if score >= 550:
        return CEFR_SCORES["b1"]
    return CEFR_SCORES["a2"]


def proficiency_score(value: Any) -> float | None:
    """Map common language levels/certificates to an ordered [0, 1] scale."""
    text = normalize_text(value)
    scores: list[float] = []
    for level, score in CEFR_SCORES.items():
        if re.search(rf"\b{level}\b", text):
            scores.append(score)
    for phrase, score in WORD_LEVEL_SCORES.items():
        if phrase in text:
            scores.append(score)
    jlpt = re.search(r"\b(?:jlpt\s*)?n([1-5])\b", text)
    if jlpt:
        scores.append((6 - int(jlpt.group(1))) / 5)
    hsk = re.search(r"\bhsk\s*([1-9])\b", text)
    if hsk:
        denominator = 9 if int(hsk.group(1)) > 6 else 6
        scores.append(int(hsk.group(1)) / denominator)
    for certificate_score in (_score_ielts(text), _score_toeic(text)):
        if certificate_score is not None:
            scores.append(certificate_score)
    return max(scores) if scores else None


def language_evidence_details(
    values: Iterable[Any],
) -> dict[str, float | None]:
    """Return language evidence while preserving an unknown proficiency.

    A certificate name such as ``TOEIC Listening and Reading`` proves English
    evidence exists, but without a point/level it must not be treated as a
    confirmed B1/B2 score.
    """
    flattened = [str(value) for value in values if str(value or "").strip()]
    output: dict[str, float | None] = {}

    def record(language: str, score: float | None) -> None:
        previous = output.get(language)
        if language not in output or (
            score is not None and (previous is None or score > previous)
        ):
            output[language] = score

    # Backend certificate fields may arrive separately (name/provider/point).
    # Inspect their combined text so ["TOEIC ...", "900"] still becomes B2.
    combined = normalize_text(" ".join(flattened))
    if "toeic" in combined:
        record("english", _score_toeic(combined))
    if "ielts" in combined:
        record("english", _score_ielts(combined))
    jlpt = re.search(r"\b(?:jlpt\s*)?n[1-5]\b", combined)
    if jlpt:
        record("japanese", proficiency_score(jlpt.group(0)))
    hsk = re.search(r"\bhsk\s*[1-9]\b", combined)
    if hsk:
        record("chinese", proficiency_score(hsk.group(0)))

    most_recent_language: str | None = None
    for value in flattened:
        language = canonical_language(value)
        if language is not None:
            most_recent_language = language
        elif any(token in normalize_text(value) for token in ("ielts", "toeic")):
            language = "english"
        elif re.search(r"\b(?:jlpt\s*)?n[1-5]\b", normalize_text(value)):
            language = "japanese"
        elif re.search(r"\bhsk\s*[1-9]\b", normalize_text(value)):
            language = "chinese"
        else:
            language = most_recent_language
        if language is None:
            continue
        score = proficiency_score(value)
        record(language, score)
    return output


def language_evidence(values: Iterable[Any]) -> dict[str, float]:
    """Return numeric evidence for scoring compatibility.

    Unknown-but-present evidence retains the historical neutral value 0.50;
    hard-filter decisions use :func:`language_evidence_details` instead.
    """
    return {
        language: 0.50 if score is None else score
        for language, score in language_evidence_details(values).items()
    }


def _requirement_values(jd: Mapping[str, Any]) -> list[Mapping[str, Any]]:
    raw = jd.get("languageRequirements") or jd.get("language_requirements") or []
    return [item for item in raw if isinstance(item, Mapping)]


def language_requirement_status(
    values: Iterable[Any],
    jd: Mapping[str, Any],
) -> tuple[
    str,
    list[str],
    list[str],
    list[str],
    dict[str, float | None],
]:
    """Check required languages without treating unknown levels as failures.

    State is ``not_required``, ``met``, ``unknown`` or ``gap``. Missing
    evidence and explicitly insufficient levels are gaps; certificate evidence
    with no score/level is unknown and therefore passes provisionally.
    """
    requirements = _requirement_values(jd)
    required_flag = jd.get("languageRequired")
    if required_flag is None:
        required_flag = jd.get("language_required")
    evidence = language_evidence_details(values)
    if required_flag is False or not requirements:
        return "not_required", [], [], [], evidence

    met: list[str] = []
    gaps: list[str] = []
    unknown: list[str] = []
    for requirement in requirements:
        raw_name = str(
            requirement.get("languageName")
            or requirement.get("language_name")
            or "specified language"
        ).strip()
        raw_level = str(
            requirement.get("proficiencyLevel")
            or requirement.get("proficiency_level")
            or ""
        ).strip()
        label = f"{raw_name} ({raw_level})" if raw_level else raw_name
        language = canonical_language(raw_name)
        if language is None or language not in evidence:
            gaps.append(label)
            continue
        observed = evidence[language]
        required = proficiency_score(raw_level)
        if required is not None and observed is None:
            unknown.append(label)
        elif (
            required is not None
            and observed is not None
            and observed + 1e-9 < required
        ):
            gaps.append(label)
        else:
            met.append(label)

    state = "gap" if gaps else "unknown" if unknown else "met"
    return state, met, gaps, unknown, evidence


def language_gap(
    cv_language_values: Iterable[Any],
    jd: Mapping[str, Any],
) -> float:
    """Return 0 for no gap and 1 for completely missing required evidence."""
    requirements = _requirement_values(jd)
    required_flag = jd.get("languageRequired")
    if required_flag is None:
        required_flag = jd.get("language_required")
    if required_flag is False or not requirements:
        return 0.0

    evidence = language_evidence(cv_language_values)
    gaps: list[float] = []
    for requirement in requirements:
        raw_name = (
            requirement.get("languageName")
            or requirement.get("language_name")
            or ""
        )
        language = canonical_language(raw_name)
        if language is None or language not in evidence:
            gaps.append(1.0)
            continue
        raw_level = (
            requirement.get("proficiencyLevel")
            or requirement.get("proficiency_level")
            or ""
        )
        required_score = proficiency_score(raw_level)
        if required_score is None or required_score <= 0:
            gaps.append(0.0)
            continue
        observed_score = evidence[language]
        gaps.append(max(0.0, required_score - observed_score) / required_score)
    return sum(gaps) / len(gaps) if gaps else 0.0
