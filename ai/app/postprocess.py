"""Convert LayoutLMv3 entities and document text into profile fields."""

from __future__ import annotations

from dataclasses import dataclass
import re
from typing import Iterable

from .dates import total_experience_years


EMAIL_PATTERN = re.compile(r"[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}")
PHONE_PATTERN = re.compile(r"(?:\+?\d[\d\s().-]{7,}\d)")
LINK_PATTERN = re.compile(r"(?:https?://|www\.)\S+|\b[\w-]+\.(?:com|net|io|dev|vn)/\S+")

# The 18 entity types produced by the trained LayoutLMv3 model (BIO collapsed).
ENTITY_LABELS = (
    "NAME", "EMAIL", "PHONE", "SUMMARY", "EDUCATION", "EXPERIENCE", "SKILL",
    "SOFT_SKILL", "JOB_TITLE", "COMPANY", "DATE", "LOCATION", "CANDIDATE_LOCATION",
    "CERTIFICATION", "LANGUAGE", "PROJECT", "GPA", "LINK",
)
# Labels that make up one work-experience block. LOCATION here is the *work*
# location (per job), kept distinct from CANDIDATE_LOCATION (the candidate's own
# location), which stays on the personal block.
WORK_LABELS = ("JOB_TITLE", "COMPANY", "DATE", "LOCATION", "EXPERIENCE")
SECTION_ALIASES = {
    "summary": {"summary", "profile", "professional summary", "career objective", "objective", "about me"},
    "skills": {"skills", "technical skills", "core skills", "competencies", "technologies"},
    "experience": {"experience", "work experience", "employment", "professional experience"},
    "education": {"education", "academic background", "qualifications"},
    "certifications": {"certifications", "certificates", "licenses", "awards"},
}
SCHOOL_KEYWORDS = (
    "university", "college", "institute", "school", "academy", "polytechnic",
    "đại học", "cao đẳng", "học viện", "trường",
)
# Max reading-order gap to keep spans in the same education/project cluster.
_CLUSTER_GAP = 25


@dataclass(frozen=True)
class EntitySpan:
    """A merged entity span predicted by the token-classification model.

    The positional fields (``page``/``box``/``order``) are populated on the
    model path so blocks can be grouped by reading order; they default to
    placeholder values so existing call sites and the heuristic path keep
    working unchanged.
    """

    label: str
    text: str
    confidence: float
    page: int = 0
    box: tuple[int, int, int, int] | None = None
    order: int = 0


def build_profile(entities: Iterable[EntitySpan], document_text: str, model_used: bool) -> dict:
    """Build legacy frontend-ready profile fields (unchanged contract)."""
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
    experiences = _build_experiences(
        _clean_spans(spans), grouped, sections.get("experience", []), model_used
    )

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
    ordered_spans: list[EntitySpan],
    grouped: dict[str, list[EntitySpan]],
    section_lines: list[str],
    model_used: bool,
) -> list[dict[str, str]]:
    # On the model path reuse the canonical reading-order grouping: it anchors
    # each entry on a COMPANY, recovers a COMPANY the model mislabelled as a
    # JOB_TITLE (e.g. "THG Fulfillment"), and drops education dates. The legacy
    # index-zip below instead pairs the Nth title/company/date/description, so a
    # single job whose company was mislabelled to JOB_TITLE explodes into several
    # phantom entries.
    if model_used:
        blocks = _group_work_experience(ordered_spans)
        if blocks:
            return [
                {
                    "companyName": block["company"],
                    "position": block["job_title"],
                    "time": block["date"],
                    "description": block["experience"],
                    "skills": "",
                    "certificates": "",
                }
                for block in blocks
            ]

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


# Punctuation trimmed from the ENDS of short keyword entities (skills, titles,
# certifications). Internal characters are kept so ".NET", "C++", "C#",
# "node.js" and "Git/GitHub" survive -- only list/bracket noise is stripped.
_KEYWORD_EDGE = " \t\r\n,;:!?|/\\\"'`()[]{}<>*•·–—-"


def _clean_keyword(value: str) -> str:
    """Trim list/bracket punctuation off the ends of one keyword entity."""
    return _clean_text(value).strip(_KEYWORD_EDGE)


def _dedupe_keywords(values: Iterable[str]) -> list[str]:
    """Dedupe keyword entities, trimming edge punctuation and dropping empties."""
    seen: set[str] = set()
    result: list[str] = []
    for value in values:
        cleaned = _clean_keyword(value)
        key = cleaned.casefold()
        if cleaned and key not in seen:
            seen.add(key)
            result.append(cleaned)
    return result


def _at(values: list[str], index: int) -> str:
    return values[index] if index < len(values) else ""


