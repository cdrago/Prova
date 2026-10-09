#!/usr/bin/env python3
"""Agente meteo: raccoglie 3 previsioni orarie per stasera e restituisce,
ora per ora, il tempo piu' probabile (consenso tra i modelli).

Le 3 previsioni provengono da tre modelli meteorologici indipendenti,
scaricati tramite l'API gratuita di Open-Meteo (nessuna chiave richiesta):
  - ECMWF IFS   (Centro Europeo)
  - GFS         (NOAA, Stati Uniti)
  - ICON        (DWD, Germania)

Uso:
  python3 meteo_stasera.py --citta Roma
  python3 meteo_stasera.py --lat 45.46 --lon 9.19 --dalle 19 --alle 24
  python3 meteo_stasera.py --citta Napoli --json

Solo libreria standard Python (>= 3.9).
"""

import argparse
import json
import statistics
import sys
import urllib.parse
import urllib.request
from collections import Counter
from datetime import datetime, timedelta

FORECAST_URL = "https://api.open-meteo.com/v1/forecast"
GEOCODING_URL = "https://geocoding-api.open-meteo.com/v1/search"

# Le tre fonti: (identificativo Open-Meteo, nome leggibile)
MODELLI = [
    ("ecmwf_ifs025", "ECMWF"),
    ("gfs_seamless", "GFS"),
    ("icon_seamless", "ICON"),
]

VARIABILI = [
    "temperature_2m",
    "precipitation",
    "precipitation_probability",
    "weather_code",
    "cloud_cover",
    "wind_speed_10m",
]

# Codici WMO -> categoria. L'indice di gravita' serve a risolvere i pareggi.
CATEGORIE = [
    # (nome, gravita', codici WMO)
    ("sereno", 0, {0}),
    ("poco nuvoloso", 1, {1, 2}),
    ("nuvoloso", 2, {3}),
    ("nebbia", 3, {45, 48}),
    ("pioggerella", 4, {51, 53, 55, 56, 57}),
    ("pioggia", 5, {61, 63, 65, 66, 67, 80, 81, 82}),
    ("neve", 6, {71, 73, 75, 77, 85, 86}),
    ("temporale", 7, {95, 96, 99}),
]
GRAVITA = {nome: g for nome, g, _ in CATEGORIE}
ICONE = {
    "sereno": "☀️", "poco nuvoloso": "🌤️", "nuvoloso": "☁️", "nebbia": "🌫️",
    "pioggerella": "🌦️", "pioggia": "🌧️", "neve": "❄️", "temporale": "⛈️",
}


def categoria_da_codice(codice):
    if codice is None:
        return None
    codice = int(codice)
    for nome, _, codici in CATEGORIE:
        if codice in codici:
            return nome
    return None


def http_json(url, params):
    full = url + "?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(full, headers={"User-Agent": "meteo-stasera/1.0"})
    with urllib.request.urlopen(req, timeout=20) as resp:
        return json.load(resp)


def geocodifica(citta):
    dati = http_json(GEOCODING_URL, {"name": citta, "count": 1, "language": "it"})
    risultati = dati.get("results") or []
    if not risultati:
        raise SystemExit(f"Citta' non trovata: {citta!r}")
    r = risultati[0]
    nome = ", ".join(x for x in (r.get("name"), r.get("admin1"), r.get("country")) if x)
    return r["latitude"], r["longitude"], nome


def scarica_previsione(lat, lon, modello):
    """Scarica la previsione oraria di un singolo modello (oggi + domani)."""
    dati = http_json(FORECAST_URL, {
        "latitude": lat,
        "longitude": lon,
        "hourly": ",".join(VARIABILI),
        "models": modello,
        "timezone": "auto",
        "forecast_days": 2,
    })
    orario = dati["hourly"]

    def serie(var):
        # Con un solo modello le chiavi di norma non hanno suffisso; per
        # sicurezza accettiamo anche la forma "<variabile>_<modello>".
        valori = orario.get(var, orario.get(f"{var}_{modello}"))
        return valori if valori is not None else [None] * len(orario["time"])

    per_ora = {}
    colonne = {v: serie(v) for v in VARIABILI}
    for i, t in enumerate(orario["time"]):
        per_ora[t] = {v: colonne[v][i] for v in VARIABILI}
    return per_ora, dati.get("timezone", "")


