# CV Parsing Service

This service runs inference for the LayoutLMv3 model produced by
`train_layoutlmv3_cv.ipynb`.

Place the exported Hugging Face model directory on the host and set:

```bash
AI_MODEL_HOST_PATH=/absolute/path/to/layoutlmv3_out/model
AI_WITH_MODEL=true
```

The directory must contain files such as `config.json`, model weights, and the
saved processor files. Docker Compose mounts it at `/models/layoutlmv3`.

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
AI_MODEL_HOST_PATH=/absolute/path/to/layoutlmv3_out/model \
docker compose up --build -d
```

The full model image is substantially larger and takes longer to download.
