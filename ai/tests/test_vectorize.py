"""Tests for the similarity primitives and JD field-text derivation."""

import unittest

from app.recommend.jd_fields import jd_field_text
from app.recommend.schemas import JobDescriptionInput
from app.recommend.vectorize import cosine_tfidf, cosine_tfidf_batch, wmd_word2vec


class _FakeKeyedVectors:
    """Minimal stand-in for gensim KeyedVectors (no gensim dependency)."""

    def __init__(self, vocabulary):
        self._vocabulary = set(vocabulary)

    def __contains__(self, token):
        return token in self._vocabulary

    def wmdistance(self, left, right):
        return 0.0 if set(left) == set(right) else 1.0


class CosineTfidfTests(unittest.TestCase):

    def test_identical_text_is_high(self):
        self.assertGreater(cosine_tfidf("java spring boot", "java spring boot"), 0.9)

    def test_disjoint_text_is_zero(self):
        self.assertEqual(cosine_tfidf("java spring", "python django"), 0.0)

    def test_empty_side_is_zero(self):
        self.assertEqual(cosine_tfidf("", "java"), 0.0)
        self.assertEqual(cosine_tfidf("java", ""), 0.0)

    def test_accent_insensitive(self):
        self.assertGreater(cosine_tfidf("kỹ năng java", "ky nang java"), 0.5)

    def test_batch_preserves_order(self):
        scores = cosine_tfidf_batch([("java", "java"), ("java", "python")])
        self.assertEqual(len(scores), 2)
        self.assertGreater(scores[0], scores[1])


class WmdTests(unittest.TestCase):

    def test_identical_tokens_high(self):
        kv = _FakeKeyedVectors(["java", "spring"])
        self.assertEqual(wmd_word2vec("java spring", "java spring", kv), 1.0)

    def test_out_of_vocab_is_zero(self):
        kv = _FakeKeyedVectors(["java"])
        self.assertEqual(wmd_word2vec("python", "django", kv), 0.0)


class JdFieldTextTests(unittest.TestCase):

    def test_skill_maps_to_requirements_only(self):
        jd = JobDescriptionInput(requirements="Java Spring", job_description="Build APIs")
        self.assertEqual(jd_field_text("SKILL", jd), "Java Spring")

    def test_experience_concatenates_sources(self):
        jd = JobDescriptionInput(requirements="Java", job_description="Build APIs")
        text = jd_field_text("EXPERIENCE", jd)
        self.assertIn("Build APIs", text)
        self.assertIn("Java", text)


if __name__ == "__main__":
    unittest.main()
