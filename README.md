# recommendation-web

```bash
docker compose up --build -d
docker compose up --build -d backend
docker compose up --build -d --no-deps frontend
```

## LayoutLMv3 CV autofill

For UI testing with PDF, DOC, DOCX, PNG, JPG, WebP, BMP, or TIFF files, use
the default lightweight AI image. Image and scanned PDF text is read with
Tesseract OCR:

```bash
docker compose build ai
docker compose up -d ai backend frontend
curl http://localhost:8001/health
```

Export the trained model from `ai/train_layoutlmv3_cv.ipynb`, then either place
the exported model files in `ai/model` or point Docker Compose to them:

```bash
AI_WITH_MODEL=true \
AI_MODEL_HOST_PATH=/absolute/path/to/layoutlmv3_out/model \
docker compose up --build -d
```

Without the exported model, text-based PDF, DOC, and DOCX files use the
conservative fallback parser. See `ai/README.md` for details.
