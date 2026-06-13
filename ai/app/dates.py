"""Parse CV date ranges and compute years of experience.

Shared by the canonical aggregation (Part 1, to fill ``startDate``/``endDate``)
and the rule-based hard filter (Group 2, to compute total years of experience).
Pure standard library so it stays importable in the lightweight build.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date
import re
import unicodedata
from typing import Iterable


# Tokens (accent-stripped, lowercased) that mean "still ongoing".
PRESENT_TOKENS = (
    "present",
    "now",
    "current",
    "ongoing",
    "hien tai",
    "den nay",
    "toi nay",
    "nay",
)

# English + abbreviated month names mapped to their number.
_MONTHS = {
    "jan": 1, "january": 1,
    "feb": 2, "february": 2,
    "mar": 3, "march": 3,
    "apr": 4, "april": 4,
    "may": 5,
    "jun": 6, "june": 6,
    "jul": 7, "july": 7,
    "aug": 8, "august": 8,
    "sep": 9, "sept": 9, "september": 9,
    "oct": 10, "october": 10,
    "nov": 11, "november": 11,
    "dec": 12, "december": 12,
}

# Range separators, evaluated on the accent-stripped/lowercased text:
#   - connector words "to"/"den"(đến)/"thru"/"until"
#   - a spaced ascii hyphen or tilde
#   - an en/em dash (with optional spaces)
#   - a bare hyphen that comes right after a 4-digit year ("2021-2023", "06/2021-09/2021")
_SEPARATOR_RE = re.compile(
    r"\s+(?:to|den|thru|until)\s+"
    r"|\s+[-~]\s+"
    r"|\s*[–—]\s*"
    r"|(?<=\d{4})\s*-\s*(?=\d)",
    re.IGNORECASE,
)

_MONTH_NAME_RE = re.compile(r"\b([a-z]{3,9})\.?\s+(\d{4})\b")
_NUMERIC_RE = re.compile(r"(?:thang\s*)?(\d{1,2})\s*[/.\s]\s*(\d{4})")
_YEAR_RE = re.compile(r"\b(19\d{2}|20\d{2})\b")

_DAYS_PER_YEAR = 365.25


@dataclass(frozen=True)
class DateRange:
    """A parsed work/education period."""

    start: str | None          # normalized "MM/YYYY" or None
    end: str | None            # normalized "MM/YYYY" or None (None when ongoing)
    is_present: bool           # the end side was Present/Hiện tại/Now/ongoing
    duration_years: float      # span in years (0.0 when undetermined)
    raw: str                   # the original input text


def _strip_accents(value: str) -> str:
    normalized = unicodedata.normalize("NFD", value)
    return "".join(ch for ch in normalized if not unicodedata.combining(ch))


def _today(today: date | None) -> date:
    return today if today is not None else date.today()


def _make_date(year: int, month: int) -> date | None:
    if not 1900 <= year <= 2100:
        return None
    month = month if 1 <= month <= 12 else 1
    return date(year, month, 1)


def _resolve_token(part: str, *, is_end: bool) -> tuple[str, date | None]:
    """Resolve one side of a range to ("present"|"date"|"none", date|None)."""
    part = part.strip()
    if not part:
        return "none", None
    if any(token in part for token in PRESENT_TOKENS):
        return "present", None

    name_match = _MONTH_NAME_RE.search(part)
    if name_match and name_match.group(1) in _MONTHS:
        resolved = _make_date(int(name_match.group(2)), _MONTHS[name_match.group(1)])
        if resolved is not None:
            return "date", resolved

    numeric_match = _NUMERIC_RE.search(part)
    if numeric_match:
        resolved = _make_date(int(numeric_match.group(2)), int(numeric_match.group(1)))
        if resolved is not None:
            return "date", resolved

    year_match = _YEAR_RE.search(part)
    if year_match:
        # Year-only end dates default to December so durations are not undercounted.
        resolved = _make_date(int(year_match.group(1)), 12 if is_end else 1)
        if resolved is not None:
            return "date", resolved

    return "none", None


def _format(value: date | None) -> str | None:
    return f"{value.month:02d}/{value.year}" if value is not None else None


def _parse(text: str, today: date | None) -> DateRange:
    raw = (text or "").strip()
    work = _strip_accents(raw).lower()
    if not work:
        return DateRange(None, None, False, 0.0, raw)

    parts = [piece for piece in _SEPARATOR_RE.split(work) if piece and piece.strip()]
    start_part = parts[0] if parts else ""
    end_part = parts[-1] if len(parts) >= 2 else None

    start_kind, start_date = _resolve_token(start_part, is_end=False)
    if end_part is None:
        end_kind, end_date = "none", None
    else:
        end_kind, end_date = _resolve_token(end_part, is_end=True)

    is_present = end_kind == "present"
    start_value = start_date if start_kind == "date" else None
    end_effective = _today(today) if is_present else end_date

    duration = 0.0
    if start_value is not None and end_effective is not None:
        duration = max(0.0, (end_effective - start_value).days / _DAYS_PER_YEAR)

    return DateRange(
        start=_format(start_value),
        end=_format(end_date) if end_kind == "date" else None,
        is_present=is_present,
        duration_years=round(duration, 2),
        raw=raw,
    )


def parse_date_range(text: str, *, today: date | None = None) -> DateRange:
    """Parse a raw DATE entity such as "06/2021 - 09/2021" or "2024 - Present"."""
    return _parse(text, today)


def normalize_month_year(token: str) -> str | None:
    """Normalize a single month/year token to "MM/YYYY" (year-only -> "01/YYYY")."""
    kind, value = _resolve_token(_strip_accents(token or "").lower(), is_end=False)
    return _format(value) if kind == "date" else None


def _concrete_interval(text: str, today: date | None) -> tuple[date, date] | None:
    """Return concrete (start, end) dates for a range, or None if undetermined."""
    parsed = _parse(text, today)
    if parsed.start is None:
        return None
    start_month, start_year = parsed.start.split("/")
    start = date(int(start_year), int(start_month), 1)
    if parsed.is_present:
        end = _today(today)
    elif parsed.end is not None:
        end_month, end_year = parsed.end.split("/")
        end = date(int(end_year), int(end_month), 1)
    else:
        return None
    if end < start:
        return None
    return start, end


def total_experience_years(
    date_texts: Iterable[str], *, today: date | None = None
) -> float:
    """Sum work durations across DATE entities, merging overlapping periods.

    Concurrent jobs (overlapping intervals) are merged so they are not
    double-counted, then the merged spans are summed into a single year total.
    """
    intervals = [
        interval
        for text in date_texts
        if (interval := _concrete_interval(text, today)) is not None
    ]
    if not intervals:
        return 0.0

    intervals.sort()
    merged: list[tuple[date, date]] = []
    for start, end in intervals:
        if merged and start <= merged[-1][1]:
            previous_start, previous_end = merged[-1]
            merged[-1] = (previous_start, max(previous_end, end))
        else:
            merged.append((start, end))

    total_days = sum((end - start).days for start, end in merged)
    return round(total_days / _DAYS_PER_YEAR, 2)
