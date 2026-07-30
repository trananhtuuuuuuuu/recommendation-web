from app.recommend.language_match import (
    canonical_language,
    language_evidence,
    language_evidence_details,
    language_gap,
    language_requirement_status,
    proficiency_score,
)


def requirement(language: str, level: str) -> dict:
    return {
        "languageRequired": True,
        "languageRequirements": [
            {
                "languageName": language,
                "proficiencyLevel": level,
                "skills": ["Speaking"],
                "certificates": [],
            }
        ],
    }


def test_language_aliases_and_certificate_levels() -> None:
    assert canonical_language("Tiếng Nhật") == "japanese"
    assert proficiency_score("IELTS 7.0") == proficiency_score("C1")
    assert proficiency_score("JLPT N2") > proficiency_score("JLPT N3")
    assert proficiency_score("6.0 IELTS") == proficiency_score("B2")
    assert proficiency_score("IELTS Academic 6.5 (B2)") == proficiency_score("B2")
    assert proficiency_score("TOEIC Listening-Reading: 855/990") == (
        proficiency_score("B2")
    )


def test_language_evidence_attaches_certificates_to_the_correct_language() -> None:
    evidence = language_evidence(
        ["English", "IELTS 7.0", "Japanese", "JLPT N3"]
    )
    assert evidence["english"] == proficiency_score("C1")
    assert evidence["japanese"] == proficiency_score("JLPT N3")


def test_separate_toeic_name_and_point_are_combined() -> None:
    evidence = language_evidence_details(
        ["TOEIC Listening and Reading", "900"]
    )
    assert evidence["english"] == proficiency_score("B2")


def test_toeic_without_point_is_present_with_unknown_level() -> None:
    state, met, gaps, unknown, evidence = language_requirement_status(
        ["TOEIC Listening and Reading"],
        requirement("English", "Advanced"),
    )
    assert state == "unknown"
    assert not met
    assert not gaps
    assert unknown == ["English (Advanced)"]
    assert evidence["english"] is None


def test_no_requirement_or_satisfied_requirement_has_no_gap() -> None:
    assert language_gap([], {"languageRequired": False}) == 0.0
    assert language_gap(
        ["English", "IELTS 7.0"],
        requirement("English", "B2"),
    ) == 0.0


def test_missing_or_lower_proficiency_creates_gap() -> None:
    assert language_gap([], requirement("English", "B2")) == 1.0
    partial = language_gap(["English B1"], requirement("English", "B2"))
    assert 0.0 < partial < 1.0


def test_all_required_languages_are_averaged() -> None:
    jd = {
        "languageRequired": True,
        "languageRequirements": [
            {"languageName": "English", "proficiencyLevel": "B2"},
            {"languageName": "Japanese", "proficiencyLevel": "N2"},
        ],
    }
    assert language_gap(["English C1"], jd) == 0.5
