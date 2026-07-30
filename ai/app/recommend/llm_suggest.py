"""Role-aware CV-to-job guidance grounded in the recommender output.

Primary path calls a local Ollama server (small ~2B model on CPU); when Ollama
is unreachable or disabled, deterministic applicant/recruiter templates keyed
off the weak fields are used so /match always returns appropriate guidance.
"""

from __future__ import annotations

import os

from .config import display_name_en


OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen2.5:3b")
OLLAMA_TIMEOUT = float(os.getenv("OLLAMA_TIMEOUT", "60"))

# Several model fields describe the same evidence area. Grouping them prevents
# the fallback from returning three near-identical skill suggestions.
_FIELD_TOPICS = {
    "SKILL": "skills",
    "required_skill_coverage": "skills",
    "weighted_required_skill_coverage": "skills",
    "required_skill_f1": "skills",
    "skill_semantic_similarity": "skills",
    "skill_exact_coverage": "skills",
    "skill_hybrid_mean": "skills",
    "SOFT_SKILL": "soft_skills",
    "LANGUAGE": "language",
    "CERTIFICATION": "certification",
    "JOB_TITLE": "role_alignment",
    "role_alignment": "role_alignment",
    "COMPANY": "industry",
    "EDUCATION": "education",
    "SUMMARY": "responsibilities",
    "responsibility_similarity": "responsibilities",
    "EXPERIENCE": "experience",
    "experience_task_similarity": "experience",
    "experience_project_direct_similarity": "experience",
    "experience_present": "experience",
    "PROJECT": "projects",
    "project_evidence": "projects",
}

_APPLICANT_TEMPLATES = {
    "skills": "Add concrete evidence for the required skills that are missing or weak, prioritising tools you have actually used in work or projects.",
    "soft_skills": "Show communication and teamwork through short, concrete examples rather than a plain list.",
    "language": "State your language proficiency and any relevant test result when the job explicitly requires it.",
    "certification": "Add relevant certificates you already hold; if the certificate is only preferred, treat it as supporting evidence rather than the main focus.",
    "role_alignment": "Clarify the target role in your headline, but support it with transferable skills and achievements instead of copying the job title.",
    "industry": "Highlight experience in the same or a transferable industry and explain the relevant domain knowledge.",
    "education": "Make the education section clearly show how your degree or coursework meets the stated requirement.",
    "responsibilities": "Rewrite the most relevant experience bullets so they mirror the role's responsibilities and include measurable outcomes.",
    "experience": "Prioritise achievements that demonstrate the job's day-to-day tasks, including scope, ownership, and results.",
    "projects": "Add one or two projects that prove the required skills, your contribution, and the outcome.",
}

_RECRUITER_TEMPLATES = {
    "skills": "Verify hands-on evidence for the required skills with the lowest coverage before shortlisting; distinguish production use from keyword mentions.",
    "soft_skills": "Ask for a concrete example of collaboration or stakeholder communication because the CV provides limited behavioural evidence.",
    "language": "Confirm the candidate's actual proficiency only if the job marks this language requirement as required.",
    "certification": "Treat certificates as supporting evidence unless the job explicitly makes one mandatory; verify validity only when relevant.",
    "role_alignment": "Do not reject on title alone; check whether the candidate's transferable responsibilities and skills match the role.",
    "industry": "Check whether experience from the candidate's industry transfers to this role and ask about the closest comparable context.",
    "education": "Verify the education requirement only to the degree it is explicitly required by the job.",
    "responsibilities": "Review the weak responsibility alignment and ask the candidate to walk through the closest comparable work they owned.",
    "experience": "Probe the depth, recency, scope, and outcomes of relevant experience rather than relying only on stated years.",
    "projects": "Ask for project evidence that demonstrates the required skills, the candidate's personal contribution, and measurable outcomes.",
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
    viewer_role: str = "APPLICANT",
) -> list[str]:
    """Return role-appropriate English guidance grounded in the model output.

    The decision model's per-field scores (which fields are weak, with numbers)
    plus the JD requirements and the CV's own skills are handed to the LLM so the
    guidance is specific to the gap, not a generic template.
    """
    viewer_role = _normalise_viewer_role(viewer_role)
    if use_llm:
        try:
            generated = _suggest_via_ollama(
                match_score, jd_title, strong, weak, reason,
                per_field_scores or {}, jd_requirements, cv_skills, cv_summary,
                viewer_role,
            )
            if generated:
                return generated
        except Exception:
            pass
    return _suggest_template(weak, viewer_role=viewer_role)


