# Top 5 YouTube — "Come essere davanti a tutti con l'AI"

Finestra: **28 settembre – 5 ottobre 2026** (ultimi 7 giorni) · Generato il 5 ottobre 2026
Team: `youtube-scout` (raccolta) → `youtube-analyst` (verifica + punteggio) → orchestratore (verifica finale + ranking)

| # | Video | Canale | Pubblicato | Views* | Likes* | Durata | Score |
|---|-------|--------|-----------|-------:|-------:|-------:|------:|
| 1 | [The 6 Claude Prompts to Get You Ahead of 99% of People Using AI](https://www.youtube.com/watch?v=Zkm1mMpzmE4) | Sabrina Ramonov | 29/09/2026 | 41.076 | 1.332 | 18:38 | 8,60 |
| 2 | [Everything You Know About Skills IS OUTDATED](https://www.youtube.com/watch?v=e7TY56-yIvM) | Simon Scrapes | 01/10/2026 | 218.911 | 2.372 | 12:49 | 8,40 |
| 3 | [Google Gemini Skills Are Finally Here](https://www.youtube.com/watch?v=XQtvloPXap4) | Skill Leap AI | 01/10/2026 | 62.527 | 912 | 13:12 | 8,40 |
| 4 | [Train Your AI to Write Like a Human With Just 3 Files](https://www.youtube.com/watch?v=yDFCJzDgWhI) | Marketing Against the Grain | 29/09/2026 | 9.156 | 158 | 29:03 | 8,00 |
| 5 | [Why Smart People Get Worse Results From AI](https://www.youtube.com/watch?v=fiz2Y73vWvA) | Jeremy Utley | 01/10/2026 | 23.131 | 167 | 13:26 | 8,00 |

\* Valori letti dai metadata della pagina YouTube (`userInteractionCount`) il 5/10/2026; cambiano nel tempo.

## Perché questi 5

1. **Sabrina Ramonov — 6 prompt per Claude.** È il video che risponde più direttamente alla domanda. Presenta sei tecniche replicabili: chiedere spiegazioni semplificate, farsi porre domande di chiarimento, dare esempi di qualità, usare memoria e skill, usare l'AI come sparring partner, chiedere di "non fermarsi finché…". *Nota:* l'autrice promuove un proprio prodotto SaaS.
2. **Simon Scrapes — Le skill di Claude aggiornate.** Sette regole pratiche per costruire "skill" efficaci: indice nei file lunghi, gradi di libertà, test su più modelli, checklist, cicli di autocorrezione, portabilità. Fornisce anche un prompt di audit. È il video con più trazione della settimana tra quelli verificati. *Nota:* promuove una community a pagamento.
3. **Skill Leap AI — Gemini Skills.** Lo stesso concetto di "skill" applicato all'ecosistema Google. Mostra tre modi per crearle (da prompt, a mano, da file) e dieci skill pronte (meeting recap, proposal writer, SOP writer…). È utile a chi lavora in Google Workspace. *Nota:* la guida si scarica tramite un link HubSpot.
4. **Marketing Against the Grain — 3 file per scrivere "come un umano".** Il metodo usa tre file di contesto: `creator.md`, `audience.md` e `taste.md`. Servono a far scrivere l'AI con la propria voce, invece di produrre contenuti generici. È un vantaggio concreto per chi produce contenuti. Il formato è un podcast HubSpot.
5. **Jeremy Utley — Perché le persone capaci ottengono risultati peggiori dall'AI.** È il contributo più "di mentalità". Il problema è la delega, non l'intelligenza. La ricetta ha tre punti: fare l'onboarding dell'AI come con un collaboratore, correggere le bozze guidandola invece di riscriverle, alzare gli standard. L'autore è docente a Stanford. *Nota:* promuove il suo nuovo libro.

**Menzioni (fuori top 5):**
- [Matt Pocock's EXACT System To 10x Your Claude Skills](https://www.youtube.com/watch?v=QsU0f-547rQ), score 7,95, sovrapposto per tema al #2.
- [Claude Code Just Dropped MODS](https://www.youtube.com/watch?v=LDn7rQKIFro), score 7,45.
- In italiano: [Vuoi essere avanti al 99% delle persone? Chiedi all'AI di gestire il tuo Calendario](https://www.youtube.com/watch?v=HtJZueD4qOI) (Antonio Guadagno), score 7,45.

## Metodologia
1. **Scout:** 10 ricerche `site:youtube.com` filtrate sull'ultima settimana, in inglese e in italiano. Ha raccolto 38 candidati unici.
2. **Analista:** ha aperto la pagina YouTube di tutti i 38 candidati. Data, views e likes vengono dai metadata della pagina. 38 su 38 sono risultati dentro la finestra.
   Punteggio = 0,35·pertinenza + 0,30·applicabilità pratica + 0,20·credibilità + 0,15·trazione (views normalizzate sull'età).
3. **Orchestratore:** ha ricontrollato in modo indipendente le pagine dei 5 finalisti, verificando date e numeri. Ha ammesso al massimo un video per canale. In caso di parità ha preferito l'applicabilità pratica: è il criterio che ha separato il #4 dal #5.

Dati grezzi: [`candidates.json`](candidates.json), [`verified.json`](verified.json).

## Limiti (da leggere)
- **I video non sono stati guardati.** Sintesi e punteggi si basano su titolo, descrizione, capitoli e riassunto automatico della pagina. Pertinenza, applicabilità e credibilità sono giudizi qualitativi di un modello, non misure oggettive.
- **Copertura parziale.** 4 ricerche dello Scout sono fallite per rate limit (HTTP 429) e una ha restituito 0 risultati. Possono esistere video validi non intercettati, in particolare in lingue diverse da inglese e italiano.
- La richiesta parlava di "articoli": su YouTube si tratta di **video**.
- **Titoli che cambiano.** Il #5 mostra titoli diversi tra og:title ("Why Smart People Get Worse Results From AI") e titolo della pagina ("The Real Reason Smart People Are Bad at AI"). Probabilmente è un test A/B del titolo: è un'ipotesi, non l'ho verificata.
- **Promozioni.** Quasi tutti i canali promuovono prodotti, corsi o community. Le descrizioni lette erano troncate, quindi non posso escludere sponsorizzazioni. Il link `clickhubspot.com` nel #3 potrebbe indicare una partnership con HubSpot: non è verificato.
