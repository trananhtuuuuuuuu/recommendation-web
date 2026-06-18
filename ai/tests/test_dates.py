"""Tests for the date-range parsing and experience-years utilities."""

import unittest
from datetime import date

from app.dates import (
    DateRange,
    normalize_month_year,
    parse_date_range,
    total_experience_years,
)


class ParseDateRangeTests(unittest.TestCase):

    def test_numeric_month_year_range(self):
        result = parse_date_range("06/2021 - 09/2021")
        self.assertEqual(result.start, "06/2021")
        self.assertEqual(result.end, "09/2021")
        self.assertFalse(result.is_present)
        self.assertEqual(result.duration_years, 0.25)

    def test_present_end_uses_injected_today(self):
        result = parse_date_range("2024 - Present", today=date(2026, 1, 1))
        self.assertEqual(result.start, "01/2024")
        self.assertIsNone(result.end)
        self.assertTrue(result.is_present)
        self.assertEqual(result.duration_years, 2.0)

    def test_vietnamese_present_token(self):
        result = parse_date_range("Jan 2023 - Hiện tại", today=date(2024, 1, 1))
        self.assertEqual(result.start, "01/2023")
        self.assertTrue(result.is_present)
        self.assertEqual(result.duration_years, 1.0)

    def test_year_only_dash_range(self):
        result = parse_date_range("2019-2021")
        self.assertEqual(result.start, "01/2019")
        self.assertEqual(result.end, "12/2021")

    def test_malformed_text_yields_empty_range(self):
        result = parse_date_range("not a date at all")
        self.assertEqual(result, DateRange(None, None, False, 0.0, "not a date at all"))


class NormalizeMonthYearTests(unittest.TestCase):

    def test_month_name(self):
        self.assertEqual(normalize_month_year("Jan 2023"), "01/2023")

    def test_numeric(self):
        self.assertEqual(normalize_month_year("3/2023"), "03/2023")

    def test_year_only_defaults_to_january(self):
        self.assertEqual(normalize_month_year("2023"), "01/2023")

    def test_unparseable_returns_none(self):
        self.assertIsNone(normalize_month_year("senior engineer"))


class TotalExperienceYearsTests(unittest.TestCase):

    def test_non_overlapping_periods_are_summed(self):
        years = total_experience_years(["01/2020 - 01/2021", "01/2022 - 01/2023"])
        self.assertEqual(years, 2.0)

    def test_overlapping_periods_are_merged(self):
        years = total_experience_years(["01/2020 - 01/2022", "01/2021 - 01/2023"])
        self.assertEqual(years, 3.0)

    def test_present_period_uses_today(self):
        years = total_experience_years(["01/2023 - Present"], today=date(2025, 1, 1))
        self.assertEqual(years, 2.0)

    def test_ignores_unparseable_entries(self):
        self.assertEqual(total_experience_years(["no dates here"]), 0.0)


if __name__ == "__main__":
    unittest.main()
