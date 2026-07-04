"""Convert LayoutLMv3 entities and document text into profile fields."""

from __future__ import annotations

from dataclasses import dataclass
import re
from typing import Iterable

from .dates import total_experience_years


EMAIL_PATTERN = re.compile(r"[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}")
# A well-formed email whose domain ends at a real TLD, so a URL glued on by OCR
# ("...@gmail.comhttps://github.com/..") is cut back to "...@gmail.com".
_EMAIL_TLD = (
    "com", "net", "org", "edu", "gov", "io", "dev", "ai", "co", "me", "info",
    "vn", "edu.vn", "com.vn", "org.vn", "gmail.com",
)
_EMAIL_CLEAN = re.compile(
    r"[\w.+-]+@[\w-]+(?:\.[\w-]+)*?\.(?:" + "|".join(_EMAIL_TLD) + r")",
    re.IGNORECASE,
)


def _clean_email(value: str) -> str:
    """Extract the first well-formed email, trimming any OCR-glued trailing URL."""
    match = _EMAIL_CLEAN.search(value or "")
    return match.group(0) if match else ""


def _pick_link(links: list[str]) -> str | None:
    """Choose the personal/profile URL over a project/repo URL.

    A profile is a shallow link (``github.com/<user>``, ``linkedin.com/in/<user>``)
    whereas a project link has a deeper path (``github.com/<user>/<repo>``). When
    the contact row is OCR-merged the profile URL is still the shallow one, so it
    is preferred instead of blindly taking the first (often a project) link.
    """
    if not links:
        return None

    def is_profile(url: str) -> bool:
        path = re.sub(r"^\w+://", "", url).rstrip("/")
        host, _, rest = path.partition("/")
        segments = [segment for segment in rest.split("/") if segment]
        if "linkedin.com" in host.lower():
            return rest.lower().startswith("in/") and len(segments) <= 2
        return len(segments) <= 1

    return next((url for url in links if is_profile(url)), links[0])
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
# Max reading-order gap for a DATE/GPA/LOCATION to still attach to an
# education/project block. Keeps a single GPA from being copied onto every
# education entry and a job's date from leaking onto an undated project.
_EDU_GAP = 30
_PROJECT_GAP = 12
# A COMPANY span below this confidence only anchors a job when a role-looking
# JOB_TITLE sits right beside it — guards against phantom jobs the model
# fabricates from a low-confidence fragment (e.g. "JSC" split off a project).
_MIN_ANCHOR_CONFIDENCE = 0.6
_ANCHOR_GAP = 6


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
    """Build the legacy frontend-ready profile fields (unchanged contract).

    This is now a pure *projection* of :func:`build_canonical`: the span-grouping
    rules (work/education/project reconstruction) run exactly once, inside
    ``build_canonical``, right after the LayoutLM output is available. The flat
    legacy shape below is derived from that single canonical structure instead of
    re-grouping the spans a second, divergent way.
    """
    canonical = build_canonical(entities, document_text, model_used)
    personal = canonical["personal_information"]
    by_label = canonical["entitiesByLabel"]
    sections = _extract_sections(document_text)

    skills = _dedupe(
        list(canonical["skills_and_expertise"]["skill"])
        + list(canonical["skills_and_expertise"]["soft_skill"])
    )
    # Use the grouped education blocks (degree — school, kept together) rather
    # than the raw per-span fragments; fall back to section text on the
    # heuristic (no-span) path.
    education = _dedupe(
        [block["education"] for block in canonical["education_history"]]
        or _clean_section_lines(sections.get("education", []))
    )
    summaries = by_label.get("SUMMARY", [])

    experiences = [
        {
            "companyName": block["company"],
            "position": block["job_title"],
            "time": block["date"],
            "description": block["experience"],
            "skills": "",
            "certificates": "",
        }
        for block in canonical["work_experience"]
    ]
    if not experiences and not model_used:
        # Only on the heuristic (no-model) path do we fall back to the label
        # buckets. When the model DID run, an empty work list means the CV has no
        # real jobs — the index-zip fallback would otherwise pair every stray
        # JOB_TITLE with every DATE (certificate/education/project dates included)
        # and fabricate phantom experience entries.
        experiences = _experiences_from_text(by_label, sections.get("experience", []))

    address = personal["candidate_location"]
    if not address and by_label.get("LOCATION"):
        address = by_label["LOCATION"][0]

    warnings: list[str] = []
    if not model_used:
        warnings.append(
            "The trained LayoutLMv3 model was unavailable; text heuristics were used."
        )
    if not document_text.strip():
        warnings.append("No readable text was found in the uploaded CV.")

    return {
        "fullName": personal["name"],
        "detectedEmail": personal["email"],
        "phone": personal["phone"],
        "address": address,
        "objective": "\n".join(summaries[:2]) if summaries else None,
        "skills": skills[:40],
        "experience": experiences[:15],
        "education": education[:15],
        "certifications": list(by_label.get("CERTIFICATION", []))[:20],
        "extractionMode": canonical["extractionMode"],
        "confidence": canonical["confidence"],
        "warnings": warnings,
    }


