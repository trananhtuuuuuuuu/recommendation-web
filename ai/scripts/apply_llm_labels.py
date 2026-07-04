"""Apply Claude (Opus 4.8) domain-judged labels to the training worksheet.

Phương án B, executed by the in-session frontier model instead of the weak local
qwen2.5:3b (which returned UNSURE on 85% of boundary pairs). Each of the 171
unique middle CVs was read (title + full skills + summary) and assigned a domain;
a pair is labelled 1 when the CV's domain fits the JD's role, else 0. Dual-fit CVs
(e.g. a .NET dev with strong T-SQL/SSIS) match both jd_01 and jd_02; cross-field
look-alikes (e.g. a Senior Data Engineer vs the Data Scientist JD) are deliberately
0 to break the JOB_TITLE-dominated weighting. One content-less CV (1067) is skipped.

Labels are "silver" (LLM-judged) -- the thesis should say so and spot-check a
human sample. Auto-labelled rows (anchor bands) are left untouched.

    python -m scripts.apply_llm_labels
    python -m scripts.train_svm --data data/label_worksheet.csv --out model/recommender_svm.joblib
"""

from __future__ import annotations

import csv
import pathlib

AI_DIR = pathlib.Path(__file__).resolve().parents[1]
WORKSHEET = AI_DIR / "data" / "label_worksheet.csv"

# --- CV -> domain (judged from title + skills + summary by Claude Opus 4.8) ------
DOMAINS: dict[str, set[int]] = {
    # .NET / C# application developers with strong DB work -> fit jd_01 AND jd_02.
    "DOTNET_DB": {1999, 2018, 1069, 273, 1117, 1102, 1109, 1071},
    # .NET / C# / ASP.NET developers (app/web) -> jd_01.
    "DOTNET": {1090, 1121, 1066, 1081, 1106, 1080, 265, 1074, 1088, 1104, 1055,
               1068, 1093, 1056, 1079, 1100, 1111, 1059, 1110, 1092, 1095, 1061,
               1116, 1073, 1082, 1083, 1063, 1086},
    # SQL / database developers, DBAs, data engineers -> jd_02.
    "DB": {1173, 100, 1177, 111, 1189, 105, 1170, 1172, 116, 115, 102, 107, 110,
           103, 104, 1185, 114, 1184, 108, 112, 119, 118, 1176, 1175, 1191, 1182,
           735, 757, 1180, 1167, 982},
    # Pure business analysts (requirements/SDLC/stakeholder) -> jd_03.
    "BA": {1026, 1002, 1029, 1022, 1049, 1025, 1038, 1016, 10, 1006, 1015, 50,
           1008, 1011, 1031, 1030, 1012, 1013, 1039, 1024, 8, 15, 1023, 1017,
           1019, 1044, 1018, 1041, 1027},
    # Business / BI analysts with data, viz & SQL -> jd_03 AND jd_05.
    "BA_DATA": {1032, 1028, 1007, 1021, 1001, 1043, 1047, 1050, 1048, 1010, 11,
                1035, 1005, 1034},
    # Data / BI analysts -> jd_05.
    "DA": {1042, 1033},
    # Data scientists / ML engineers -> jd_04 AND jd_05.
    "DS": {875, 884, 851, 1144, 1150, 1133, 1166, 1164, 1160, 1158, 1138, 1129,
           1141, 1134, 1148, 1136, 1137, 1155, 1151, 1157, 1161, 1127, 1146, 1130,
           1156, 1131, 1152, 1145, 1159, 1153, 1124, 1126, 1142, 860, 1128, 1132,
           890, 881},
    # Off-target (blockchain, SAP, devops, testing, IT support, security, ...).
    "OTHER": {0, 1, 682, 1319, 1432, 394, 384, 809, 829, 1680, 1806, 1943, 1051,
              827, 808, 1179, 544, 579, 601, 446},
}
SKIP: set[int] = {1067}  # no usable title/skills -> leave unlabelled

# --- domain -> JDs it matches ----------------------------------------------------
DOMAIN_FITS: dict[str, set[str]] = {
    "DOTNET_DB": {"jd_01", "jd_02"},
    "DOTNET": {"jd_01"},
    "DB": {"jd_02"},
    "BA": {"jd_03"},
    "BA_DATA": {"jd_03", "jd_05"},
    "DA": {"jd_05"},
    "DS": {"jd_04", "jd_05"},
    "OTHER": set(),
}


def _domain_of(cv_id: int) -> str | None:
    for domain, members in DOMAINS.items():
        if cv_id in members:
            return domain
    return None


def main() -> None:
    rows = list(csv.DictReader(WORKSHEET.open(encoding="utf-8")))
    fieldnames = list(rows[0].keys())
    if "cv_domain" not in fieldnames:
        fieldnames.insert(fieldnames.index("source") + 1, "cv_domain")

    uncovered: set[str] = set()
    changed = 0
    per_jd: dict[str, list[int]] = {}
    for row in rows:
        row.setdefault("cv_domain", "")
        if row.get("source") != "middle":
            continue
        cv_id = int(row["cv_id"])
        if cv_id in SKIP:
            row["label"], row["cv_domain"] = "", "SKIP"
            continue
        domain = _domain_of(cv_id)
        if domain is None:
            uncovered.add(row["cv_id"])
            continue
        label = "1" if row["jd_id"] in DOMAIN_FITS[domain] else "0"
        row["label"], row["cv_domain"] = label, domain
        changed += 1
        per_jd.setdefault(row["jd_id"], []).append(int(label))

    if uncovered:
        print("⚠️  UNCOVERED cv_ids (left blank, please classify):", sorted(uncovered))

    with WORKSHEET.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Labelled {changed} middle rows in {WORKSHEET.name}")
    for jd_id in sorted(per_jd):
        labels = per_jd[jd_id]
        print(f"  {jd_id}: {sum(labels):3} match / {len(labels) - sum(labels):3} no  (of {len(labels)})")
    total_pos = sum(sum(v) for v in per_jd.values())
    total = sum(len(v) for v in per_jd.values())
    print(f"  TOTAL middle: {total_pos} match / {total - total_pos} no")


if __name__ == "__main__":
    main()
