"""Train a Word2Vec model for the Group 3 WMD comparison baseline.

The corpus should be the collection of CV + JD texts (one document per line, or a
JSON array of strings). Saves KeyedVectors to ai/model/word2vec.kv.

Usage:
    python -m scripts.train_word2vec --corpus corpus.txt
"""

from __future__ import annotations

import argparse
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from app.recommend.config import WORD2VEC_PATH  # noqa: E402
from app.recommend.textnorm import tokenize  # noqa: E402


def read_corpus(path: pathlib.Path) -> list[list[str]]:
    text = path.read_text(encoding="utf-8")
    if path.suffix == ".json":
        data = json.loads(text)
        documents = [str(item) for item in data] if isinstance(data, list) else [str(data)]
    else:
        documents = [line for line in text.splitlines() if line.strip()]
    return [tokens for document in documents if (tokens := tokenize(document))]


def main() -> None:
    parser = argparse.ArgumentParser(description="Train Word2Vec for the WMD baseline.")
    parser.add_argument("--corpus", type=pathlib.Path, required=True)
    parser.add_argument("--out", type=pathlib.Path, default=WORD2VEC_PATH)
    parser.add_argument("--vector-size", type=int, default=100)
    parser.add_argument("--window", type=int, default=5)
    parser.add_argument("--min-count", type=int, default=1)
    parser.add_argument("--epochs", type=int, default=20)
    args = parser.parse_args()

    try:
        from gensim.models import Word2Vec
    except ImportError:
        raise SystemExit("gensim is required: pip install -r requirements-reco.txt")

    sentences = read_corpus(args.corpus)
    if not sentences:
        raise SystemExit(f"No usable documents found in {args.corpus}")

    model = Word2Vec(
        sentences,
        vector_size=args.vector_size,
        window=args.window,
        min_count=args.min_count,
        epochs=args.epochs,
        workers=4,
    )
    args.out.parent.mkdir(parents=True, exist_ok=True)
    model.wv.save(str(args.out))
    print(
        f"Trained Word2Vec on {len(sentences)} documents; "
        f"vocab={len(model.wv)}; saved to {args.out}"
    )


if __name__ == "__main__":
    main()