# --------------------------------------------------------------------------- #
# Canonical structured CV (standard display schema) built from LayoutLM output. #
# Blocks are grouped by reading order; DATE is kept as the raw entity text.     #
# entitiesByLabel + the meta fields are kept for the recommendation pipeline.   #
# --------------------------------------------------------------------------- #


def build_canonical(entities: Iterable[EntitySpan], document_text: str, model_used: bool) -> dict:
    """Aggregate LayoutLM entities + raw text into the canonical CV structure."""
    spans = _clean_spans(entities)
    grouped = _group_by_label(spans)
    sections = _extract_sections(document_text)

    by_label = {
        label: _dedupe([span.text for span in grouped.get(label, [])])
        for label in ENTITY_LABELS
    }
    # Augment a few buckets with regex/section text so the heuristic path (no
    # spans) and sparse model output still expose data to the recommender.
    by_label["EMAIL"] = _dedupe(by_label["EMAIL"] + EMAIL_PATTERN.findall(document_text))
    by_label["PHONE"] = _dedupe(
        by_label["PHONE"] + [match.strip() for match in PHONE_PATTERN.findall(document_text)]
    )
    by_label["LINK"] = _dedupe(by_label["LINK"] + LINK_PATTERN.findall(document_text))
    by_label["SKILL"] = _dedupe(by_label["SKILL"] + _split_list_section(sections.get("skills", [])))
    by_label["CERTIFICATION"] = _dedupe(
        by_label["CERTIFICATION"] + _clean_section_lines(sections.get("certifications", []))
    )
    by_label["SUMMARY"] = _dedupe(
        by_label["SUMMARY"] + _clean_section_lines(sections.get("summary", []))
    )
    # Trim list/bracket punctuation off the short keyword buckets so the canonical
    # output is clean ("Python," -> "Python", "(OpenWeatherMap" -> "OpenWeatherMap").
    # The recommender's TF-IDF tokenizer already ignores punctuation, so this only
    # cleans the displayed/stored CV, it does not change the match scores.
    for keyword_label in ("SKILL", "SOFT_SKILL", "LANGUAGE", "CERTIFICATION"):
        by_label[keyword_label] = _dedupe_keywords(by_label[keyword_label])

    return {
        "personal_information": {
            "name": by_label["NAME"][0] if by_label["NAME"] else _guess_name(document_text),
            "email": by_label["EMAIL"][0] if by_label["EMAIL"] else None,
            "phone": by_label["PHONE"][0] if by_label["PHONE"] else None,
            "link": by_label["LINK"][0] if by_label["LINK"] else None,
            "candidate_location": (
                by_label["CANDIDATE_LOCATION"][0] if by_label["CANDIDATE_LOCATION"] else None
            ),
        },
        "summary": "\n".join(by_label["SUMMARY"][:3]) if by_label["SUMMARY"] else None,
        "education_history": _group_education_history(spans),
        "work_experience": _group_work_experience(spans),
        "projects": _group_projects(spans),
        "skills_and_expertise": {
            "skill": by_label["SKILL"][:40],
            "soft_skill": by_label["SOFT_SKILL"][:20],
            "language": by_label["LANGUAGE"][:20],
        },
        "certifications": by_label["CERTIFICATION"][:20],
        # Internal fields for the recommendation pipeline (not part of the display schema).
        "entitiesByLabel": by_label,
        # Years of *work* experience: a degree's "2022 - Present" date is excluded
        # so studying time is not counted as job experience (see _work_date_texts).
        "totalExperienceYears": total_experience_years(_work_date_texts(spans)),
        "extractionMode": "layoutlmv3" if model_used else "heuristic",
        "confidence": _mean_confidence(spans),
    }


# Keys shown to the website / stored in the database (no internal recommender fields).
DISPLAY_KEYS = (
    "personal_information", "summary", "education_history", "work_experience",
    "projects", "skills_and_expertise", "certifications",
)


def to_display(canonical: dict) -> dict:
    """Strip the internal recommender fields, keeping only the display schema."""
    view: dict = {}
    if "id" in canonical:
        view["id"] = canonical["id"]
    for key in DISPLAY_KEYS:
        if key in canonical:
            view[key] = canonical[key]
    return view


def _clean_spans(entities: Iterable[EntitySpan]) -> list[EntitySpan]:
    spans: list[EntitySpan] = []
    for span in entities:
        cleaned = _clean_text(span.text)
        if not cleaned:
            continue
        spans.append(
            EntitySpan(
                span.label.upper(), cleaned, span.confidence,
                span.page, span.box, span.order,
            )
        )
    return spans


