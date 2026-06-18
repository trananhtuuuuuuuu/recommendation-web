"""Shared text normalization for the recommender (bilingual VN/EN)."""

from __future__ import annotations

import re
import unicodedata


_TOKEN_RE = re.compile(r"[a-z0-9+#.]+")
_WHITESPACE_RE = re.compile(r"\s+")


def strip_accents(value: str) -> str:
    """Drop Vietnamese/diacritical marks so "kỹ năng" -> "ky nang"."""
    normalized = unicodedata.normalize("NFD", value or "")
    return "".join(ch for ch in normalized if not unicodedata.combining(ch))


def normalize(value: str) -> str:
    """Lowercase, strip accents, and collapse whitespace."""
    return _WHITESPACE_RE.sub(" ", strip_accents(value or "").lower()).strip()


def tokenize(value: str) -> list[str]:
    """Accent-insensitive word tokens (keeps c++, c#, node.js intact)."""
    return _TOKEN_RE.findall(normalize(value))
