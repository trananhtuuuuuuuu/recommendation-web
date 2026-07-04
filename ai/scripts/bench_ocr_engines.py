"""Head-to-head: full parse pipeline (_collect = OCR + LayoutLMv3) timed for
PaddleOCR vs Tesseract on the sample CVs. Prints per-CV wall time + avg model
confidence so we see the speed gain AND whether label quality holds.
"""
from __future__ import annotations

import time
from pathlib import Path

from app.parser import CvParser

CVS = ["data/CV_Nguyen_Van_Hien.pdf", "data/Le Thi Hong Ngoc_CV.pdf", "data/test (1).jpg"]


def run(engine: str, langs: str):
    p = CvParser(model_dir="/app/model/layoutlmv3", max_pages=1, enable_model=True,
                 ocr_languages=langs, ocr_engine=engine)
    # warm-up (model + OCR engine load) excluded from per-CV timing
    _ = p._collect(Path(CVS[0]).read_bytes(), Path(CVS[0]).name)
    print(f"\n===== engine={engine} (langs={langs}) =====")
    total = 0.0
    for rel in CVS:
        path = Path(rel)
        t = time.time()
        ents, _txt, used = p._collect(path.read_bytes(), path.name)
        dt = time.time() - t
        total += dt
        avg = sum(s.confidence for s in ents) / len(ents) if ents else 0.0
        print(f"  {path.name:<28} {dt:6.1f}s   spans={len(ents):>3}  avg_conf={avg:.3f}")
    print(f"  --> total {total:.1f}s ({total/len(CVS):.1f}s/CV)")
    return total


if __name__ == "__main__":
    t_pad = run("paddle", "eng+vie")
    t_tes = run("tesseract", "eng+vie")
    print(f"\n===== SPEEDUP =====\npaddle {t_pad:.1f}s  vs  tesseract {t_tes:.1f}s"
          f"  ->  {t_pad / max(t_tes, 0.01):.1f}x faster")
