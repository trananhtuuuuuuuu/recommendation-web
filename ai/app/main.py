"""FastAPI entry point for CV parsing."""

from __future__ import annotations

import logging
import os

from fastapi import FastAPI, File, HTTPException, UploadFile
from pydantic import BaseModel, Field

from .parser import CvParser, UnsupportedDocumentError


class MatchOptions(BaseModel):
    llm: bool = False
    method: str = "embedding"


class MatchRequest(BaseModel):
    cv: dict = Field(default_factory=dict)
    jd: dict = Field(default_factory=dict)
    options: MatchOptions = Field(default_factory=MatchOptions)


MAX_UPLOAD_BYTES = int(os.getenv("AI_MAX_UPLOAD_BYTES", str(15 * 1024 * 1024)))
LOGGER = logging.getLogger(__name__)
parser = CvParser(
    model_dir=os.getenv("AI_MODEL_DIR", "/models/layoutlmv3"),
    max_pages=int(os.getenv("AI_MAX_PAGES", "3")),
    enable_model=os.getenv("AI_WITH_MODEL", "false").lower() == "true",
    ocr_languages=os.getenv("AI_OCR_LANGUAGES", "eng+vie"),
    ocr_engine=os.getenv("AI_OCR_ENGINE", "paddle"),
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
        "recommenderModelLoaded": _svm_loaded(),
        "word2vecLoaded": _word2vec_loaded(),
        "ollamaModel": os.getenv("OLLAMA_MODEL", "qwen2.5:3b"),
    }


def _svm_loaded() -> bool:
    try:
        from .recommend.decision import load_model

        return load_model() is not None
    except Exception:
        return False


def _word2vec_loaded() -> bool:
    try:
        from .recommend.config import WORD2VEC_PATH

        return WORD2VEC_PATH.exists()
    except Exception:
        return False


@app.post("/parse-cv")
async def parse_cv(file: UploadFile = File(...)) -> dict:
    """Parse an uploaded CV into applicant profile fields (legacy contract)."""
    content = await _read_upload(file)
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


@app.post("/aggregate")
async def aggregate(file: UploadFile = File(...)) -> dict:
    """Aggregate LayoutLM output into the canonical structured CV JSON."""
    content = await _read_upload(file)
    try:
        return parser.parse_canonical(content, file.filename or "cv")
    except UnsupportedDocumentError as exception:
        raise HTTPException(status_code=422, detail=str(exception)) from exception
    except Exception as exception:
        LOGGER.exception("CV aggregation failed")
        raise HTTPException(
            status_code=500,
            detail="The CV could not be aggregated.",
        ) from exception


@app.post("/match")
async def match(request: MatchRequest) -> dict:
    """Score a canonical CV against a structured JD and explain the result."""
    from dataclasses import asdict

    from .recommend import run_match
    from .recommend.llm_suggest import llm_enabled

    try:
        result = run_match(
            request.cv,
            request.jd,
            method=request.options.method,
            enable_llm=request.options.llm and llm_enabled(),
        )
        return asdict(result)
    except Exception as exception:
        LOGGER.exception("CV matching failed")
        raise HTTPException(
            status_code=500,
            detail="The CV could not be matched against the job description.",
        ) from exception


async def _read_upload(file: UploadFile) -> bytes:
    content = await file.read()
    if not content:
        raise HTTPException(status_code=400, detail="CV file is empty.")
    if len(content) > MAX_UPLOAD_BYTES:
        raise HTTPException(status_code=413, detail="CV file exceeds the 15 MB limit.")
    return content
