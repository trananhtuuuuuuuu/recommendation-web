"""Convert LayoutLMv3 entities and document text into profile fields."""

from __future__ import annotations

from dataclasses import dataclass
import re
from typing import Iterable


EMAIL_PATTERN = re.compile(r"[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}")
PHONE_PATTERN = re.compile(r"(?:\+?\d[\d\s().-]{7,}\d)")
SECTION_ALIASES = {
    "summary": {"summary", "profile", "professional summary", "career objective", "objective", "about me"},
    "skills": {"skills", "technical skills", "core skills", "competencies", "technologies"},
    "experience": {"experience", "work experience", "employment", "professional experience"},
    "education": {"education", "academic background", "qualifications"},
    "certifications": {"certifications", "certificates", "licenses", "awards"},
}


@dataclass(frozen=True)
class EntitySpan:
    """A merged entity span predicted by the token-classification model."""

    label: str
    text: str
    confidence: float


def build_profile(entities: Iterable[EntitySpan], document_text: str, model_used: bool) -> dict:
    """Build frontend-ready profile fields from predicted entities and raw text."""
    spans = list(entities)
    grouped: dict[str, list[EntitySpan]] = {}
    for span in spans:
        cleaned = _clean_text(span.text)
        if not cleaned:
            continue
        grouped.setdefault(span.label.upper(), []).append(
            EntitySpan(span.label.upper(), cleaned, span.confidence)
        )

    sections = _extract_sections(document_text)
    emails = _dedupe(
        [span.text for span in grouped.get("EMAIL", [])]
        + EMAIL_PATTERN.findall(document_text)
    )
    phones = _dedupe(
        [span.text for span in grouped.get("PHONE", [])]
        + [match.strip() for match in PHONE_PATTERN.findall(document_text)]
    )

    skills = _dedupe(
        [span.text for label in ("SKILL", "SOFT_SKILL") for span in grouped.get(label, [])]
        + _split_list_section(sections.get("skills", []))
    )
    education = _dedupe(
        [span.text for span in grouped.get("EDUCATION", [])]
        + _clean_section_lines(sections.get("education", []))
    )
    certifications = _dedupe(
        [span.text for span in grouped.get("CERTIFICATION", [])]
        + _clean_section_lines(sections.get("certifications", []))
    )

    names = _dedupe([span.text for span in grouped.get("NAME", [])])
    locations = _dedupe(
        [span.text for span in grouped.get("CANDIDATE_LOCATION", [])]
        + [span.text for span in grouped.get("LOCATION", [])]
    )
    summaries = _dedupe(
        [span.text for span in grouped.get("SUMMARY", [])]
        + _clean_section_lines(sections.get("summary", []))
    )
    experiences = _build_experiences(grouped, sections.get("experience", []))

    confidence_values = [span.confidence for span in spans if span.label.upper() != "O"]
    confidence = (
        round(sum(confidence_values) / len(confidence_values), 4)
        if confidence_values
        else None
    )

    warnings: list[str] = []
    if not model_used:
        warnings.append(
            "The trained LayoutLMv3 model was unavailable; text heuristics were used."
        )
    if not document_text.strip():
        warnings.append("No readable text was found in the uploaded CV.")

    return {
        "fullName": names[0] if names else _guess_name(document_text),
        "detectedEmail": emails[0] if emails else None,
        "phone": phones[0] if phones else None,
        "address": locations[0] if locations else None,
        "objective": "\n".join(summaries[:2]) if summaries else None,
        "skills": skills[:40],
        "experience": experiences[:15],
        "education": education[:15],
        "certifications": certifications[:20],
        "extractionMode": "layoutlmv3" if model_used else "heuristic",
        "confidence": confidence,
        "warnings": warnings,
    }


def _build_experiences(
    grouped: dict[str, list[EntitySpan]],
    section_lines: list[str],
) -> list[dict[str, str]]:
    titles = _dedupe([span.text for span in grouped.get("JOB_TITLE", [])])
    companies = _dedupe([span.text for span in grouped.get("COMPANY", [])])
    dates = _dedupe([span.text for span in grouped.get("DATE", [])])
    descriptions = _dedupe(
        [span.text for span in grouped.get("EXPERIENCE", [])]
        + _clean_section_lines(section_lines)
    )

    count = max(len(titles), len(companies), len(dates), len(descriptions))
    entries = []
    for index in range(count):
        entry = {
            "companyName": _at(companies, index),
            "position": _at(titles, index),
            "time": _at(dates, index),
            "description": _at(descriptions, index),
            "skills": "",
            "certificates": "",
        }
        if any(entry.values()):
            entries.append(entry)
    return entries


def _extract_sections(text: str) -> dict[str, list[str]]:
    sections = {key: [] for key in SECTION_ALIASES}
    current: str | None = None
    for raw_line in text.splitlines():
        line = _clean_text(raw_line)
        if not line:
            continue
        normalized = re.sub(r"[^a-z ]", "", line.lower()).strip()
        matched_section = next(
            (
                section
                for section, aliases in SECTION_ALIASES.items()
                if normalized in aliases
            ),
            None,
        )
        if matched_section:
            current = matched_section
            continue
        if current:
            sections[current].append(line)
    return sections


def _split_list_section(lines: list[str]) -> list[str]:
    values: list[str] = []
    for line in lines:
        values.extend(re.split(r"[,;|•·]", line))
    return _dedupe(values)


def _clean_section_lines(lines: list[str]) -> list[str]:
    return _dedupe([re.sub(r"^[\s\-–—•*]+", "", line) for line in lines])


def _guess_name(text: str) -> str | None:
    headings = {
        alias
        for aliases in SECTION_ALIASES.values()
        for alias in aliases
    }
    for raw_line in text.splitlines()[:12]:
        line = _clean_text(raw_line)
        words = line.split()
        if (
            2 <= len(words) <= 6
            and line.lower() not in headings
            and not EMAIL_PATTERN.search(line)
            and not PHONE_PATTERN.search(line)
            and sum(character.isdigit() for character in line) == 0
        ):
            return line
    return None


def _clean_text(value: str) -> str:
    return re.sub(r"\s+", " ", value or "").strip(" \t\r\n-|•")


def _dedupe(values: Iterable[str]) -> list[str]:
    seen: set[str] = set()
    result: list[str] = []
    for value in values:
        cleaned = _clean_text(value)
        key = cleaned.casefold()
        if cleaned and key not in seen:
            seen.add(key)
            result.append(cleaned)
    return result


def _at(values: list[str], index: int) -> str:
    return values[index] if index < len(values) else ""
