"""Role-aware LLM prompts and deterministic fallback guidance."""

import unittest

from app.main import MatchOptions
from app.recommend.decision import weak_fields
from app.recommend.llm_suggest import _build_prompt, suggest


class RoleAwareSuggestionTests(unittest.TestCase):

    def prompt(self, viewer_role: str) -> str:
        return _build_prompt(
            0.62,
            "Backend Engineer",
            ["project_evidence"],
            ["required_skill_coverage", "responsibility_similarity"],
            "Required skills 45%, responsibilities 38%.",
            {
                "project_evidence": 0.81,
                "required_skill_coverage": 0.45,
                "responsibility_similarity": 0.38,
            },
            "Java, Spring Boot, PostgreSQL",
            "Java, SQL",
            "Built internal APIs.",
            viewer_role,
        )

    def test_recruiter_prompt_uses_svm_evidence_and_hiring_guidance(self):
        prompt = self.prompt("RECRUITER")

        self.assertIn("Overall SVM match score: 62%", prompt)
        self.assertIn("required-skill coverage (45%)", prompt)
        self.assertIn("notes for the recruiter", prompt)
        self.assertIn("ask in an interview", prompt)
        self.assertIn("do not make the final hiring decision", prompt)
        self.assertNotIn("help this candidate improve their CV", prompt)

    def test_applicant_prompt_remains_cv_improvement_guidance(self):
        prompt = self.prompt("APPLICANT")

        self.assertIn("experienced career coach", prompt)
        self.assertIn("help this candidate improve their CV", prompt)
        self.assertIn('use "you"', prompt)
        self.assertNotIn("notes for the recruiter", prompt)

    def test_fallback_is_role_specific_for_structured_v21_fields(self):
        applicant = suggest(
            match_score=0.5,
            jd_title="Backend Engineer",
            strong=[],
            weak=["required_skill_coverage", "responsibility_similarity"],
            reason="Weak required-skill coverage.",
            use_llm=False,
            viewer_role="APPLICANT",
        )
        recruiter = suggest(
            match_score=0.5,
            jd_title="Backend Engineer",
            strong=[],
            weak=["required_skill_coverage", "responsibility_similarity"],
            reason="Weak required-skill coverage.",
            use_llm=False,
            viewer_role="RECRUITER",
        )

        self.assertTrue(any("Add concrete evidence" in item for item in applicant))
        self.assertTrue(any("before shortlisting" in item for item in recruiter))
        self.assertTrue(any("ask the candidate" in item for item in recruiter))
        self.assertNotEqual(applicant, recruiter)

    def test_match_options_accepts_camel_case_viewer_role(self):
        options = MatchOptions.model_validate({"viewerRole": "RECRUITER"})
        self.assertEqual(options.viewer_role, "RECRUITER")

    def test_invalid_viewer_role_is_rejected(self):
        with self.assertRaises(ValueError):
            MatchOptions.model_validate({"viewerRole": "ADMIN"})

    def test_optional_bonus_absence_is_not_a_weakness(self):
        weak = weak_fields({
            "required_skill_coverage": 0.1,
            "title_bonus": 0.0,
            "certification_bonus": 0.0,
        })
        self.assertEqual(weak, ["required_skill_coverage"])


if __name__ == "__main__":
    unittest.main()
