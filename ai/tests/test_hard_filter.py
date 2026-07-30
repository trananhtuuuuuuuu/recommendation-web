"""Tests for the Group 2 rule-based hard filter."""

import unittest
from datetime import date

from app.recommend.hard_filter import _required_years, run_hard_filter
from app.recommend.schemas import JobDescriptionInput


def make_cv(
    *,
    dates=None,
    candidate_location=None,
    work_location=None,
    languages=None,
    certificates=None,
    gpa=None,
):
    by_label = {}
    if dates:
        by_label["DATE"] = dates
    if candidate_location:
        by_label["CANDIDATE_LOCATION"] = candidate_location
    if work_location:
        by_label["LOCATION"] = work_location
    if languages:
        by_label["LANGUAGE"] = languages
    if certificates:
        by_label["CERTIFICATION"] = certificates
    cv = {"entitiesByLabel": by_label}
    if gpa:
        cv["gpa"] = gpa
    return cv


class RequiredYearsTests(unittest.TestCase):

    def test_seniority_keywords(self):
        self.assertEqual(_required_years("Senior"), 5.0)
        self.assertEqual(_required_years("Junior"), 1.0)
        self.assertEqual(_required_years("Fresher"), 0.0)

    def test_explicit_numbers(self):
        self.assertEqual(_required_years("2+ years"), 2.0)
        self.assertEqual(_required_years("Yêu cầu 3 năm kinh nghiệm"), 3.0)

    def test_structured_minimum_years_overrides_legacy_level(self):
        result = run_hard_filter(
            {"entitiesByLabel": {}, "totalExperienceYears": 1.0},
            JobDescriptionInput(
                experience_level="Junior",
                minimum_years_experience="5",
            ),
        )

        self.assertEqual(result.required_years, 5.0)
        self.assertFalse(result.passed)


class LocationTests(unittest.TestCase):

    def test_alias_match(self):
        result = run_hard_filter(
            make_cv(candidate_location=["TP.HCM"]),
            JobDescriptionInput(location="Ho Chi Minh"),
            check_location=True,
        )
        self.assertTrue(result.location_ok)

    def test_remote_auto_passes(self):
        result = run_hard_filter(
            make_cv(candidate_location=["Ha Noi"]),
            JobDescriptionInput(location="Remote"),
            check_location=True,
        )
        self.assertTrue(result.location_ok)

    def test_mismatch_fails(self):
        result = run_hard_filter(
            make_cv(candidate_location=["Ho Chi Minh City"]),
            JobDescriptionInput(location="Ha Noi"),
            check_location=True,
        )
        self.assertFalse(result.location_ok)

    def test_missing_candidate_location_is_lenient(self):
        result = run_hard_filter(
            make_cv(),
            JobDescriptionInput(location="Ha Noi"),
            check_location=True,
        )
        self.assertTrue(result.location_ok)

    def test_runtime_default_does_not_filter_location(self):
        result = run_hard_filter(
            make_cv(candidate_location=["Ho Chi Minh City"]),
            JobDescriptionInput(location="Ha Noi"),
        )

        self.assertTrue(result.location_ok)
        self.assertTrue(result.passed)


class ExperienceTests(unittest.TestCase):

    def test_sums_multiple_company_periods_for_tran_binh_shape(self):
        result = run_hard_filter(
            make_cv(dates=[
                "Dec. 2025 — present",
                "July 2025 — Nov. 2025",
            ]),
            JobDescriptionInput(experience_level="1+ years"),
            today=date(2026, 7, 30),
        )

        self.assertAlmostEqual(result.candidate_years, 1.0)
        self.assertTrue(result.passed)

    def test_reject_when_gap_exceeds_one_year_tolerance(self):
        # Senior (5y) vs ~1y fails the external YOE eligibility gate.
        result = run_hard_filter(
            make_cv(dates=["01/2024 - 01/2025"]),
            JobDescriptionInput(experience_level="Senior (5+ years)"),
            today=date(2025, 1, 1),
        )
        self.assertFalse(result.passed)
        self.assertEqual(result.exp_fit, 0.0)
        self.assertTrue(any("experience requirement is not met" in reason.lower() for reason in result.reasons))

    def test_pass_when_enough_experience(self):
        result = run_hard_filter(
            make_cv(dates=["01/2020 - 01/2025"]),
            JobDescriptionInput(experience_level="1+ years"),
            today=date(2025, 1, 1),
        )
        self.assertTrue(result.passed)
        self.assertEqual(result.exp_fit, 1.0)

    def test_shortfall_beyond_tolerance_is_rejected(self):
        # Mid (3y) vs 1y exceeds the configured one-year tolerance.
        result = run_hard_filter(
            make_cv(dates=["01/2024 - 01/2025"]),
            JobDescriptionInput(experience_level="Mid"),
            today=date(2025, 1, 1),
        )
        self.assertFalse(result.passed)
        self.assertEqual(result.exp_fit, 0.0)

    def test_precomputed_work_years_preferred_over_dates(self):
        # The canonical's work-only totalExperienceYears wins over the order-less
        # DATE list (which would naively count the degree period as experience).
        cv = make_cv(dates=["Sep 2018 - Present"])  # ~6y if summed blindly
        cv["totalExperienceYears"] = 0.3
        result = run_hard_filter(
            cv,
            JobDescriptionInput(experience_level="1+ years"),
            today=date(2024, 1, 1),
        )
        self.assertAlmostEqual(result.candidate_years, 0.3)
        # 0.3 + the one-year tolerance reaches the minimum.
        self.assertTrue(result.passed)
        self.assertEqual(result.exp_fit, 1.0)


class GpaTests(unittest.TestCase):

    def test_below_required_fails(self):
        result = run_hard_filter(
            make_cv(gpa="3.0/4.0"),
            JobDescriptionInput(requirements="Minimum GPA 3.5/4.0"),
        )
        self.assertFalse(result.gpa_ok)

    def test_no_constraint_passes(self):
        result = run_hard_filter(
            make_cv(gpa="2.0/4.0"),
            JobDescriptionInput(requirements="Java, Spring Boot"),
        )
        self.assertTrue(result.gpa_ok)


class LanguageTests(unittest.TestCase):

    def required_english(self, level: str) -> JobDescriptionInput:
        return JobDescriptionInput(
            language_required=True,
            language_requirements=[{
                "languageName": "English",
                "proficiencyLevel": level,
            }],
        )

    def test_missing_required_language_is_rejected(self):
        result = run_hard_filter(
            make_cv(),
            self.required_english("Intermediate"),
        )

        self.assertFalse(result.passed)
        self.assertFalse(result.language_ok)
        self.assertEqual(result.language_status, "gap")

    def test_toeic_certificate_and_separate_score_satisfy_intermediate(self):
        result = run_hard_filter(
            make_cv(certificates=["TOEIC Listening and Reading", "900"]),
            self.required_english("Intermediate"),
        )

        self.assertTrue(result.passed)
        self.assertTrue(result.language_ok)
        self.assertEqual(result.language_status, "met")

    def test_certificate_without_score_passes_provisionally(self):
        result = run_hard_filter(
            make_cv(certificates=["TOEIC Listening and Reading"]),
            self.required_english("Advanced"),
        )

        self.assertTrue(result.passed)
        self.assertTrue(result.language_ok)
        self.assertEqual(result.language_status, "unknown")

    def test_explicitly_insufficient_level_is_rejected(self):
        result = run_hard_filter(
            make_cv(languages=["English B1"]),
            self.required_english("B2"),
        )

        self.assertFalse(result.passed)
        self.assertFalse(result.language_ok)


if __name__ == "__main__":
    unittest.main()
