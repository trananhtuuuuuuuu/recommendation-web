"""Tests for the canonical CV structure (standard display schema)."""

import unittest

from app.postprocess import EntitySpan, build_canonical, build_profile


def _positioned(label, text, order):
    """A model-path span carrying a bounding box and reading order."""
    top = order * 30
    return EntitySpan(label, text, 0.9, page=0, box=(0, top, 500, top + 20), order=order)


class BuildCanonicalTests(unittest.TestCase):

    def test_personal_and_skills_blocks(self):
        canonical = build_canonical(
            [
                _positioned("NAME", "Nguyen Van A", 0),
                _positioned("CANDIDATE_LOCATION", "Ho Chi Minh City", 1),
                _positioned("SKILL", "Java", 2),
                _positioned("SKILL", "Spring Boot", 3),
                _positioned("SOFT_SKILL", "Teamwork", 4),
                _positioned("LANGUAGE", "English", 5),
            ],
            "nguyenvana@example.com",
            model_used=True,
        )

        personal = canonical["personal_information"]
        self.assertEqual(personal["name"], "Nguyen Van A")
        self.assertEqual(personal["email"], "nguyenvana@example.com")
        self.assertEqual(personal["candidate_location"], "Ho Chi Minh City")
        self.assertEqual(canonical["skills_and_expertise"]["skill"], ["Java", "Spring Boot"])
        self.assertEqual(canonical["skills_and_expertise"]["soft_skill"], ["Teamwork"])
        self.assertEqual(canonical["skills_and_expertise"]["language"], ["English"])

    def test_work_experience_anchored_on_company(self):
        canonical = build_canonical(
            [
                _positioned("JOB_TITLE", "Software Engineer", 0),  # header title, no company
                _positioned("DATE", "06/2021 - 09/2021", 5),
                _positioned("JOB_TITLE", "Backend Developer", 6),
                _positioned("COMPANY", "Example Corp", 7),
                _positioned("EXPERIENCE", "Built secure REST APIs", 8),
                _positioned("DATE", "10/2021 - Present", 15),
                _positioned("JOB_TITLE", "Senior Developer", 16),
                _positioned("COMPANY", "ABC Group", 17),
                _positioned("EXPERIENCE", "Led the backend team", 18),
            ],
            "",
            model_used=True,
        )

        work = canonical["work_experience"]
        self.assertEqual(len(work), 2)  # header title does not create an entry
        self.assertEqual(work[0]["company"], "Example Corp")
        self.assertEqual(work[0]["job_title"], "Backend Developer")
        self.assertEqual(work[0]["date"], "06/2021 - 09/2021")  # kept raw, not split
        self.assertEqual(work[0]["experience"], "Built secure REST APIs")
        self.assertEqual(work[1]["company"], "ABC Group")
        self.assertEqual(work[1]["job_title"], "Senior Developer")

    def test_education_history_block(self):
        canonical = build_canonical(
            [
                _positioned("DATE", "2018 - 2022", 50),
                _positioned("EDUCATION", "Bachelor of Computer Science", 51),
                _positioned("EDUCATION", "HCMUS University", 52),
                _positioned("GPA", "3.6/4.0", 53),
            ],
            "",
            model_used=True,
        )

        education = canonical["education_history"]
        self.assertEqual(len(education), 1)
        # School and degree/major are kept together (major no longer dropped).
        self.assertEqual(education[0]["school"], "HCMUS University")
        self.assertEqual(education[0]["degree"], "Bachelor of Computer Science")
        self.assertEqual(education[0]["education"], "Bachelor of Computer Science — HCMUS University")
        self.assertEqual(education[0]["date"], "2018 - 2022")
        self.assertEqual(education[0]["gpa"], "3.6/4.0")

    def test_work_location_distinct_from_candidate_location(self):
        canonical = build_canonical(
            [
                _positioned("CANDIDATE_LOCATION", "Ho Chi Minh City", 0),
                _positioned("DATE", "01/2020 - 01/2022", 10),
                _positioned("JOB_TITLE", "Engineer", 11),
                _positioned("COMPANY", "Acme", 12),
                _positioned("LOCATION", "Ha Noi", 13),
                _positioned("EXPERIENCE", "Worked on systems", 14),
            ],
            "",
            model_used=True,
        )

        self.assertEqual(canonical["personal_information"]["candidate_location"], "Ho Chi Minh City")
        self.assertEqual(canonical["work_experience"][0]["location"], "Ha Noi")
        self.assertEqual(canonical["entitiesByLabel"]["CANDIDATE_LOCATION"], ["Ho Chi Minh City"])
        self.assertEqual(canonical["entitiesByLabel"]["LOCATION"], ["Ha Noi"])

    def test_personal_link_prefers_profile_over_project(self):
        canonical = build_canonical(
            [
                _positioned("NAME", "Tri", 0),
                _positioned("LINK", "https://github.com/trongtriGH/product-store", 1),
                _positioned("LINK", "https://github.com/trongtriGH", 2),
            ],
            "",
            model_used=True,
        )
        self.assertEqual(canonical["personal_information"]["link"], "https://github.com/trongtriGH")

    def test_projects_block(self):
        canonical = build_canonical(
            [
                _positioned("PROJECT", "AI Resume Parser", 30),
                _positioned("DATE", "01/2023 - 04/2023", 31),
            ],
            "",
            model_used=True,
        )
        self.assertEqual(canonical["projects"][0]["project"], "AI Resume Parser")
        self.assertEqual(canonical["projects"][0]["date"], "01/2023 - 04/2023")

    def test_all_eighteen_labels_present_in_entities_by_label(self):
        canonical = build_canonical([], "", model_used=False)
        expected = {
            "NAME", "EMAIL", "PHONE", "SUMMARY", "EDUCATION", "EXPERIENCE", "SKILL",
            "SOFT_SKILL", "JOB_TITLE", "COMPANY", "DATE", "LOCATION", "CANDIDATE_LOCATION",
            "CERTIFICATION", "LANGUAGE", "PROJECT", "GPA", "LINK",
        }
        self.assertEqual(set(canonical["entitiesByLabel"]), expected)

    def test_total_experience_years_is_computed(self):
        # Years are summed from the dates of detected jobs, so the date needs a
        # real work block (company + experience) around it to count.
        canonical = build_canonical(
            [
                _positioned("JOB_TITLE", "Engineer", 0),
                _positioned("COMPANY", "Acme", 1),
                _positioned("DATE", "01/2020 - 01/2023", 2),
                _positioned("EXPERIENCE", "Built systems", 3),
            ],
            "",
            model_used=True,
        )
        self.assertEqual(canonical["totalExperienceYears"], 3.0)

    def test_no_spurious_empty_blocks(self):
        # A lone header job title (no company/date) must not produce a work entry.
        canonical = build_canonical(
            [_positioned("JOB_TITLE", "Data Scientist", 1)],
            "",
            model_used=True,
        )
        self.assertEqual(canonical["work_experience"], [])

    def test_keyword_fields_trim_edge_punctuation(self):
        canonical = build_canonical(
            [
                _positioned("SKILL", "Python,", 0),
                _positioned("SKILL", "(OpenWeatherMap", 1),
                _positioned("SKILL", "Data Engineering:", 2),
                _positioned("SKILL", ".NET", 3),  # leading dot must be preserved
                _positioned("SKILL", "Git/GitHub,", 4),
                _positioned("SOFT_SKILL", "Teamwork,", 5),
            ],
            "",
            model_used=True,
        )
        skills = canonical["skills_and_expertise"]["skill"]
        self.assertIn("Python", skills)
        self.assertIn("OpenWeatherMap", skills)
        self.assertIn("Data Engineering", skills)
        self.assertIn(".NET", skills)
        self.assertIn("Git/GitHub", skills)
        self.assertNotIn("Python,", skills)
        self.assertEqual(canonical["skills_and_expertise"]["soft_skill"], ["Teamwork"])

    def test_education_date_excluded_from_work_and_years(self):
        # A degree's "Sep 2018 - Present" must not become a job nor count as work.
        canonical = build_canonical(
            [
                _positioned("EDUCATION", "HCMUS University", 0),
                _positioned("DATE", "Sep 2018 - Present", 1),  # education period
                _positioned("GPA", "3.6", 2),
                _positioned("DATE", "Jan 2023 - Jun 2023", 5),  # work period
                _positioned("JOB_TITLE", "Data Intern", 6),
                _positioned("COMPANY", "Acme Corp", 7),
                _positioned("EXPERIENCE", "Built ETL jobs", 8),
            ],
            "",
            model_used=True,
        )
        work = canonical["work_experience"]
        self.assertEqual(len(work), 1)
        self.assertEqual(work[0]["company"], "Acme Corp")
        self.assertEqual(work[0]["date"], "Jan 2023 - Jun 2023")  # not the degree date
        self.assertLess(canonical["totalExperienceYears"], 1.0)  # ~0.4y, not 6+ years

    def test_company_recovered_from_mislabelled_title(self):
        # The model labelled the org "THG Fulfillment" as JOB_TITLE and found no
        # COMPANY; it should be recovered as the company, with the real role kept.
        canonical = build_canonical(
            [
                _positioned("JOB_TITLE", "THG Fulfillment", 0),
                _positioned("DATE", "Mar 2024 - Present", 1),
                _positioned("JOB_TITLE", "IT Intern", 2),
                _positioned("EXPERIENCE", "Built data pipelines", 3),
            ],
            "",
            model_used=True,
        )
        work = canonical["work_experience"]
        self.assertEqual(len(work), 1)
        self.assertEqual(work[0]["company"], "THG Fulfillment")
        self.assertEqual(work[0]["job_title"], "IT Intern")


class BuildProfileBackwardCompatTests(unittest.TestCase):
    """The legacy build_profile contract must remain unchanged."""

    def test_legacy_profile_still_built(self):
        profile = build_profile(
            [EntitySpan("NAME", "Nguyen Van A", 0.98), EntitySpan("SKILL", "Java", 0.97)],
            "nguyenvana@example.com",
            model_used=True,
        )
        self.assertEqual(profile["fullName"], "Nguyen Van A")
        self.assertEqual(profile["skills"], ["Java"])
        self.assertIn("experience", profile)


if __name__ == "__main__":
    unittest.main()
