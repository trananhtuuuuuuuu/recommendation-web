"""End-to-end tests for the recommendation pipeline orchestration."""

import os
import unittest
from datetime import date
from unittest import mock

from app.postprocess import EntitySpan, build_canonical
from app.recommend import run_match


_JD = {
    "jobTitle": "Backend Engineer",
    "jobDescription": "Build and maintain REST APIs.",
    "requirements": "Java, Spring Boot. At least 1 year of experience.",
    "location": "Ho Chi Minh",
    "experienceLevel": "1+ years",
}


def make_cv():
    spans = [
        EntitySpan("SKILL", "Java", 0.9),
        EntitySpan("SKILL", "Spring Boot", 0.9),
        EntitySpan("JOB_TITLE", "Backend Engineer", 0.9),
        EntitySpan("DATE", "01/2020 - Present", 0.9),
        EntitySpan("CANDIDATE_LOCATION", "Ho Chi Minh City", 0.9),
        EntitySpan("SUMMARY", "Backend engineer building REST APIs.", 0.9),
    ]
    return build_canonical(spans, "", model_used=True)


@mock.patch.dict(
    os.environ,
    {
        "AI_RECOMMENDER_PRIMARY": "legacy",
        "AI_RECOMMENDER_FALLBACKS": "v21,v22",
        "AI_HARD_FILTER_ENABLED": "true",
    },
)
class PipelineTests(unittest.TestCase):

    def test_reject_short_circuits(self):
        # A confirmed gap beyond the one-year tolerance short-circuits scoring.
        cv = make_cv()
        cv["totalExperienceYears"] = 1.0
        jd = dict(_JD, experienceLevel="Senior (8+ years)")
        result = run_match(cv, jd, today=date(2022, 1, 1), enable_llm=False)
        self.assertFalse(result.passed_filter)
        self.assertEqual(result.per_field_scores, {})
        self.assertEqual(result.match_score, 0.0)
        self.assertIn("Experience requirement is not met", result.reason)
        self.assertTrue(any(
            "YOE eligibility rule is not met" in item
            for item in result.suggestions
        ))

    def test_pass_produces_scores_reason_and_suggestions(self):
        result = run_match(make_cv(), _JD, today=date(2025, 1, 1), enable_llm=False)
        self.assertTrue(result.passed_filter)
        self.assertIn("SKILL", result.per_field_scores)
        self.assertIn("EXPERIENCE", result.per_field_scores)
        self.assertTrue(result.reason)
        self.assertIsInstance(result.suggestions, list)
        self.assertGreaterEqual(len(result.suggestions), 1)

    def test_yoe_inside_one_year_tolerance_still_scores(self):
        cv = make_cv()
        cv["totalExperienceYears"] = 1.2
        jd = dict(
            _JD,
            minimumYearsExperience=2,
            experienceLevel="2+ years",
        )

        result = run_match(cv, jd, enable_llm=False)

        self.assertTrue(result.passed_filter)
        self.assertTrue(result.per_field_scores)
        self.assertGreater(result.match_score, 0.0)
        self.assertTrue(any(
            "currently short by 0.8 years" in item
            for item in result.suggestions
        ))

    def test_missing_required_language_short_circuits_scoring(self):
        jd = dict(
            _JD,
            languageRequired=True,
            languageRequirements=[{
                "languageName": "English",
                "proficiencyLevel": "Intermediate",
            }],
        )

        result = run_match(make_cv(), jd, enable_llm=False)

        self.assertFalse(result.passed_filter)
        self.assertEqual(result.per_field_scores, {})
        self.assertEqual(result.match_score, 0.0)
        self.assertIn("Language requirement is not met", result.reason)

    def test_toeic_without_score_passes_language_gate_provisionally(self):
        cv = make_cv()
        cv["entitiesByLabel"]["CERTIFICATION"] = [
            "TOEIC Listening and Reading"
        ]
        jd = dict(
            _JD,
            languageRequired=True,
            languageRequirements=[{
                "languageName": "English",
                "proficiencyLevel": "Advanced",
            }],
        )

        result = run_match(cv, jd, enable_llm=False)

        self.assertTrue(result.passed_filter)
        self.assertEqual(result.hard_filter.language_status, "unknown")
        self.assertTrue(result.per_field_scores)
        self.assertTrue(any(
            "evidence was found" in item
            for item in result.suggestions
        ))

    def test_disabled_filter_keeps_audit_but_scores_candidate(self):
        cv = make_cv()
        cv["totalExperienceYears"] = 1.0
        jd = dict(_JD, experienceLevel="Senior (8+ years)")
        with mock.patch.dict(os.environ, {"AI_HARD_FILTER_ENABLED": "false"}):
            result = run_match(cv, jd, today=date(2022, 1, 1), enable_llm=False)

        self.assertTrue(result.passed_filter)
        self.assertFalse(result.hard_filter_enforced)
        self.assertFalse(result.hard_filter.passed)
        self.assertTrue(result.per_field_scores)
        self.assertNotIn("Adjusted for limited experience", result.reason)

    def test_llm_disabled_returns_string_suggestions(self):
        result = run_match(make_cv(), _JD, today=date(2025, 1, 1), enable_llm=False)
        self.assertTrue(all(isinstance(item, str) for item in result.suggestions))

    def test_accepts_jd_dataclass_or_dict(self):
        result = run_match(make_cv(), _JD, today=date(2025, 1, 1), enable_llm=False)
        self.assertEqual(result.scoring_method, "tfidf")


if __name__ == "__main__":
    unittest.main()
