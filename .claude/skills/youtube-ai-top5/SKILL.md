---
name: youtube-ai-top5
description: Orchestratore del team YouTube-AI. Trova su YouTube i migliori 5 video degli ultimi 7 giorni su come stare davanti a tutti usando un elemento dell'AI, coordinando gli agenti youtube-scout e youtube-analyst.
---

# Orchestratore — Top 5 YouTube "AI per essere davanti a tutti"

Parametri: `days` (default 7), `top` (default 5). `today` = data corrente.
Cartella di lavoro: `reports/<today>/`.

## Flusso
1. **Scout** → lancia l'agente `youtube-scout` con `today`, `days`, `out=reports/<today>/candidates.json`.
2. **Analista** → lancia `youtube-analyst` con `in=candidates.json`, `today`, `days`,
   `out=reports/<today>/verified.json`.
3. **Orchestrazione finale** (tu):
   - Controlla la coerenza: ogni video verificato deve avere `published` nella finestra; ricontrolla a campione
     (almeno i 5 finalisti) con `mcp__Firecrawl__firecrawl_scrape` se un dato sembra anomalo.
   - Deduplica per tema/canale: al massimo 1 video per canale nella top 5, per varietà.
   - Ordina per `score`; a parità, preferisci il valore pratico (`actionability`).
   - Se i candidati validi sono meno di `top`, rimanda lo Scout con query nuove (max 1 giro aggiuntivo).
4. Scrivi `reports/<today>/top5.md` in italiano: tabella (rank, titolo+link, canale, data, views, score),
   poi per ciascun video 3–4 righe "perché è utile / cosa insegna", la metodologia e i limiti.

## Regole anti-allucinazione
- Ogni data/numero nel report deve provenire dai metadata letti dall'Analista o dalla tua verifica.
- Le sintesi dei contenuti si basano su titolo, descrizione e capitoli, non sulla visione del video:
  dichiaralo nel report.
