"""Vietnamese improvement suggestions for the candidate.

Primary path calls a local Ollama server (small ~2B model on CPU); when Ollama
is unreachable or disabled, a deterministic rule-based template keyed off the
weak fields is used so /match always returns suggestions.
"""

from __future__ import annotations

import os

from .config import display_name


OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen2.5:3b")
OLLAMA_TIMEOUT = float(os.getenv("OLLAMA_TIMEOUT", "60"))

# Rule-based fallback suggestion per field (keyed by entity label).
_TEMPLATES = {
    "SKILL": "Bổ sung và làm nổi bật các kỹ năng kỹ thuật mà JD yêu cầu.",
    "SOFT_SKILL": "Nêu rõ các kỹ năng mềm (giao tiếp, làm việc nhóm) phù hợp với vị trí.",
    "LANGUAGE": "Bổ sung trình độ hoặc chứng chỉ ngoại ngữ liên quan.",
    "CERTIFICATION": "Thêm các chứng chỉ chuyên môn liên quan đến vị trí (ví dụ AWS, PMP).",
    "JOB_TITLE": "Điều chỉnh chức danh/mục tiêu nghề nghiệp cho sát với vị trí ứng tuyển.",
    "COMPANY": "Làm rõ kinh nghiệm tại các công ty cùng lĩnh vực.",
    "EDUCATION": "Bổ sung thông tin học vấn phù hợp với yêu cầu của JD.",
    "SUMMARY": "Viết lại phần tóm tắt để nhấn mạnh sự phù hợp với JD.",
    "EXPERIENCE": "Mô tả chi tiết hơn kinh nghiệm và thành tựu liên quan đến JD.",
    "PROJECT": "Thêm các dự án minh hoạ năng lực phù hợp với vị trí.",
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
    """Return 3-5 concrete Vietnamese suggestions grounded in the SVM output.

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
            "Hồ sơ của bạn đã khá phù hợp với vị trí này.",
            "Hãy rà soát lỗi chính tả và định dạng CV trước khi nộp.",
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
    return ", ".join(f"{display_name(field)} ({scores.get(field, 0.0):.2f})" for field in fields)


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
    strong_text = _field_scores_text(strong, per_field_scores) or "không rõ"
    weak_text = _field_scores_text(weak, per_field_scores) or "không"
    return (
        "Bạn là cố vấn nghề nghiệp. Dựa trên kết quả so khớp CV–JD (do mô hình tính) dưới "
        "đây, hãy đưa ra 3-5 gợi ý NGẮN GỌN, CỤ THỂ bằng tiếng Việt giúp ứng viên cải thiện CV "
        "cho đúng vị trí này. Ưu tiên vá các mục ĐIỂM YẾU và bám sát YÊU CẦU JD; tránh nói "
        "chung chung. Chỉ trả về danh sách gạch đầu dòng, mỗi dòng một gợi ý.\n\n"
        f"Vị trí: {jd_title or 'Không rõ'}\n"
        f"Mức phù hợp tổng thể: {match_score:.0%}\n"
        f"Điểm mạnh: {strong_text}\n"
        f"Điểm yếu (cần cải thiện): {weak_text}\n"
        f"Lý do mô hình: {reason}\n\n"
        f"JD yêu cầu (trích): {(jd_requirements or '')[:400] or 'không rõ'}\n"
        f"Kỹ năng hiện có trong CV: {(cv_skills or '')[:300] or 'không rõ'}\n"
        f"Tóm tắt CV: {(cv_summary or '')[:250] or 'không rõ'}\n"
    )


def _parse_bullets(text: str) -> list[str]:
    bullets: list[str] = []
    for line in (text or "").splitlines():
        cleaned = line.strip().lstrip("-*•").strip()
        cleaned = cleaned.lstrip("0123456789.) ").strip()
        if cleaned:
            bullets.append(cleaned)
    return bullets[:5]