def _group_by_label(spans: list[EntitySpan]) -> dict[str, list[EntitySpan]]:
    grouped: dict[str, list[EntitySpan]] = {}
    for span in spans:
        grouped.setdefault(span.label, []).append(span)
    return grouped


def _mean_confidence(spans: list[EntitySpan]) -> float | None:
    values = [span.confidence for span in spans if span.label != "O"]
    return round(sum(values) / len(values), 4) if values else None


def _span_key(span: EntitySpan) -> tuple[int, int]:
    return (span.page, span.order)


def _ordered(spans: list[EntitySpan], labels: tuple[str, ...]) -> list[EntitySpan]:
    return sorted((span for span in spans if span.label in labels), key=_span_key)


def _last_text(spans: list[EntitySpan], label: str) -> str:
    texts = [span.text for span in spans if span.label == label]
    return texts[-1] if texts else ""


def _first_text(spans: list[EntitySpan], label: str) -> str:
    return next((span.text for span in spans if span.label == label), "")


def _cluster_by_gap(spans: list[EntitySpan], max_gap: int) -> list[list[EntitySpan]]:
    """Group order-sorted spans into clusters split at large reading-order gaps."""
    clusters: list[list[EntitySpan]] = []
    current: list[EntitySpan] = []
    for span in spans:
        if current and (
            span.page != current[-1].page or span.order - current[-1].order > max_gap
        ):
            clusters.append(current)
            current = []
        current.append(span)
    if current:
        clusters.append(current)
    return clusters


def _nearest_text(spans: list[EntitySpan], start: tuple[int, int], end: tuple[int, int]) -> str:
    """Pick the span inside [start, end], else the closest one before, else after."""
    if not spans:
        return ""
    within = [span for span in spans if start <= _span_key(span) <= end]
    if within:
        return within[0].text
    before = [span for span in spans if _span_key(span) < start]
    if before:
        return before[-1].text
    after = [span for span in spans if _span_key(span) > end]
    return after[0].text if after else ""


# Title words that mark a JOB_TITLE span as a *role* (vs an org name the model
# mislabelled as a title). Used to recover COMPANY when none was detected.
_ROLE_KEYWORDS = (
    "intern", "engineer", "developer", "analyst", "scientist", "manager", "lead",
    "consultant", "designer", "architect", "administrator", "specialist", "officer",
    "director", "executive", "associate", "trainee", "programmer", "tester", "devops",
    "researcher", "assistant", "coordinator", "technician", "staff", "freelancer",
)


def _looks_like_role(text: str) -> bool:
    lowered = text.lower()
    return any(word in lowered for word in _ROLE_KEYWORDS)


def _nearest_distance(span: EntitySpan, others: list[EntitySpan]) -> int | None:
    """Smallest reading-order gap from span to any same-page span in others."""
    gaps = [abs(span.order - other.order) for other in others if other.page == span.page]
    return min(gaps) if gaps else None


def _education_date_keys(spans: list[EntitySpan]) -> set[tuple[int, int]]:
    """Reading-order keys of DATE spans that belong to an EDUCATION block.

    A date is attributed to education when, in reading order, the nearest
    EDUCATION span is strictly closer than the nearest work-content span
    (COMPANY/JOB_TITLE/EXPERIENCE). This keeps a degree's "2022 - Present" out of
    the work-experience grouping and the years-of-experience total. Ties keep the
    date as work so real jobs are never dropped.
    """
    education = [span for span in spans if span.label == "EDUCATION"]
    if not education:
        return set()
    work_anchor = [span for span in spans if span.label in ("COMPANY", "JOB_TITLE", "EXPERIENCE")]
    keys: set[tuple[int, int]] = set()
    for date in (span for span in spans if span.label == "DATE"):
        edu_gap = _nearest_distance(date, education)
        if edu_gap is None:
            continue
        work_gap = _nearest_distance(date, work_anchor)
        if work_gap is None or edu_gap < work_gap:
            keys.add(_span_key(date))
    return keys


def _work_date_texts(spans: list[EntitySpan]) -> list[str]:
    """DATE entity texts that belong to work history (education dates removed)."""
    education_dates = _education_date_keys(spans)
    return [
        span.text
        for span in spans
        if span.label == "DATE" and _span_key(span) not in education_dates
    ]


def _work_block(
    *, company: str, job_title: str, date: str, location: str, experience: str
) -> dict[str, str]:
    """A work entry with the short fields trimmed of edge punctuation."""
    return {
        "company": _clean_keyword(company),
        "job_title": _clean_keyword(job_title),
        "date": date,
        "location": _clean_keyword(location),
        "experience": experience,
    }


