"""End-to-end tests for the recommendation pipeline orchestration."""

import unittest
from datetime import date

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


class PipelineTests(unittest.TestCase):

    def test_reject_short_circuits(self):
        jd = dict(_JD, experienceLevel="Senior (8+ years)")
        result = run_match(make_cv(), jd, today=date(2022, 1, 1), enable_llm=False)
        self.assertFalse(result.passed_filter)
        self.assertEqual(result.per_field_scores, {})
        self.assertEqual(result.match_score, 0.0)
        self.assertIsNone(result.suggestions)

    def test_pass_produces_scores_reason_and_suggestions(self):
        result = run_match(make_cv(), _JD, today=date(2025, 1, 1), enable_llm=False)
        self.assertTrue(result.passed_filter)
        self.assertIn("SKILL", result.per_field_scores)
        self.assertIn("EXPERIENCE", result.per_field_scores)
        self.assertTrue(result.reason)
        self.assertIsInstance(result.suggestions, list)
        self.assertGreaterEqual(len(result.suggestions), 1)

    def test_llm_disabled_returns_string_suggestions(self):
        result = run_match(make_cv(), _JD, today=date(2025, 1, 1), enable_llm=False)
        self.assertTrue(all(isinstance(item, str) for item in result.suggestions))

    def test_accepts_jd_dataclass_or_dict(self):
        result = run_match(make_cv(), _JD, today=date(2025, 1, 1), enable_llm=False)
        self.assertEqual(result.scoring_method, "tfidf")


if __name__ == "__main__":
    unittest.main()
