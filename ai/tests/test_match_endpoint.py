"""Smoke tests for the /aggregate and /match FastAPI endpoints."""

import os
import unittest

os.environ.setdefault("RECO_DISABLE_LLM", "1")  # never call Ollama from tests

from fastapi.testclient import TestClient

from app.main import app
from app.postprocess import EntitySpan, build_canonical


client = TestClient(app)


def make_cv_payload():
    spans = [
        EntitySpan("SKILL", "Java", 0.9),
        EntitySpan("SKILL", "Spring Boot", 0.9),
        EntitySpan("JOB_TITLE", "Backend Engineer", 0.9),
        EntitySpan("DATE", "01/2020 - 01/2024", 0.9),
        EntitySpan("CANDIDATE_LOCATION", "Ho Chi Minh City", 0.9),
        EntitySpan("SUMMARY", "Backend engineer building REST APIs.", 0.9),
    ]
    return build_canonical(spans, "", model_used=True)


class HealthTests(unittest.TestCase):

    def test_health_reports_recommender_fields(self):
        response = client.get("/health")
        self.assertEqual(response.status_code, 200)
        body = response.json()
        self.assertIn("recommenderModelLoaded", body)
        self.assertIn("word2vecLoaded", body)
        self.assertIn("ollamaModel", body)


class MatchEndpointTests(unittest.TestCase):

    def test_match_returns_scores_and_reason(self):
        payload = {
            "cv": make_cv_payload(),
            "jd": {
                "jobTitle": "Backend Engineer",
                "requirements": "Java, Spring Boot. At least 1 year of experience.",
                "jobDescription": "Build and maintain REST APIs.",
                "location": "Ho Chi Minh",
                "experienceLevel": "1+ years",
            },
            "options": {"llm": False, "method": "tfidf"},
        }
        response = client.post("/match", json=payload)
        self.assertEqual(response.status_code, 200)
        body = response.json()
        for key in ("passed_filter", "hard_filter", "per_field_scores", "match_score", "reason"):
            self.assertIn(key, body)
        self.assertTrue(body["passed_filter"])
        self.assertIn("SKILL", body["per_field_scores"])

    def test_match_rejects_under_experienced(self):
        payload = {
            "cv": make_cv_payload(),
            "jd": {"jobTitle": "Backend Engineer", "experienceLevel": "Senior (8+ years)"},
            "options": {"llm": False},
        }
        response = client.post("/match", json=payload)
        self.assertEqual(response.status_code, 200)
        self.assertFalse(response.json()["passed_filter"])


if __name__ == "__main__":
    unittest.main()
