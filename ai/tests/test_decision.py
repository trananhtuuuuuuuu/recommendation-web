"""Tests for the Group 5 decision model (heuristic + SVM paths)."""

import unittest
from unittest import mock

from app.recommend import decision
from app.recommend.config import FIELD_ORDER
from app.recommend.decision import strong_fields, to_feature_vector, weak_fields


class FeatureVectorTests(unittest.TestCase):

    def test_order_and_missing_filled_with_zero(self):
        vector = to_feature_vector({"SKILL": 0.5, "JOB_TITLE": 0.8})
        self.assertEqual(len(vector), len(FIELD_ORDER))
        self.assertEqual(vector[FIELD_ORDER.index("SKILL")], 0.5)
        self.assertEqual(vector[FIELD_ORDER.index("JOB_TITLE")], 0.8)
        self.assertEqual(vector[FIELD_ORDER.index("PROJECT")], 0.0)


class HeuristicDecisionTests(unittest.TestCase):

    def test_heuristic_used_when_no_model(self):
        with mock.patch.object(decision, "load_model", return_value=None):
            score, reason, model_used = decide_scores({"SKILL": 0.8, "JOB_TITLE": 0.9})
        self.assertEqual(model_used, "heuristic")
        self.assertGreater(score, 0.0)
        self.assertLessEqual(score, 1.0)

    def test_reason_names_top_contributor(self):
        with mock.patch.object(decision, "load_model", return_value=None):
            _, reason, _ = decide_scores({"JOB_TITLE": 0.9, "SKILL": 0.1})
        # English reason names the strongest field first, with its match %.
        self.assertIn("job title", reason)
        self.assertIn("90%", reason)

    def test_empty_scores_give_zero(self):
        with mock.patch.object(decision, "load_model", return_value=None):
            score, reason, _ = decide_scores({})
        self.assertEqual(score, 0.0)
        self.assertIn("isn't enough overlap", reason)


class SvmDecisionTests(unittest.TestCase):

    def test_svm_probability_used_when_model_present(self):
        pipeline = mock.Mock()
        pipeline.predict_proba.return_value = [[0.2, 0.8]]
        bundle = {"pipeline": pipeline, "weights": {field: 1.0 for field in FIELD_ORDER}}
        with mock.patch.object(decision, "load_model", return_value=bundle):
            score, _, model_used = decide_scores({"SKILL": 0.5})
        self.assertEqual(model_used, "svm")
        self.assertEqual(score, 0.8)


class FieldSelectionTests(unittest.TestCase):

    def test_strong_and_weak_fields(self):
        scores = {"SKILL": 0.8, "JOB_TITLE": 0.05, "EXPERIENCE": 0.5}
        self.assertIn("SKILL", strong_fields(scores))
        self.assertIn("JOB_TITLE", weak_fields(scores))
        self.assertNotIn("SKILL", weak_fields(scores))


def decide_scores(scores):
    return decision.decide(scores)


if __name__ == "__main__":
    unittest.main()
