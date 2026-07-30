"""Tests for the stable applicant/recruiter match summary form."""

import unittest

from app.recommend.match_summary import build_match_summary
from app.recommend.schemas import HardFilterResult


class MatchSummaryTests(unittest.TestCase):

    def setUp(self):
        self.cv = {
            "entitiesByLabel": {
                "JOB_TITLE": ["Software Engineer"],
                "LANGUAGE": ["English B2"],
                "CERTIFICATION": ["IELTS 7.0"],
            }
        }
        self.jd = {
            "jobTitle": "Backend Engineer",
            "languageRequired": True,
            "languageRequirements": [{
                "languageName": "English",
                "proficiencyLevel": "B2",
                "certificates": [{
                    "certificateName": "IELTS",
                    "minimumScore": "6.5",
                }],
            }],
        }
        self.hard = HardFilterResult(
            passed=True,
            candidate_years=3.2,
            required_years=3.0,
            exp_fit=1.0,
        )
        self.fields = {
            "skill_hybrid_mean": 0.7,
            "experience_project_direct_similarity": 0.6,
            "role_alignment": 0.5,
            "certification_bonus": 0.03,
        }

    def test_applicant_summary_reports_all_requested_statuses(self):
        output = build_match_summary(
            match_score=0.72,
            per_field_scores=self.fields,
            hard_filter=self.hard,
            cv=self.cv,
            jd=self.jd,
            viewer_role="APPLICANT",
        )

        self.assertEqual(len(output), 4)
        self.assertIn("Overall match: 72.0%", output[0])
        self.assertIn("skills 70.0%", output[0])
        self.assertFalse(any(item.startswith("Experience:") for item in output))
        self.assertIn("Language: requirement met", output[1])
        self.assertIn("you have evidence for IELTS", output[2])
        self.assertIn("is related", output[3])

    def test_recruiter_summary_uses_candidate_wording_and_reports_gaps(self):
        self.cv["entitiesByLabel"]["LANGUAGE"] = []
        self.cv["entitiesByLabel"]["CERTIFICATION"] = []
        output = build_match_summary(
            match_score=0.61,
            per_field_scores={**self.fields, "certification_bonus": 0.0},
            hard_filter=self.hard,
            cv=self.cv,
            jd=self.jd,
            viewer_role="RECRUITER",
        )

        self.assertFalse(any(item.startswith("Experience:") for item in output))
        self.assertIn("missing or below", output[1])
        self.assertIn("not found in the candidate's CV", output[2])

    def test_ineligible_summary_explains_content_model_was_not_run(self):
        hard = HardFilterResult(
            passed=False,
            candidate_years=0.0,
            required_years=3.0,
            exp_fit=0.0,
        )
        output = build_match_summary(
            match_score=0.0,
            per_field_scores={},
            hard_filter=hard,
            cv=self.cv,
            jd=self.jd,
            viewer_role="APPLICANT",
            content_scored=False,
        )

        self.assertIn("content scoring was not run", output[0])
        self.assertIn("YOE eligibility rule is not met", output[1])

    def test_applicant_hides_optional_language_certificate_and_met_yoe(self):
        output = build_match_summary(
            match_score=0.7,
            per_field_scores=self.fields,
            hard_filter=self.hard,
            cv=self.cv,
            jd={"jobTitle": "Backend Engineer", "languageRequired": False},
            viewer_role="APPLICANT",
        )

        self.assertFalse(any(item.startswith("Experience:") for item in output))
        self.assertFalse(any(item.startswith("Language:") for item in output))
        self.assertFalse(any(item.startswith("Certificates:") for item in output))

    def test_recruiter_sees_extra_candidate_language_and_certificate(self):
        cv = {
            "entitiesByLabel": {
                "JOB_TITLE": ["AI Engineer"],
                "CERTIFICATION": ["TOEIC 900"],
            }
        }
        output = build_match_summary(
            match_score=0.7,
            per_field_scores=self.fields,
            hard_filter=self.hard,
            cv=cv,
            jd={"jobTitle": "AI Engineer", "languageRequired": False},
            viewer_role="RECRUITER",
        )

        self.assertTrue(any(
            item.startswith("Additional language evidence: English")
            for item in output
        ))
        self.assertTrue(any(
            item.startswith("Additional certificates: TOEIC 900")
            for item in output
        ))

    def test_shortfall_within_tolerance_is_still_reported(self):
        hard = HardFilterResult(
            passed=True,
            candidate_years=2.3,
            required_years=3.0,
            exp_fit=1.0,
        )
        output = build_match_summary(
            match_score=0.65,
            per_field_scores=self.fields,
            hard_filter=hard,
            cv=self.cv,
            jd={"jobTitle": "Backend Engineer"},
            viewer_role="APPLICANT",
        )

        self.assertTrue(any(
            "currently short by 0.7 years" in item
            and "within the allowed one-year tolerance" in item
            for item in output
        ))

    def test_tran_binh_education_meets_ai_research_intern_requirement(self):
        cv = {
            "entitiesByLabel": {
                "EDUCATION": [
                    "Bachelor of Computer Science — Ho Chi Minh City "
                    "University of Technology Vietnam National University"
                ],
                "JOB_TITLE": ["AI Engineer Intern"],
            }
        }
        jd = {
            "jobTitle": "AI Research Intern",
            "educationMode": "ANY_OF",
            "degrees": ["BACHELOR"],
            "educationMajors": [
                "Computer Science",
                "Artificial Intelligence",
                "Data Science",
            ],
        }

        output = build_match_summary(
            match_score=0.66,
            per_field_scores=self.fields,
            hard_filter=self.hard,
            cv=cv,
            jd=jd,
            viewer_role="APPLICANT",
        )

        self.assertFalse(any(item.startswith("Education:") for item in output))

    def test_missing_required_education_is_reported_deterministically(self):
        output = build_match_summary(
            match_score=0.5,
            per_field_scores=self.fields,
            hard_filter=self.hard,
            cv={"entitiesByLabel": {"JOB_TITLE": ["AI Engineer Intern"]}},
            jd={
                "jobTitle": "AI Research Intern",
                "educationMode": "ANY_OF",
                "degrees": ["BACHELOR"],
                "educationMajors": ["Computer Science"],
            },
            viewer_role="APPLICANT",
        )

        self.assertTrue(any(
            item.startswith("Education:")
            and "no education evidence" in item
            for item in output
        ))

    def test_toeic_without_score_is_not_reported_as_missing_language(self):
        output = build_match_summary(
            match_score=0.6,
            per_field_scores=self.fields,
            hard_filter=self.hard,
            cv={
                "entitiesByLabel": {
                    "CERTIFICATION": ["TOEIC Listening and Reading"],
                    "JOB_TITLE": ["AI Engineer Intern"],
                }
            },
            jd={
                "jobTitle": "AI Engineer",
                "languageRequired": True,
                "languageRequirements": [{
                    "languageName": "English",
                    "proficiencyLevel": "Advanced",
                }],
            },
            viewer_role="APPLICANT",
        )

        language_line = next(
            item for item in output if item.startswith("Language:")
        )
        self.assertIn("evidence was found", language_line)
        self.assertIn("level or score is not recorded", language_line)
        self.assertNotIn("missing or below", language_line)


if __name__ == "__main__":
    unittest.main()
