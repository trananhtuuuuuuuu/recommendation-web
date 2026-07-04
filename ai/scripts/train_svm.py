"""Train the Group 5 decision SVM (Field-to-Field Weighting).

Reads a labelled CSV of per-field similarity scores and trains a LinearSVC whose
coefficients become the per-field weights. The fitted model is saved as a bundle
{pipeline, weights} that ``decision.load_model`` consumes.

Usage:
    python -m scripts.train_svm                       # uses the checked-in seed
    python -m scripts.train_svm --data path.csv --out ../model/recommender_svm.joblib
"""

from __future__ import annotations

import argparse
import csv
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

import numpy as np  # noqa: E402

from app.recommend.config import (  # noqa: E402
    DATA_DIR,
    FIELD_ORDER,
    SVM_MODEL_PATH,
    display_name,
)


def load_dataset(path: pathlib.Path) -> tuple[np.ndarray, np.ndarray]:
    """Load (features, labels) from a CSV with FIELD_ORDER columns + 'label'."""
    rows: list[list[float]] = []
    labels: list[int] = []
    with path.open(encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        for row in reader:
            raw = (row.get("label") or "").strip()
            if not raw:
                continue  # unlabelled row -- skip
            try:
                label = int(float(raw))
            except ValueError:
                continue
            if label not in (0, 1):
                continue
            rows.append([float(row[field.lower()]) for field in FIELD_ORDER])
            labels.append(label)
    return np.asarray(rows, dtype=float), np.asarray(labels, dtype=int)


def train(features: np.ndarray, labels: np.ndarray) -> dict:
    """Fit a calibrated LinearSVC and extract per-field FtFw weights."""
    from sklearn.calibration import CalibratedClassifierCV
    from sklearn.pipeline import make_pipeline
    from sklearn.preprocessing import StandardScaler
    from sklearn.svm import LinearSVC

    # Plain pipeline gives interpretable linear coefficients (the FtFw weights).
    plain = make_pipeline(StandardScaler(), LinearSVC(C=1.0, max_iter=10000, class_weight="balanced"))
    plain.fit(features, labels)
    coefficients = plain[-1].coef_[0]
    weights = {field: float(coefficients[index]) for index, field in enumerate(FIELD_ORDER)}

    # Calibrated pipeline yields probabilities for the match score.
    folds = max(2, min(5, int(np.bincount(labels).min())))
    calibrated = CalibratedClassifierCV(
        make_pipeline(StandardScaler(), LinearSVC(C=1.0, max_iter=10000, class_weight="balanced")),
        cv=folds,
        method="sigmoid",
    )
    calibrated.fit(features, labels)

    train_accuracy = float((calibrated.predict(features) == labels).mean())
    return {
        "pipeline": calibrated,
        "weights": weights,
        "field_order": list(FIELD_ORDER),
        "train_accuracy": train_accuracy,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Train the recommender decision SVM.")
    parser.add_argument("--data", type=pathlib.Path, default=DATA_DIR / "seed_training.csv")
    parser.add_argument("--out", type=pathlib.Path, default=SVM_MODEL_PATH)
    args = parser.parse_args()

    features, labels = load_dataset(args.data)
    print(f"Loaded {len(labels)} rows ({int(labels.sum())} positive) from {args.data}")

    bundle = train(features, labels)

    import joblib

    args.out.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(bundle, args.out)

    print(f"Train accuracy: {bundle['train_accuracy']:.3f}")
    print("Field-to-Field weights (LinearSVC coefficients):")
    for field, weight in sorted(bundle["weights"].items(), key=lambda kv: kv[1], reverse=True):
        print(f"  {display_name(field):14} {weight:+.3f}")
    print(f"Saved model to {args.out}")


if __name__ == "__main__":
    main()
