"""Tests for the Group 2 rule-based hard filter."""

import unittest
from datetime import date

from app.recommend.hard_filter import _required_years, run_hard_filter
from app.recommend.schemas import JobDescriptionInput


def make_cv(*, dates=None, candidate_location=None, work_location=None, gpa=None):
    by_label = {}
    if dates:
        by_label["DATE"] = dates
    if candidate_location:
        by_label["CANDIDATE_LOCATION"] = candidate_location
    if work_location:
        by_label["LOCATION"] = work_location
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


class LocationTests(unittest.TestCase):

    def test_alias_match(self):
        result = run_hard_filter(
            make_cv(candidate_location=["TP.HCM"]),
            JobDescriptionInput(location="Ho Chi Minh"),
        )
        self.assertTrue(result.location_ok)

    def test_remote_auto_passes(self):
        result = run_hard_filter(
            make_cv(candidate_location=["Ha Noi"]),
            JobDescriptionInput(location="Remote"),
        )
        self.assertTrue(result.location_ok)

    def test_mismatch_fails(self):
        result = run_hard_filter(
            make_cv(candidate_location=["Ho Chi Minh City"]),
            JobDescriptionInput(location="Ha Noi"),
        )
        self.assertFalse(result.location_ok)

    def test_missing_candidate_location_is_lenient(self):
        result = run_hard_filter(make_cv(), JobDescriptionInput(location="Ha Noi"))
        self.assertTrue(result.location_ok)


class ExperienceTests(unittest.TestCase):

    def test_reject_when_gap_is_egregious(self):
        # Senior (5y) vs ~1y of experience -> gap 3.5 >= HARD_GAP -> hard reject.
        result = run_hard_filter(
            make_cv(dates=["01/2024 - 01/2025"]),
            JobDescriptionInput(experience_level="Senior (5+ years)"),
            today=date(2025, 1, 1),
        )
        self.assertFalse(result.passed)
        self.assertEqual(result.exp_fit, 0.0)
        self.assertTrue(any("experience gap is too large" in reason.lower() for reason in result.reasons))

    def test_pass_when_enough_experience(self):
        result = run_hard_filter(
            make_cv(dates=["01/2020 - 01/2025"]),
            JobDescriptionInput(experience_level="1+ years"),
            today=date(2025, 1, 1),
        )
        self.assertTrue(result.passed)
        self.assertEqual(result.exp_fit, 1.0)

    def test_small_shortfall_passes_with_soft_penalty(self):
        # Mid (3y) vs 1y of experience -> gap 1.5 < HARD_GAP -> pass but penalised.
        result = run_hard_filter(
            make_cv(dates=["01/2024 - 01/2025"]),
            JobDescriptionInput(experience_level="Mid"),
            today=date(2025, 1, 1),
        )
        self.assertTrue(result.passed)
        self.assertEqual(result.reasons, [])
        self.assertAlmostEqual(result.exp_fit, 0.75)  # 1 - (1.5/3)*(1-0.5)

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
        # 0.3 + 0.5 tolerance = 0.8 < 1 -> small shortfall: now passes, lightly penalised.
        self.assertTrue(result.passed)
        self.assertLess(result.exp_fit, 1.0)


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


if __name__ == "__main__":
    unittest.main()
