# CV Parsing Service

This service runs inference for the LayoutLMv3 model produced by
`train_layoutlmv3_cv.ipynb`.

Place the exported Hugging Face checkpoint under `model/layoutlmv3`:

```text
ai/model/
├── layoutlmv3/
│   ├── config.json
│   ├── model.safetensors
│   └── processor/tokenizer files
└── recommender_svm*.joblib
```

Docker Compose mounts the model root at `/app/model`; the parser reads
`/app/model/layoutlmv3`, while the recommender reads the `.joblib` files from
`/app/model`.

To mount a different model root with the same structure, set:

```bash
AI_MODEL_HOST_PATH=/absolute/path/to/model-root
AI_WITH_MODEL=true
```

When the model is not mounted, PDF, DOC, DOCX, PNG, JPG, WebP, BMP, and TIFF
CVs use a conservative fallback. Tesseract OCR reads image and scanned PDF
text, then profile fields are inferred from that text. When the trained model
is enabled, Tesseract also supplies the word coordinates used by LayoutLMv3.

## Build modes

The default Docker build installs only the lightweight dependencies needed for
text-based PDF, DOC, and DOCX fallback extraction:

```bash
docker compose build ai
docker compose up -d
```

To install CPU PyTorch and Transformers for the exported model:

```bash
AI_WITH_MODEL=true \
AI_MODEL_HOST_PATH=/absolute/path/to/model-root \
docker compose up --build -d
```

The full model image is substantially larger and takes longer to download.

## Endpoints

| Method | Path | Purpose |
| ------ | ---- | ------- |
| POST | `/parse-cv` | Legacy profile fields (`fullName`, `skills`, ...) — unchanged contract. |
| POST | `/aggregate` | Canonical structured CV JSON built from the 18 LayoutLM labels (nested `experience`/`education` blocks with split `startDate`/`endDate`, plus `entitiesByLabel`). |
| POST | `/match` | Score a canonical CV against a structured JD (the 5-group recommender). |
| GET | `/health` | Adds `recommenderModelLoaded`, `word2vecLoaded`, `ollamaModel`. |

`/match` request body:

```json
{
  "cv": { "entitiesByLabel": { "SKILL": ["Java"], "DATE": ["01/2021 - Present"], "...": [] } },
  "jd": { "jobTitle": "...", "requirements": "...", "jobDescription": "...",
          "location": "...", "experienceLevel": "2+ years", "industry": "..." },
  "options": { "llm": false, "method": "tfidf" }
}
```

`cv` accepts the full `/aggregate` output or just an `{ "entitiesByLabel": ... }` object.
`options.method` is `tfidf` (default) or `word2vec`.

## Recommendation pipeline (`app/recommend/`)

Five groups run in order on a parsed CV and a structured JD:

1. **Data masking** — drop PII (NAME/EMAIL/PHONE/LINK) and scrub free text.
2. **Hard filter** — rule-based location + years-of-experience (from DATE) + GPA gate; rejects before the expensive steps.
3. **Vector space (TF-IDF, primary)** — per-field cosine for SKILL, SOFT_SKILL, LANGUAGE, CERTIFICATION, JOB_TITLE, COMPANY, EDUCATION. Word2Vec + WMD is an opt-in comparison baseline.
4. **Semantic matching (TF-IDF)** — per-field cosine for SUMMARY, EXPERIENCE, PROJECT.
5. **Decision (SVM + Field-to-Field Weighting)** — aggregates the field scores into a match score with an explainable recommendation reason. Falls back to a heuristic weighted average until the SVM is trained.

The result feeds a local **Ollama** LLM (`OLLAMA_MODEL`, default `gemma2:2b`) that writes
English suggestions; a deterministic template is used when Ollama is unreachable.

### Recommender dependencies and offline tools

```bash
pip install -r requirements.txt        # TF-IDF pipeline (scikit-learn, scipy, joblib, httpx)
pip install -r requirements-reco.txt   # optional: gensim, for the Word2Vec/WMD baseline

python -m scripts.train_svm                       # train the decision SVM from the seed CSV
python -m scripts.train_word2vec --corpus cv_jd.txt   # train Word2Vec for the WMD baseline
python -m scripts.evaluate_vectors                # TF-IDF vs Word2Vec comparison table
```

Relevant env vars: `OLLAMA_BASE_URL`, `OLLAMA_MODEL`, `OLLAMA_TIMEOUT`, and
`RECO_DISABLE_LLM=1` to force the template fallback (used in tests).
