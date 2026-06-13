"""CV-to-JD recommendation pipeline.

Five groups run in order on a canonical CV (from ``build_canonical``) and a
structured job description:

1. Data masking      -- remove PII (NAME/EMAIL/PHONE/LINK) before scoring.
2. Hard filter       -- rule-based location + years-of-experience gate.
3. Vector space      -- TF-IDF (primary) / Word2Vec+WMD (comparison) per field.
4. Semantic matching -- TF-IDF cosine over the long free-text fields.
5. Decision model    -- LinearSVC (Field-to-Field Weighting) or heuristic fallback,
                        with an explainable "Lý do khuyến nghị".

The result is handed to a local Ollama LLM that writes Vietnamese suggestions.
"""

from .pipeline import run_match
from .schemas import JobDescriptionInput, MatchResult

__all__ = ["run_match", "JobDescriptionInput", "MatchResult"]