def _group_work_experience(spans: list[EntitySpan]) -> list[dict[str, str]]:
    """Group work spans into entries, anchored on COMPANY (fallback DATE).

    A job entry follows the reading order DATE -> JOB_TITLE -> COMPANY ->
    EXPERIENCE, so each COMPANY owns the title/date just before it and the
    experience bullets just after it (up to the next company). A bare header
    job title with no nearby company does not create an entry. DATE spans that
    belong to an education block are excluded so a degree period is not turned
    into a phantom job. When no COMPANY was detected, a JOB_TITLE span that does
    not look like a role (e.g. "THG Fulfillment") is recovered as the company.
    """
    education_dates = _education_date_keys(spans)
    work = [
        span
        for span in _ordered(spans, WORK_LABELS)
        if not (span.label == "DATE" and _span_key(span) in education_dates)
    ]
    companies = [span for span in work if span.label == "COMPANY"]
    blocks: list[dict[str, str]] = []

    if companies:
        keys = [_span_key(company) for company in companies]
        for index, company in enumerate(companies):
            previous = keys[index - 1] if index > 0 else (-1, -1)
            following = keys[index + 1] if index + 1 < len(keys) else (10 ** 9, 10 ** 9)
            window = [span for span in work if previous < _span_key(span) < following]
            before = [span for span in window if _span_key(span) < _span_key(company)]
            after = [span for span in window if _span_key(span) > _span_key(company)]
            blocks.append(
                _work_block(
                    company=company.text,
                    job_title=_last_text(before, "JOB_TITLE"),
                    date=_last_text(before, "DATE"),
                    location=_last_text(before, "LOCATION") or _first_text(after, "LOCATION"),
                    experience=" ".join(
                        span.text for span in after if span.label == "EXPERIENCE"
                    ),
                )
            )
    else:
        dates = [span for span in work if span.label == "DATE"]
        keys = [_span_key(date) for date in dates]
        for index, date in enumerate(dates):
            previous = keys[index - 1] if index > 0 else (-1, -1)
            following = keys[index + 1] if index + 1 < len(keys) else (10 ** 9, 10 ** 9)
            window = [span for span in work if previous < _span_key(span) < following]
            titles = [span.text for span in window if span.label == "JOB_TITLE"]
            roles_after = [
                span.text
                for span in window
                if span.label == "JOB_TITLE"
                and _span_key(span) > _span_key(date)
                and _looks_like_role(span.text)
            ]
            roles_any = [title for title in titles if _looks_like_role(title)]
            non_roles = [title for title in titles if not _looks_like_role(title)]
            job_title = (
                roles_after[0] if roles_after
                else roles_any[-1] if roles_any
                else titles[0] if titles else ""
            )
            blocks.append(
                _work_block(
                    company=_first_text(window, "COMPANY") or (non_roles[0] if non_roles else ""),
                    job_title=job_title,
                    date=date.text,
                    location=_first_text(window, "LOCATION"),
                    experience=" ".join(
                        span.text for span in window if span.label == "EXPERIENCE"
                    ),
                )
            )

    return [block for block in blocks if block["company"] or block["experience"] or block["date"]][:15]


def _group_education_history(spans: list[EntitySpan]) -> list[dict[str, str]]:
    education = _ordered(spans, ("EDUCATION",))
    dates = _ordered(spans, ("DATE",))
    gpas = _ordered(spans, ("GPA",))
    locations = _ordered(spans, ("LOCATION",))

    blocks: list[dict[str, str]] = []
    for cluster in _cluster_by_gap(education, _CLUSTER_GAP):
        start, end = _span_key(cluster[0]), _span_key(cluster[-1])
        school = next((span.text for span in cluster if _looks_like_school(span.text)), None)
        blocks.append(
            {
                "education": school or " ".join(span.text for span in cluster),
                "gpa": _nearest_text(gpas, start, end),
                "date": _nearest_text(dates, start, end),
                "location": _nearest_text(locations, start, end),
            }
        )
    return blocks[:10]


def _group_projects(spans: list[EntitySpan]) -> list[dict[str, str]]:
    projects = _ordered(spans, ("PROJECT",))
    dates = _ordered(spans, ("DATE",))

    blocks: list[dict[str, str]] = []
    for cluster in _cluster_by_gap(projects, _CLUSTER_GAP):
        start, end = _span_key(cluster[0]), _span_key(cluster[-1])
        blocks.append(
            {
                "project": " ".join(span.text for span in cluster),
                "date": _nearest_text(dates, start, end),
            }
        )
    return blocks[:10]


def _looks_like_school(text: str) -> bool:
    lowered = text.lower()
    return any(keyword in lowered for keyword in SCHOOL_KEYWORDS)