def _experiences_from_text(
    by_label: dict[str, list[str]], section_lines: list[str]
) -> list[dict[str, str]]:
    """Index-zip fallback used only when no positioned work blocks were built.

    Pairs the Nth title/company/date/description. Reserved for the heuristic
    path; the model path uses the reading-order blocks from ``build_canonical``.
    """
    titles = list(by_label.get("JOB_TITLE", []))
    companies = list(by_label.get("COMPANY", []))
    dates = list(by_label.get("DATE", []))
    descriptions = _dedupe(
        list(by_label.get("EXPERIENCE", [])) + _clean_section_lines(section_lines)
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


# A leading "Category:" label on a skills line, e.g. "Programming: Python" or
# "Soft Skills: Analytical Thinking". The category word(s) are dropped so only
# the skill itself is kept. A colon inside a real skill is rare and the prefix
# is bounded to short leading text to avoid eating "Ratio Analysis (x:y)".
_CATEGORY_PREFIX = re.compile(r"^[A-Za-z][\w /&+.-]{0,28}:\s+")


def _strip_category_prefix(value: str) -> str:
    return _CATEGORY_PREFIX.sub("", value.strip())


def _split_list_section(lines: list[str]) -> list[str]:
    values: list[str] = []
    for line in lines:
        values.extend(_strip_category_prefix(part) for part in re.split(r"[,;|•·]", line))
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
    by_label["EMAIL"] = _dedupe(
        _clean_email(candidate)
        for candidate in by_label["EMAIL"] + EMAIL_PATTERN.findall(document_text)
    )
    by_label["PHONE"] = _dedupe(
        by_label["PHONE"] + [match.strip() for match in PHONE_PATTERN.findall(document_text)]
    )
    by_label["LINK"] = _dedupe(by_label["LINK"] + LINK_PATTERN.findall(document_text))
    by_label["SKILL"] = _dedupe(by_label["SKILL"] + _split_list_section(sections.get("skills", [])))
    by_label["CERTIFICATION"] = _dedupe(
        by_label["CERTIFICATION"] + _clean_section_lines(sections.get("certifications", []))
    )
    # Only fall back to section text when the model tagged NO summary span.
    # Merging both duplicates the objective (the model's clean paragraph plus the
    # same text re-added as OCR-split section lines, which exact-dedupe misses)
    # and, when a "Summary/Objective" heading over-captures, appends unrelated
    # body text (dates, project titles, contact lines).
    if not by_label["SUMMARY"]:
        by_label["SUMMARY"] = _dedupe(_clean_section_lines(sections.get("summary", [])))
    # Trim list/bracket punctuation off the short keyword buckets so the canonical
    # output is clean ("Python," -> "Python", "(OpenWeatherMap" -> "OpenWeatherMap").
    # The recommender's TF-IDF tokenizer already ignores punctuation, so this only
    # cleans the displayed/stored CV, it does not change the match scores.
    for keyword_label in ("SKILL", "SOFT_SKILL", "LANGUAGE", "CERTIFICATION"):
        by_label[keyword_label] = _dedupe_keywords(by_label[keyword_label])

    work_experience = _group_work_experience(spans)

    return {
        "personal_information": {
            "name": by_label["NAME"][0] if by_label["NAME"] else _guess_name(document_text),
            "email": by_label["EMAIL"][0] if by_label["EMAIL"] else None,
            "phone": by_label["PHONE"][0] if by_label["PHONE"] else None,
            "link": _pick_link(by_label["LINK"]),
            "candidate_location": (
                by_label["CANDIDATE_LOCATION"][0] if by_label["CANDIDATE_LOCATION"] else None
            ),
        },
        "summary": "\n".join(by_label["SUMMARY"][:3]) if by_label["SUMMARY"] else None,
        "education_history": _group_education_history(spans),
        "work_experience": work_experience,
        "projects": _group_projects(spans),
        "skills_and_expertise": {
            "skill": by_label["SKILL"][:40],
            "soft_skill": by_label["SOFT_SKILL"][:20],
            "language": by_label["LANGUAGE"][:20],
        },
        "certifications": by_label["CERTIFICATION"][:20],
        # Internal fields for the recommendation pipeline (not part of the display schema).
        "entitiesByLabel": by_label,
        # Years of *work* experience, summed from the dates of the detected jobs
        # only — so certificate validity periods, project timelines and degree
        # dates are never counted as employment.
        "totalExperienceYears": total_experience_years(
            [block["date"] for block in work_experience if block["date"]]
        ),
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


def _closest_text(spans: list[EntitySpan], label: str, anchor: tuple[int, int]) -> str:
    """Text of the ``label`` span whose reading order is nearest ``anchor``.

    Considers spans on both sides of the anchor, so a role/date printed just
    *after* its company — or a faraway headline role at the top of the CV — is
    paired correctly rather than always taking the span immediately before.
    """
    candidates = [span for span in spans if span.label == label]
    if not candidates:
        return ""

    def distance(span: EntitySpan) -> tuple[int, int]:
        key = _span_key(span)
        return (abs(key[0] - anchor[0]), abs(key[1] - anchor[1]))

    return min(candidates, key=distance).text


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


def _nearest_within(
    spans: list[EntitySpan], start: tuple[int, int], end: tuple[int, int], max_gap: int
) -> str:
    """Like ``_nearest_text`` but returns "" when the nearest span is too far.

    Used for a block's DATE/GPA so a lone value far down the CV is not copied
    onto an unrelated block (e.g. one GPA leaking onto every education entry).
    """
    if not spans:
        return ""

    def gap(span: EntitySpan) -> int:
        key = _span_key(span)
        if key[0] != start[0]:
            return 10 ** 9
        if start[1] <= key[1] <= end[1]:
            return 0
        return start[1] - key[1] if key[1] < start[1] else key[1] - end[1]

    best = min(spans, key=gap)
    return best.text if gap(best) <= max_gap else ""


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


def _is_confident_company(company: EntitySpan, work: list[EntitySpan]) -> bool:
    """Whether a COMPANY span is trustworthy enough to anchor a work entry.

    High-confidence spans always qualify. A low-confidence one qualifies only
    when a role-looking JOB_TITLE sits right next to it on the same page, which
    signals a real (title, company) pair the model split rather than a stray
    fragment (e.g. an org name lifted out of a project description).
    """
    if company.confidence >= _MIN_ANCHOR_CONFIDENCE:
        return True
    return any(
        span.label == "JOB_TITLE"
        and span.page == company.page
        and abs(span.order - company.order) <= _ANCHOR_GAP
        and _looks_like_role(span.text)
        for span in work
    )


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
    all_companies = [span for span in work if span.label == "COMPANY"]
    companies = [span for span in all_companies if _is_confident_company(span, work)]
    blocks: list[dict[str, str]] = []

    # If the CV had COMPANY spans but none survived the confidence guard, do NOT
    # fall through to the DATE-anchored branch: that would fabricate jobs out of
    # project/education dates. An empty result is the correct answer here.
    if all_companies:
        keys = [_span_key(company) for company in companies]
        for index, company in enumerate(companies):
            previous = keys[index - 1] if index > 0 else (-1, -1)
            following = keys[index + 1] if index + 1 < len(keys) else (10 ** 9, 10 ** 9)
            window = [span for span in work if previous < _span_key(span) < following]
            anchor = _span_key(company)
            after = [span for span in window if _span_key(span) > anchor]
            # Pair the title/date/location physically closest to this company,
            # not merely the one just before it: real CVs print either
            # DATE -> ROLE -> COMPANY or COMPANY -> DATE -> ROLE, and a headline
            # target role at the very top must not be grabbed by the first job.
            blocks.append(
                _work_block(
                    company=company.text,
                    job_title=_closest_text(window, "JOB_TITLE", anchor),
                    date=_closest_text(window, "DATE", anchor),
                    location=_closest_text(window, "LOCATION", anchor),
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
            experience = " ".join(
                span.text for span in window if span.label == "EXPERIENCE"
            )
            # With no COMPANY to anchor on, a date only becomes a job when it
            # actually owns work bullets. A bare (date, role) pair here is almost
            # always a project row or a certificate/education period, not a job —
            # so skip it instead of fabricating a phantom entry.
            if not experience:
                continue
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
                    experience=experience,
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
        # Keep both the school AND the degree/major from the same block instead
        # of collapsing to just the school (which dropped "Bachelor of ..."). The
        # school line is separated out; the remaining lines are the degree/major.
        texts = [span.text for span in cluster if not _is_edu_noise(span.text)]
        school = next((text for text in texts if _looks_like_school(text)), "")
        degree = " ".join(text for text in texts if text != school)
        display = " — ".join(part for part in (degree, school) if part)
        # Prefer a dedicated GPA span; else recover a GPA written inline in the
        # block text ("Bachelor Degree - GPA: 3.3"), which the model often tags
        # as EDUCATION rather than GPA.
        gpa = _nearest_within(gpas, start, end, _EDU_GAP) or _gpa_in_text(texts)
        blocks.append(
            {
                "education": display or " ".join(texts),
                "school": school,
                "degree": degree,
                "gpa": gpa,
                "date": _nearest_within(dates, start, end, _EDU_GAP),
                "location": _nearest_within(locations, start, end, _EDU_GAP),
            }
        )
    return blocks[:10]


def _group_projects(spans: list[EntitySpan]) -> list[dict[str, str]]:
    projects = _ordered(spans, ("PROJECT",))
    dates = _ordered(spans, ("DATE",))

    # Start a new project at each title-looking span (short, no trailing period)
    # and gather the description bullets under it, instead of gluing several
    # projects into one cluster. Bullets before any title fall into a leading
    # untitled block.
    groups: list[list[EntitySpan]] = []
    for span in projects:
        if _looks_like_project_title(span.text) or not groups:
            groups.append([span])
        else:
            groups[-1].append(span)

    blocks: list[dict[str, str]] = []
    for group in groups:
        start, end = _span_key(group[0]), _span_key(group[-1])
        head = group[0].text
        titled = _looks_like_project_title(head)
        blocks.append(
            {
                "project": head if titled else " ".join(span.text for span in group),
                "description": " ".join(span.text for span in group[1:]) if titled else "",
                # Only a DATE sitting next to the project counts; otherwise a
                # faraway job's date must not be borrowed onto the project.
                "date": _nearest_within(dates, start, end, _PROJECT_GAP),
            }
        )
    return blocks[:10]


def _looks_like_project_title(text: str) -> bool:
    """A short heading line (no trailing sentence punctuation) that names a project."""
    stripped = _clean_text(text)
    return bool(stripped) and len(stripped) <= 80 and not stripped.endswith((".", ":", ";"))


# Connector fragments the model sometimes mislabels as EDUCATION between two
# real lines ("and", "of", ...); dropped so they don't pollute the degree text.
_EDU_NOISE = {"and", "or", "of", "the", "in", "at", "to", "-", "–", "—"}


def _is_edu_noise(text: str) -> bool:
    stripped = _clean_keyword(text).casefold()
    return len(stripped) < 2 or stripped in _EDU_NOISE


# A GPA written inline, e.g. "GPA: 3.3", "GPA 3.65/4.0", "GPA - 8.45 / 10".
_GPA_RE = re.compile(
    r"GPA[\s:._-]*([0-9]{1,2}(?:[.,][0-9]+)?(?:\s*/\s*[0-9]{1,2}(?:[.,][0-9]+)?)?)",
    re.IGNORECASE,
)


def _gpa_in_text(texts: list[str]) -> str:
    # Search the joined block text: the model often splits "GPA:" and the number
    # ("3.3") into separate EDUCATION spans, so per-line search would miss it.
    match = _GPA_RE.search(" ".join(texts))
    return match.group(1).strip() if match else ""


def _looks_like_school(text: str) -> bool:
    lowered = text.lower()
    return any(keyword in lowered for keyword in SCHOOL_KEYWORDS)