def _normalise_viewer_role(viewer_role: str) -> str:
    return "RECRUITER" if str(viewer_role).strip().upper() == "RECRUITER" else "APPLICANT"


def _suggest_template(weak: list[str], *, viewer_role: str = "APPLICANT") -> list[str]:
    role = _normalise_viewer_role(viewer_role)
    templates = _RECRUITER_TEMPLATES if role == "RECRUITER" else _APPLICANT_TEMPLATES
    topics = list(dict.fromkeys(_FIELD_TOPICS[field] for field in weak if field in _FIELD_TOPICS))
    suggestions = [templates[topic] for topic in topics if topic in templates][:4]
    if not suggestions:
        if role == "RECRUITER":
            return [
                "The available CV evidence aligns well with the role; use the score as decision support, not as an automatic hiring decision.",
                "Confirm the depth and recency of the strongest evidence during the interview.",
            ]
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
    viewer_role: str,
) -> list[str]:
    import httpx

    response = httpx.post(
        f"{OLLAMA_BASE_URL}/api/generate",
        json={
            "model": OLLAMA_MODEL,
            "prompt": _build_prompt(
                match_score, jd_title, strong, weak, reason,
                per_field_scores, jd_requirements, cv_skills, cv_summary,
                viewer_role,
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
    viewer_role: str = "APPLICANT",
) -> str:
    strong_text = _field_scores_text(strong, per_field_scores) or "nothing stands out yet"
    weak_text = _field_scores_text(weak, per_field_scores) or "none"
    evidence = (
        f"Role: {jd_title or 'Unknown'}\n"
        f"Overall content match score: {match_score:.0%}\n"
        f"Strong model features: {strong_text}\n"
        f"Weak model features: {weak_text}\n"
        f"Model's read on the fit: {reason}\n\n"
        f"Job requirements (excerpt): {(jd_requirements or '')[:400] or 'not provided'}\n"
        f"Skills currently in the CV: {(cv_skills or '')[:300] or 'not provided'}\n"
        f"CV summary: {(cv_summary or '')[:250] or 'not provided'}\n"
        "Interpretation rule: optional title/certification bonuses are not missing "
        "requirements when their value is zero.\n"
    )
    if _normalise_viewer_role(viewer_role) == "RECRUITER":
        return (
            "You are an evidence-focused recruiting assistant. Using the CV-to-job "
            "match evidence below, write 3-5 short, specific notes for the recruiter. "
            "Refer to \"the candidate\", never address the candidate as \"you\". Summarise "
            "relevant evidence, identify gaps or uncertainty, and propose what to verify "
            "or ask in an interview. Do not advise the candidate how to rewrite their CV, "
            "do not infer protected or personal characteristics, and do not make the final "
            "hiring decision. Treat the model score as decision support, not ground truth. "
            "Return only a plain list, one note per line, with no numbering, headings, or "
            "preamble.\n\n"
            + evidence
        )
    return (
        "You are a warm, experienced career coach. Using the CV-to-job match results "
        "below, write 3-5 short, specific suggestions to help this candidate improve "
        "their CV for THIS role. Speak in natural, encouraging English, directly to the "
        "person (use \"you\"). Prioritise the weak areas and the job's real requirements, "
        "be concrete, and vary your phrasing so it doesn't read like a template. Avoid "
        "generic filler. Return only a plain list, one suggestion per line, with no "
        "numbering, headings, or preamble.\n\n"
        + evidence
    )


def _parse_bullets(text: str) -> list[str]:
    bullets: list[str] = []
    for line in (text or "").splitlines():
        cleaned = line.strip().lstrip("-*•").strip()
        cleaned = cleaned.lstrip("0123456789.) ").strip()
        if cleaned:
            bullets.append(cleaned)
    return bullets[:5]
