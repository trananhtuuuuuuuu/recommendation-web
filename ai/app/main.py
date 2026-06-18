"""FastAPI entry point for CV parsing."""

from __future__ import annotations

import logging
import os

from fastapi import FastAPI, File, HTTPException, UploadFile

from .parser import CvParser, UnsupportedDocumentError


MAX_UPLOAD_BYTES = int(os.getenv("AI_MAX_UPLOAD_BYTES", str(15 * 1024 * 1024)))
LOGGER = logging.getLogger(__name__)
parser = CvParser(
    model_dir=os.getenv("AI_MODEL_DIR", "/models/layoutlmv3"),
    max_pages=int(os.getenv("AI_MAX_PAGES", "3")),
    enable_model=os.getenv("AI_WITH_MODEL", "false").lower() == "true",
    ocr_languages=os.getenv("AI_OCR_LANGUAGES", "eng+vie"),
)

app = FastAPI(
    title="PrivacyJobs CV Parser",
    version="1.0.0",
    description="LayoutLMv3 CV parsing service trained by ai/train_layoutlmv3_cv.ipynb.",
)


@app.get("/health")
def health() -> dict:
    """Report service readiness and whether the trained model is mounted."""
    return {
        "status": "ok",
        "modelLoaded": parser.model_available,
        "fallbackAvailable": True,
        "imageOcrAvailable": parser.image_ocr_available,
    }


@app.post("/parse-cv")
async def parse_cv(file: UploadFile = File(...)) -> dict:
    """Parse an uploaded CV into applicant profile fields."""
    content = await file.read()
    if not content:
        raise HTTPException(status_code=400, detail="CV file is empty.")
    if len(content) > MAX_UPLOAD_BYTES:
        raise HTTPException(status_code=413, detail="CV file exceeds the 15 MB limit.")

    try:
        return parser.parse(content, file.filename or "cv")
    except UnsupportedDocumentError as exception:
        raise HTTPException(status_code=422, detail=str(exception)) from exception
    except Exception as exception:
        LOGGER.exception("CV analysis failed")
        raise HTTPException(
            status_code=500,
            detail="The CV could not be analyzed.",
        ) from exception
