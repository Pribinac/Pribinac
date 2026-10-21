#!/usr/bin/env python3
"""Pretvara tools/pitanja/*.txt u assets/pitanja/pitanja.json.

Format reda: pitanje|tačan odgovor|pogrešan 1|pogrešan 2|pogrešan 3
Prefiks imena fajla (npr. opste2.txt -> opste) je kategorija. Provjerava format, duplikate i
istovjetne odgovore; nevažeći redovi se prijavljuju i preskaču.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
IN_DIR = ROOT / "pitanja"
OUT = ROOT.parent / "assets" / "pitanja" / "pitanja.json"

KATEGORIJE = {
    "geografija": "Geografija",
    "istorija": "Istorija",
    "sport": "Sport",
    "muzika": "Muzika",
    "film": "Film i TV",
    "nauka": "Nauka",
    "opste": "Opšte znanje",
}


def norm(s: str) -> str:
    return re.sub(r"\W+", " ", s.lower()).strip()


def main() -> int:
    pitanja, vidjena, greske = [], set(), 0
    for kljuc in KATEGORIJE:
        redovi = [
            (f.name, b, r)
            for f in sorted(IN_DIR.glob(f"{kljuc}*.txt"))
            for b, r in enumerate(f.read_text(encoding="utf8").splitlines(), 1)
        ]
        for ime, broj, red in redovi:
            if not red.strip():
                continue
            dijelovi = [d.strip() for d in red.split("|")]
            mjesto = f"{ime}:{broj}"
            if len(dijelovi) != 5 or not all(dijelovi):
                print(f"GREŠKA format {mjesto}: {red[:70]}")
                greske += 1
                continue
            if re.search("[Ѐ-ӿ]", red):
                print(f"GREŠKA ćirilica {mjesto}: {red[:70]}")
                greske += 1
                continue
            if len({norm(d) for d in dijelovi[1:]}) != 4:
                print(f"GREŠKA duplirani odgovori {mjesto}: {red[:70]}")
                greske += 1
                continue
            if norm(dijelovi[0]) in vidjena:
                print(f"PRESKOČENO duplikat {mjesto}: {red[:70]}")
                continue
            vidjena.add(norm(dijelovi[0]))
            pitanja.append({
                "id": len(pitanja) + 1,
                "kategorija": kljuc,
                "pitanje": dijelovi[0],
                "tacan": dijelovi[1],
                "netacni": dijelovi[2:],
            })
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(
        {"kategorije": KATEGORIJE, "pitanja": pitanja}, ensure_ascii=False, indent=1), encoding="utf8")
    po_kat = {k: sum(p["kategorija"] == k for p in pitanja) for k in KATEGORIJE}
    print(f"Ukupno: {len(pitanja)} pitanja", po_kat)
    return 1 if greske else 0


if __name__ == "__main__":
    sys.exit(main())
