"""Tests for lightweight and model-enabled parser modes."""

import tempfile
import unittest
from pathlib import Path
from subprocess import CompletedProcess
from unittest.mock import Mock

from app.parser import CvParser


class ParserModeTests(unittest.TestCase):
    """Verify optional model dependencies are represented accurately."""

    def test_model_requires_both_build_flag_and_exported_config(self) -> None:
        with tempfile.TemporaryDirectory() as model_dir:
            Path(model_dir, "config.json").write_text("{}", encoding="utf-8")

            self.assertFalse(CvParser(model_dir).model_available)
            self.assertTrue(
                CvParser(model_dir, enable_model=True).model_available
            )

    def test_lightweight_mode_extracts_image_text_with_ocr(self) -> None:
        parser = CvParser("/missing-model")
        parser._load_visual_pages = Mock(return_value=[object()])
        parser._extract_image_text = Mock(
            return_value=(
                "Nguyen Van A\n"
                "nguyen@example.com\n"
                "+84 901 234 567\n"
                "SKILLS\n"
                "Java, Spring Boot"
            )
        )

        profile = parser.parse(b"image bytes", "cv.png")

        self.assertEqual("Nguyen Van A", profile["fullName"])
        self.assertEqual("nguyen@example.com", profile["detectedEmail"])
        self.assertEqual(["Java", "Spring Boot"], profile["skills"])
        self.assertEqual("heuristic", profile["extractionMode"])

    def test_tesseract_tsv_is_converted_to_words_and_boxes(self) -> None:
        parser = CvParser("/missing-model")
        parser._run_tesseract = Mock(
            return_value=CompletedProcess(
                args=[],
                returncode=0,
                stdout=(
                    "level\tpage_num\tblock_num\tpar_num\tline_num\tword_num\t"
                    "left\ttop\twidth\theight\tconf\ttext\n"
                    "5\t1\t1\t1\t1\t1\t10\t20\t40\t12\t95.0\tNguyen\n"
                    "5\t1\t1\t1\t1\t2\t55\t20\t25\t12\t94.0\tAn\n"
                ),
                stderr="",
            )
        )

        words, boxes = parser._ocr_words(object())

        self.assertEqual(["Nguyen", "An"], words)
        self.assertEqual([[10.0, 20.0, 50.0, 32.0], [55.0, 20.0, 80.0, 32.0]], boxes)


if __name__ == "__main__":
    unittest.main()
