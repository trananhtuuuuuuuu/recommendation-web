"""Group 1 -- Data masking (privacy preservation before scoring).

Removes the PII labels (NAME/EMAIL/PHONE/LINK) entirely and scrubs any PII left
inline inside the long free-text fields, so no downstream group sees it. Pure:
returns a new dict and never mutates the canonical CV.
"""

from __future__ import annotations

from ..postprocess import EMAIL_PATTERN, LINK_PATTERN, PHONE_PATTERN
from .config import MASK_LABELS, SEMANTIC_FIELDS


def scrub_text(text: str) -> str:
    """Strip inline emails, phone numbers, and links from free text."""
    cleaned = EMAIL_PATTERN.sub(" ", text or "")
    cleaned = PHONE_PATTERN.sub(" ", cleaned)
    cleaned = LINK_PATTERN.sub(" ", cleaned)
    return " ".join(cleaned.split())


def mask_entities(entities_by_label: dict[str, list[str]]) -> dict[str, list[str]]:
    """Return a masked copy of entitiesByLabel for the recommender to score."""
    masked: dict[str, list[str]] = {}
    for label, values in entities_by_label.items():
        if label in MASK_LABELS:
            continue
        if label in SEMANTIC_FIELDS:
            masked[label] = [scrub_text(value) for value in values]
        else:
            masked[label] = list(values)
    return masked
