"""Career-coaching improvement suggestions (English) for the candidate.

Primary path calls a local Ollama server (small ~2B model on CPU); when Ollama
is unreachable or disabled, a deterministic rule-based template keyed off the
weak fields is used so /match always returns suggestions.
"""

from __future__ import annotations

import os

from .config import display_name_en


OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen2.5:3b")
OLLAMA_TIMEOUT = float(os.getenv("OLLAMA_TIMEOUT", "60"))

# Rule-based fallback suggestion per field (used when the LLM is unavailable).
_TEMPLATES = {
    "SKILL": "Add the specific technical skills this job calls for, and move the most relevant ones to the top of your CV.",
    "SOFT_SKILL": "Show soft skills like communication and teamwork through short, concrete examples rather than a plain list.",
    "LANGUAGE": "List the languages you speak with your proficiency level, especially any the role asks for.",
    "CERTIFICATION": "Add a certification that fits this role (for example AWS, PMP, or a recognised language certificate).",
    "JOB_TITLE": "Align your headline or career objective more closely with the exact title you're applying for.",
    "COMPANY": "Highlight experience at companies in the same industry to show you know the domain.",
    "EDUCATION": "Make your education section speak to what this job description expects.",
    "SUMMARY": "Rewrite your summary so it speaks directly to this role and what you'd bring to it.",
    "EXPERIENCE": "Describe your experience with concrete achievements and numbers that map to the job's needs.",
    "PROJECT": "Add one or two projects that clearly demonstrate the skills this role is looking for.",
}


def llm_enabled() -> bool:
    """Whether an Ollama call would be attempted (env override, default on)."""
    return os.getenv("RECO_DISABLE_LLM", "").lower() not in ("1", "true", "yes")


def ollama_available(timeout: float = 3.0) -> bool:
    """Return whether a local Ollama server is reachable."""
    try:
        import httpx

        return httpx.get(f"{OLLAMA_BASE_URL}/api/version", timeout=timeout).status_code == 200
    except Exception:
        return False


def ollama_generate(
    prompt: str,
    *,
    model: str | None = None,
    num_predict: int = 8,
    temperature: float = 0.0,
    timeout: float | None = None,
) -> str:
    """Low-level Ollama text generation (shared by suggestions and labelling)."""
    import httpx

    response = httpx.post(
        f"{OLLAMA_BASE_URL}/api/generate",
        json={
            "model": model or OLLAMA_MODEL,
            "prompt": prompt,
            "stream": False,
            "options": {"temperature": temperature, "num_predict": num_predict},
        },
        timeout=timeout or OLLAMA_TIMEOUT,
    )
    response.raise_for_status()
    return response.json().get("response", "")


def suggest(
    *,
    match_score: float,
    jd_title: str,
    strong: list[str],
    weak: list[str],
    reason: str,
    use_llm: bool = True,
    per_field_scores: dict[str, float] | None = None,
    jd_requirements: str = "",
    cv_skills: str = "",
    cv_summary: str = "",
) -> list[str]:
    """Return 3-5 concrete English suggestions grounded in the SVM output.

    The decision model's per-field scores (which fields are weak, with numbers)
    plus the JD requirements and the CV's own skills are handed to the LLM so the
    advice is specific to the gap, not a generic template.
    """
    if use_llm:
        try:
            generated = _suggest_via_ollama(
                match_score, jd_title, strong, weak, reason,
                per_field_scores or {}, jd_requirements, cv_skills, cv_summary,
            )
            if generated:
                return generated
        except Exception:
            pass
    return _suggest_template(weak)


def _suggest_template(weak: list[str]) -> list[str]:
    suggestions = [_TEMPLATES[field] for field in weak if field in _TEMPLATES][:4]
    if not suggestions:
        return [
            "Your profile already matches this role well.",
            "Do a final pass for typos and formatting before you apply.",
        ]
    return suggestions


def _suggest_via_ollama(
    match_score: float,
    jd_title: str,
    strong: list[str],
    weak: list[str],
    reason: str,
    per_field_scores: dict[str, float],
    jd_requirements: str,
    cv_skills: str,
    cv_summary: str,
) -> list[str]:
    import httpx

    response = httpx.post(
        f"{OLLAMA_BASE_URL}/api/generate",
        json={
            "model": OLLAMA_MODEL,
            "prompt": _build_prompt(
                match_score, jd_title, strong, weak, reason,
                per_field_scores, jd_requirements, cv_skills, cv_summary,
            ),
            "stream": False,
            "options": {"temperature": 0.4},
        },
        timeout=OLLAMA_TIMEOUT,
    )
    response.raise_for_status()
    return _parse_bullets(response.json().get("response", ""))


def _field_scores_text(fields: list[str], scores: dict[str, float]) -> str:
    return ", ".join(f"{display_name_en(field)} ({scores.get(field, 0.0):.0%})" for field in fields)


def _build_prompt(
    match_score: float,
    jd_title: str,
    strong: list[str],
    weak: list[str],
    reason: str,
    per_field_scores: dict[str, float],
    jd_requirements: str,
    cv_skills: str,
    cv_summary: str,
) -> str:
    strong_text = _field_scores_text(strong, per_field_scores) or "nothing stands out yet"
    weak_text = _field_scores_text(weak, per_field_scores) or "none"
    return (
        "You are a warm, experienced career coach. Using the CV-to-job match results "
        "below, write 3-5 short, specific suggestions to help this candidate improve "
        "their CV for THIS role. Speak in natural, encouraging English, directly to the "
        "person (use \"you\"). Prioritise the weak areas and the job's real requirements, "
        "be concrete, and vary your phrasing so it doesn't read like a template. Avoid "
        "generic filler. Return only a plain list, one suggestion per line, with no "
        "numbering, headings, or preamble.\n\n"
        f"Role: {jd_title or 'Unknown'}\n"
        f"Overall match: {match_score:.0%}\n"
        f"Strengths: {strong_text}\n"
        f"Areas to improve: {weak_text}\n"
        f"Model's read on the fit: {reason}\n\n"
        f"Job requirements (excerpt): {(jd_requirements or '')[:400] or 'not provided'}\n"
        f"Skills currently in the CV: {(cv_skills or '')[:300] or 'not provided'}\n"
        f"CV summary: {(cv_summary or '')[:250] or 'not provided'}\n"
    )


def _parse_bullets(text: str) -> list[str]:
    bullets: list[str] = []
    for line in (text or "").splitlines():
        cleaned = line.strip().lstrip("-*•").strip()
        cleaned = cleaned.lstrip("0123456789.) ").strip()
        if cleaned:
            bullets.append(cleaned)
    return bullets[:5]
