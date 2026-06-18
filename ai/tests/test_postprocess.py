import unittest

from app.postprocess import EntitySpan, build_profile


class PostprocessTests(unittest.TestCase):

    def test_model_entities_are_mapped_to_profile_fields(self):
        profile = build_profile(
            [
                EntitySpan("NAME", "Nguyen Van A", 0.98),
                EntitySpan("PHONE", "+84 901 234 567", 0.94),
                EntitySpan("CANDIDATE_LOCATION", "Ho Chi Minh City", 0.91),
                EntitySpan("SUMMARY", "Backend engineer focused on secure APIs.", 0.89),
                EntitySpan("SKILL", "Java", 0.97),
                EntitySpan("SKILL", "Spring Boot", 0.96),
                EntitySpan("JOB_TITLE", "Software Engineer", 0.92),
                EntitySpan("COMPANY", "Example Corp", 0.90),
                EntitySpan("DATE", "2024 - Present", 0.88),
                EntitySpan("EDUCATION", "HCMUS - Computer Science", 0.93),
                EntitySpan("CERTIFICATION", "AWS Cloud Practitioner", 0.90),
            ],
            "nguyenvana@example.com",
            model_used=True,
        )

        self.assertEqual(profile["fullName"], "Nguyen Van A")
        self.assertEqual(profile["phone"], "+84 901 234 567")
        self.assertEqual(profile["skills"], ["Java", "Spring Boot"])
        self.assertEqual(profile["experience"][0]["companyName"], "Example Corp")
        self.assertEqual(profile["detectedEmail"], "nguyenvana@example.com")
        self.assertEqual(profile["extractionMode"], "layoutlmv3")

    def test_text_fallback_extracts_sections_without_overstating_model_usage(self):
        profile = build_profile(
            [],
            """
            Tran Thi B
            tranb@example.com
            +84 912 345 678

            Skills
            React, TypeScript, SQL

            Education
            HCMUS - Bachelor of Computer Science
            """,
            model_used=False,
        )

        self.assertEqual(profile["fullName"], "Tran Thi B")
        self.assertIn("TypeScript", profile["skills"])
        self.assertEqual(profile["extractionMode"], "heuristic")
        self.assertTrue(profile["warnings"])


if __name__ == "__main__":
    unittest.main()