def ore_di_stasera(dalle, alle, adesso):
    """Restituisce le chiavi orarie 'YYYY-MM-DDTHH:00' della serata.
    `alle` puo' arrivare a 24 o oltre (es. 25 = l'1 di notte)."""
    base = adesso.replace(hour=0, minute=0, second=0, microsecond=0)
    inizio = max(base + timedelta(hours=dalle), adesso.replace(minute=0, second=0, microsecond=0))
    fine = base + timedelta(hours=alle)
    ore = []
    t = inizio
    while t <= fine:
        ore.append(t.strftime("%Y-%m-%dT%H:00"))
        t += timedelta(hours=1)
    return ore


def mediana(valori):
    valori = [v for v in valori if v is not None]
    return statistics.median(valori) if valori else None


def consenso_ora(valori_modelli):
    """valori_modelli: {nome_modello: {variabile: valore}} per una singola ora."""
    categorie = {m: categoria_da_codice(v.get("weather_code")) for m, v in valori_modelli.items()}
    voti = Counter(c for c in categorie.values() if c)

    if voti:
        massimo = max(voti.values())
        candidate = [c for c, n in voti.items() if n == massimo]
        if len(candidate) == 1:
            tempo = candidate[0]
        else:
            # Pareggio (es. 3 modelli tutti diversi): si prende la categoria
            # di gravita' mediana tra quelle proposte.
            ordinate = sorted((c for c in categorie.values() if c), key=GRAVITA.get)
            tempo = ordinate[len(ordinate) // 2]
        accordo = voti[tempo]
    else:
        tempo, accordo = None, 0

    precip = [v.get("precipitation") for v in valori_modelli.values()]
    modelli_con_pioggia = sum(1 for p in precip if p is not None and p >= 0.1)
    modelli_validi_precip = sum(1 for p in precip if p is not None)
    prob_dichiarate = [v.get("precipitation_probability") for v in valori_modelli.values()]
    prob_dichiarate = [p for p in prob_dichiarate if p is not None]

    return {
        "tempo": tempo,
        "accordo": accordo,
        "n_modelli": len([c for c in categorie.values() if c]),
        "temperatura": mediana(v.get("temperature_2m") for v in valori_modelli.values()),
        "precipitazione_mm": mediana(precip),
        "modelli_con_pioggia": modelli_con_pioggia,
        "modelli_validi_precip": modelli_validi_precip,
        "prob_pioggia_media": round(statistics.mean(prob_dichiarate)) if prob_dichiarate else None,
        "vento_kmh": mediana(v.get("wind_speed_10m") for v in valori_modelli.values()),
        "nuvolosita": mediana(v.get("cloud_cover") for v in valori_modelli.values()),
        "dettaglio": {
            m: {
                "tempo": categorie[m],
                "temperatura": v.get("temperature_2m"),
                "precipitazione_mm": v.get("precipitation"),
            }
            for m, v in valori_modelli.items()
        },
    }


def calcola(previsioni, ore):
    """previsioni: {nome_modello: {ora: {variabile: valore}}}"""
    risultato = []
    for ora in ore:
        valori = {m: p[ora] for m, p in previsioni.items() if ora in p}
        if not valori:
            continue
        r = consenso_ora(valori)
        r["ora"] = ora
        risultato.append(r)
    return risultato


def fmt(v, formato, unita=""):
    return "n.d." if v is None else f"{v:{formato}}{unita}"


def stampa_tabella(risultato, luogo, fuso, fonti_ok, fonti_ko):
    print(f"\nPrevisioni per stasera — {luogo} (fuso: {fuso})")
    print(f"Fonti usate: {', '.join(fonti_ok)}" + (f"  |  non disponibili: {', '.join(fonti_ko)}" if fonti_ko else ""))
    print()
    print(f"{'Ora':<6} {'Tempo piu probabile':<24} {'Accordo':<8} {'Temp':>7} {'Pioggia':>8} {'Mod.pioggia':>12} {'Vento':>9}")
    print("-" * 80)
    for r in risultato:
        ora = r["ora"][11:16]
        tempo = f"{ICONE.get(r['tempo'], '')} {r['tempo'] or 'n.d.'}"
        accordo = f"{r['accordo']}/{r['n_modelli']}"
        pioggia = fmt(r["precipitazione_mm"], ".1f", " mm")
        mod_p = f"{r['modelli_con_pioggia']}/{r['modelli_validi_precip']}"
        print(f"{ora:<6} {tempo:<24} {accordo:<8} {fmt(r['temperatura'], '.1f', '°C'):>7} "
              f"{pioggia:>8} {mod_p:>12} {fmt(r['vento_kmh'], '.0f', ' km/h'):>9}")
    print()
    print("Legenda: 'Accordo' = quanti modelli prevedono la stessa condizione;")
    print("'Mod.pioggia' = quanti modelli prevedono almeno 0,1 mm in quell'ora.")
    print("Temperatura, pioggia e vento sono la mediana dei modelli.")
    print("Con accordo 1/3 la previsione e' incerta: i modelli non concordano.\n")


def main(argv=None):
    ap = argparse.ArgumentParser(description="Tempo piu' probabile ora per ora per stasera (consenso di 3 modelli).")
    luogo = ap.add_mutually_exclusive_group(required=True)
    luogo.add_argument("--citta", help="nome della citta' (es. Roma)")
    luogo.add_argument("--lat", type=float, help="latitudine (richiede --lon)")
    ap.add_argument("--lon", type=float, help="longitudine")
    ap.add_argument("--dalle", type=int, default=18, help="ora di inizio della serata (default 18)")
    ap.add_argument("--alle", type=int, default=23, help="ultima ora inclusa, 24+ = dopo mezzanotte (default 23)")
    ap.add_argument("--json", action="store_true", help="output in JSON")
    args = ap.parse_args(argv)

    if args.citta:
        lat, lon, nome_luogo = geocodifica(args.citta)
    else:
        if args.lon is None:
            ap.error("--lat richiede anche --lon")
        lat, lon, nome_luogo = args.lat, args.lon, f"{args.lat}, {args.lon}"

    previsioni, fonti_ok, fonti_ko, fuso = {}, [], [], ""
    for codice, nome in MODELLI:
        try:
            previsioni[nome], fuso = scarica_previsione(lat, lon, codice)
            fonti_ok.append(nome)
        except Exception as e:  # una fonte non disponibile non blocca le altre
            fonti_ko.append(f"{nome} ({e})")
    if not previsioni:
        raise SystemExit("Nessuna previsione disponibile: " + "; ".join(fonti_ko))

    # Ora locale del luogo (le ore dell'API sono nel fuso del luogo, timezone=auto).
    try:
        from zoneinfo import ZoneInfo
        adesso = datetime.now(ZoneInfo(fuso)).replace(tzinfo=None)
    except Exception:
        adesso = datetime.now()

    ore = ore_di_stasera(args.dalle, args.alle, adesso)
    risultato = calcola(previsioni, ore)

    if args.json:
        print(json.dumps({"luogo": nome_luogo, "fuso": fuso, "fonti": fonti_ok,
                          "fonti_non_disponibili": fonti_ko, "ore": risultato},
                         ensure_ascii=False, indent=2))
    else:
        if not risultato:
            print("Nessuna ora della serata rimasta nell'intervallo richiesto.")
            return
        stampa_tabella(risultato, nome_luogo, fuso, fonti_ok, fonti_ko)


if __name__ == "__main__":
    main(sys.argv[1:])
