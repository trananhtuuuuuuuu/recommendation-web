"""Derive comparable JD text for each CV field.

The JD arrives already filled into structured tags, so each CV field is compared
against the JD column(s) most likely to contain that information (see
``config.JD_FIELD_SOURCES``). No JD parsing / model is required.
"""

from __future__ import annotations

from .config import JD_FIELD_SOURCES
from .schemas import JobDescriptionInput


def jd_field_text(field: str, jd: JobDescriptionInput) -> str:
    """Concatenate the JD column(s) mapped to ``field`` into one comparison text."""
    sources = JD_FIELD_SOURCES.get(field, ())
    parts = [getattr(jd, source, "") for source in sources]
    return " ".join(part for part in parts if part).strip()
