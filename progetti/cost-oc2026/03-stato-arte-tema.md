# Stato dell'arte, policy, sovrapposizioni e gap: "Indicatori ad intervallo per l'analisi della povertà"

> Prodotto da **ricercatore-bandi** il 27/09/2026 per COST Open Call OC-2026-1 (scadenza 28/10/2026, ore 12:00 CET).
> **Limiti di metodo.** In questa sessione non erano disponibili gli strumenti Firecrawl né quelli accademici (Scite, Consensus, Scholar Gateway, alphaXiv). WebFetch è bloccato dal proxy per cost.eu, mdpi.com, wiley.com, repec.org, econstor.eu e crossref.org. Ogni dato che segue viene quindi da **WebSearch**: titoli, URL e snippet restituiti dal motore, consultati il 27/09/2026. I PDF e le pagine primarie non sono stati aperti. I DOI riportati compaiono negli URL o negli snippet restituiti. Dove manca, lo si dichiara.

> **Controllo a campione dell'orchestratore (27/09/2026, Firecrawl sulle pagine primarie).** Le voci qui sotto sono state aperte sulla pagina dell'editore o di arXiv e **corrispondono** a titolo, autori e sede:
> - Verde et al. 2024, *SJIAOS*, 10.3233/SJI-240013;
> - San Martín et al., *Annals of Operations Research*, 363(2), 1447–1477. È online dal 12/09/2025, ma il fascicolo è datato **08/2026**: citarlo come 2026;
> - Arias-Salazar et al. 2025, *Journal of Official Statistics*, 10.1177/0282423X241300751;
> - Banks, Glinnan & Komarova, arXiv:2512.07709, "Bounds on inequality with incomplete data";
> - Das, Deepawansa & Lahiri, arXiv:2510.08898, "Multidimensional Poverty Mapping for Small Areas";
> - Crescenzi & Mori, arXiv:2309.01234, "On the estimation of fuzzy poverty indices".
>
> Sono **confermati su fonte primaria** anche due dati di policy:
> - Eurostat: nel 2025 le persone AROPE erano 92,7 milioni, il 20,9% della popolazione (news del 30/04/2026);
> - la prima EU Anti-Poverty Strategy è stata adottata dalla Commissione il 6/05/2026 (sito DG EMPL; press release IP/26/946).
>
> **Tutte le altre voci non sono state ricontrollate** dall'orchestratore: prima di inserirle nelle References vanno verificate sul DOI.

---

## 1. Stato dell'arte (riferimenti verificati via WebSearch, 27/09/2026)

### 1.1 Dati ad intervallo / Symbolic Data Analysis (SDA): fondamenti

1. **Billard, L., & Diday, E. (2003).** From the statistics of data to the statistics of knowledge: Symbolic data analysis. *Journal of the American Statistical Association, 98*(462), 470–487. https://doi.org/10.1198/016214503000242
   - **Perché rilevante:** è il riferimento fondativo della SDA. Fornisce le basi formali per trattare intervalli e istogrammi come unità statistiche.
   - **Fonte:** https://www.tandfonline.com/doi/abs/10.1198/016214503000242

2. **Brito, P. (2014).** Symbolic data analysis: Another look at the interaction of data mining and statistics. *WIREs Data Mining and Knowledge Discovery, 4*(4). https://doi.org/10.1002/widm.1133
   - **Perché rilevante:** è una rassegna aggiornata dei metodi SDA (intervalli, istogrammi) e delle loro applicazioni.
   - **Da verificare:** le pagine.
   - **Fonte:** https://wires.onlinelibrary.wiley.com/doi/abs/10.1002/widm.1133

3. **Dias, S., & Brito, P. (2015).** Linear regression model with histogram-valued variables. *Statistical Analysis and Data Mining, 8*, 75–113. https://doi.org/10.1002/sam.11260
   - **Perché rilevante:** mostra come modellare distribuzioni (per esempio il reddito per regione o gruppo) come dati a istogramma, un'estensione naturale degli indicatori ad intervallo.
   - **Fonte:** https://onlinelibrary.wiley.com/doi/10.1002/sam.11260

4. **Verde, R., Batagelj, V., Brito, P., Duarte Silva, A. P., Korenjak-Černe, S., Dobša, J., & Diday, E. (2024).** New skills in symbolic data analysis for official statistics. *Statistical Journal of the IAOS, 40*(3–4). https://doi.org/10.3233/SJI-240013
   - **Perché rilevante:** è la prova diretta che la comunità SDA sta cercando di entrare nella **statistica ufficiale**. Lo snippet osserva che trattare i dati ad intervallo con tecniche classiche distorce i risultati per perdita di informazione.
   - **Fonte:** https://journals.sagepub.com/doi/full/10.3233/SJI-240013

### 1.2 Indicatori compositi ad intervallo applicati a povertà e vulnerabilità

5. **Drago, C. (2021).** The analysis and the measurement of poverty: An interval-based composite indicator approach. *Economies, 9*(4), 145. https://doi.org/10.3390/economies9040145
   - **Perché rilevante:** è il contributo più diretto sul tema. Genera molti indicatori compositi variando pesi e specificazioni e ne ricava un indicatore ad intervallo (centro, raggio, estremi). È applicato alle regioni italiane.
   - **Fonti:** https://doi.org/10.3390/economies9040145 ; https://www.econstor.eu/handle/10419/257303

6. **Drago, C., & Gatto, A. (2022).** An interval-valued composite indicator for energy efficiency and green entrepreneurship. *Business Strategy and the Environment, 31*(5), 2107–2126. https://doi.org/10.1002/bse.3010
   - **Perché rilevante:** stessa metodologia (Monte Carlo sui pesi, poi intervallo per paese) applicata in un altro dominio. Mostra che l'approccio si trasferisce ad altri contesti.
   - **Fonte:** https://ideas.repec.org/a/bla/bstrat/v31y2022i5p2107-2126.html
   - **ATTENZIONE anonimato:** vedi le Implicazioni.

7. **Saisana, M., Saltelli, A., & Tarantola, S. (2005).** Uncertainty and sensitivity analysis techniques as tools for the quality assessment of composite indicators. *Journal of the Royal Statistical Society: Series A, 168*(2), 307–323. https://doi.org/10.1111/j.1467-985X.2005.00350.x
   - **Perché rilevante:** è il riferimento standard (JRC) sull'incertezza negli indicatori compositi dovuta a pesi, normalizzazione e aggregazione. Gli indicatori ad intervallo possono essere presentati come modo per **rappresentare esplicitamente** questa incertezza invece di ridurla a un ranking puntuale.
   - **Fonte:** https://rss.onlinelibrary.wiley.com/doi/abs/10.1111/j.1467-985X.2005.00350.x

### 1.3 Approcci fuzzy e multidimensionali alla povertà (contesto)

8. **Cheli, B., & Lemmi, A. (1995).** A "totally" fuzzy and relative approach to the multidimensional analysis of poverty. *Economic Notes, 24*, 115–134.
   - **Perché rilevante:** fonda l'approccio TFR e sostituisce la dicotomia povero/non povero con un grado di appartenenza. È il concetto più vicino agli intervalli nella letteratura sulla povertà.
   - **DOI non trovato.** Le pagine risultano 115–133 in una fonte e 115–134 in un'altra, **[DA VERIFICARE]**.
   - **Fonti:** https://www.semanticscholar.org/paper/A%E2%80%99Totally%E2%80%99-Fuzzy-and-Relative-Approach-to-the-of-Cheli-Lemmi/1a5c434dfabb97e508b6bc7a33f4291fdeaf38f8 ; https://www.scirp.org/reference/referencespapers?referenceid=2785781

9. **Betti, G., Cheli, B., Lemmi, A., & Verma, V. (2006).** Multidimensional and longitudinal poverty: An integrated fuzzy approach. In A. Lemmi & G. Betti (Eds.), *Fuzzy set approach to multidimensional poverty measurement* (pp. 115–137). Springer. https://doi.org/10.1007/978-0-387-34251-1_7
   - **Perché rilevante:** propone l'approccio IFR (Integrated Fuzzy and Relative), che è una base per le misure "fuzzy" su dati EU-SILC.
   - **Fonte:** https://link.springer.com/chapter/10.1007/978-0-387-34251-1_7

10. **Betti, G., & Verma, V. (2008).** Fuzzy measures of the incidence of relative poverty and deprivation: A multi-dimensional perspective. *Statistical Methods & Applications, 17*, 225–250. https://doi.org/10.1007/s10260-007-0062-8
    - **Perché rilevante:** formalizza le misure fuzzy monetarie e di deprivazione.
    - **Fonte:** https://link.springer.com/article/10.1007/s10260-007-0062-8

11. **Handastya, N., & Betti, G. (2023).** The 'double fuzzy set' approach to multidimensional poverty measurement: With a focus on the health dimension. *Social Indicators Research, 166*, 201–217. https://doi.org/10.1007/s11205-023-03065-1
    - **Perché rilevante:** è uno sviluppo recente dell'approccio fuzzy. Indica che il filone è ancora attivo.
    - **Fonte:** https://link.springer.com/article/10.1007/s11205-023-03065-1

12. **Crescenzi, F., & Mori, L. (2023).** On the estimation of fuzzy poverty indices. *arXiv:2309.01234*. https://arxiv.org/abs/2309.01234
    - **Perché rilevante:** studia l'errore quadratico medio delle misure fuzzy e la loro robustezza alle funzioni di appartenenza, cioè l'incertezza delle misure fuzzy stesse.
    - **Versione pubblicata:** risulta un articolo correlato in *Journal of Statistical Computation and Simulation, 95*(8) (2025), https://doi.org/10.1080/00949655.2025.2465794. Titolo esteso e autori della versione a stampa **[DA VERIFICARE]**.
    - **Software:** esiste il pacchetto R FuzzyPovertyR (https://archive.linux.duke.edu/cran/web/packages/FuzzyPovertyR/index.html).

13. **Alkire, S., & Foster, J. (2011).** Counting and multidimensional poverty measurement. *Journal of Public Economics, 95*(7–8), 476–487. https://doi.org/10.1016/j.jpubeco.2010.11.006
    - **Perché rilevante:** è la base del metodo Alkire-Foster e del Global MPI. Ha doppio cutoff (per dimensione e trasversale): la scelta dei cutoff e dei pesi è una fonte di incertezza "a intervallo".
    - **Fonti:** https://www.sciencedirect.com/science/article/abs/pii/S0047272710001660 ; https://econpapers.repec.org/RePEc:eee:pubeco:v:95:y:2011:i:7-8:p:476-487

14. **Suppa, N., & Kanagaratnam, U. (2025).** The global Multidimensional Poverty Index: Harmonised level estimates and their changes over time. *Scientific Data, 12*, 153. https://doi.org/10.1038/s41597-024-04269-x
    - **Perché rilevante:** documenta il dataset MPI armonizzato (88 paesi, 882 regioni subnazionali). Include errori standard e intervalli di confidenza, quindi l'incertezza campionaria già considerata a livello ufficiale.
    - **Fonte:** https://www.nature.com/articles/s41597-024-04269-x

### 1.4 Incertezza, bounds e intervalli nella misura della povertà e disuguaglianza

15. **Atkinson, A. B. (1987).** On the measurement of poverty. *Econometrica, 55*(4), 749–764.
    - **Perché rilevante:** introduce gli ordinamenti di povertà robusti su un **intervallo di linee di povertà ammissibili** (welfare dominance). È il precedente teorico del ragionare "a intervallo" sulla soglia.
    - **DOI non trovato.**
    - **Fonte:** https://econpapers.repec.org/RePEc:ecm:emetrp:v:55:y:1987:i:4:p:749-64

16. **Nicoletti, C., Peracchi, F., & Foliano, F. (2011).** Estimating income poverty in the presence of missing data and measurement error. *Journal of Business & Economic Statistics, 29*(1), 61–72. https://doi.org/10.1198/jbes.2010.07185
    - **Perché rilevante:** calcola bounds superiori e inferiori (identificazione parziale) sul tasso di povertà in 10 paesi europei (ECHP). Il tasso di povertà diventa di fatto un intervallo.
    - **Da verificare:** l'ordine degli autori (lo snippet li elenca come Nicoletti, Peracchi, Foliano).
    - **Fonte:** https://www.tandfonline.com/doi/abs/10.1198/jbes.2010.07185

17. **Banks, J., Glinnan, T., & Komarova, T. (2025, rev. 2026).** Bounds on inequality with incomplete data. *arXiv:2512.07709*. https://arxiv.org/abs/2512.07709
    - **Perché rilevante:** propone identificazione e inferenza *sharp* per indici di disuguaglianza (Gini, rapporti tra quantili) con dati **interval-valued** e raggruppati. È il ponte più recente tra econometria dei bounds e dati ad intervallo.
    - **Fonte:** https://arxiv.org/abs/2512.07709

18. **San Martín, E., Perticara, M., Varas, I. M., & Alarcón-Bustamante, E. (2025).** Income inequality under partial observability: What can we learn from incomplete survey data? *Annals of Operations Research*. https://doi.org/10.1007/s10479-025-06825-z
    - **Perché rilevante:** con la non risposta, il Gini (CASEN, Cile) risulta un intervallo da 0,379 a 0,415, un'ampiezza sufficiente a invertire valutazioni di policy.
    - **Da verificare:** volume e pagine.
    - **Fonte:** https://link.springer.com/article/10.1007/s10479-025-06825-z

19. **Goedemé, T. (2013).** How much confidence can we have in EU-SILC? Complex sample designs and the standard error of the Europe 2020 poverty indicators. *Social Indicators Research, 110*(1), 89–110. https://doi.org/10.1007/s11205-011-9918-2
    - **Perché rilevante:** mostra che gli indicatori UE di povertà da EU-SILC hanno errori campionari non trascurabili e spesso ignorati. È la base empirica per chiedere di comunicare **intervalli** anziché punti.
    - **Fonte:** https://link.springer.com/article/10.1007/s11205-011-9918-2

20. **Molina, I., & Rao, J. N. K. (2010).** Small area estimation of poverty indicators. *Canadian Journal of Statistics, 38*, 369–385. https://doi.org/10.1002/cjs.10051
    - **Perché rilevante:** è il riferimento SAE (Empirical Best, MSE via bootstrap) per indicatori di povertà a livello locale, dove l'incertezza è massima.
    - **Fonte:** https://onlinelibrary.wiley.com/doi/abs/10.1002/cjs.10051

21. **Arias-Salazar, A., Gutiérrez, A., Guerrero-Gómez, S., Mancero, X., Rojas-Perilla, N., & Zhang, H. (2025).** Small area estimation for composite indicators: The case of multidimensional poverty incidence. *Journal of Official Statistics*. https://doi.org/10.1177/0282423X241300751
    - **Perché rilevante:** porta la SAE sugli indicatori compositi multidimensionali. Il preprint è arXiv:2304.03901.
    - **Da verificare:** il nome della rivista, dedotto dal prefisso DOI SAGE 0282423X, e volume/pagine.
    - **Fonti:** https://journals.sagepub.com/doi/10.1177/0282423X241300751 ; https://arxiv.org/abs/2304.03901

22. **Das, S., Deepawansa, D., & Lahiri, P. (2025).** Multidimensional poverty mapping for small areas. *arXiv:2510.08898*. https://arxiv.org/abs/2510.08898
    - **Perché rilevante:** secondo gli autori, stimare nelle small area il contributo delle singole dimensioni alla povertà multidimensionale è un problema "grossly ignored" nella letteratura SAE. È un gap citabile.
    - **Fonte:** https://arxiv.org/abs/2510.08898

**Da non usare come riferimento principale.** Crocetti, G. (2026), *Global poverty beyond the official line: A bounded estimate of material insufficiency*, arXiv:2609.16203 (https://arxiv.org/abs/2609.16203). È un preprint di settembre 2026, non revisionato, che propone una stima "bounded" della povertà globale al variare delle soglie. Utile solo come segnale di attualità del tema.

---

## 2. Policy e stakeholder (fonti ufficiali, WebSearch 27/09/2026)

- **AROPE (Eurostat).**
  - **Definizione:** somma delle persone a rischio di povertà, in grave deprivazione materiale e sociale o in famiglie a intensità lavorativa molto bassa, ciascuna contata una sola volta.
  - **Revisione 2021:** grave deprivazione materiale e sociale = mancanza di almeno **7 voci su 13**. È l'indicatore principale del target UE 2030.
  - **Fonte:** https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Glossary:At_risk_of_poverty_or_social_exclusion_(AROPE)
- **Dato più recente.**
  - Nel **2025**, **92,7 milioni** di persone nell'UE (**20,9%**) erano AROPE, contro 93,3 milioni (21,0%) nel 2024.
  - **Valori massimi:** Bulgaria 29,0%, Grecia 27,5%, Romania 27,4%, tutti paesi ITC.
  - **Fonte:** https://ec.europa.eu/eurostat/web/products-eurostat-news/w/ddn-20260430-1
- **European Pillar of Social Rights Action Plan (2021).** Obiettivo: ridurre di almeno **15 milioni** le persone AROPE entro il 2030, di cui almeno **5 milioni di bambini**.
  - **Fonti:** https://op.europa.eu/webpub/empl/european-pillar-of-social-rights/en/ ; https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Glossary%3AThe_European_Pillar_of_Social_Rights_Action_Plan_%28EU_2030_targets%29
- **Prima EU Anti-Poverty Strategy.**
  - **Adozione:** 6 maggio 2026, insieme a una comunicazione sulla European Child Guarantee e a una proposta di raccomandazione sull'esclusione abitativa.
  - **Ambizione:** eradicare la povertà nell'UE entro il **2050**.
  - **Riferimento del documento:** risulta COM/2026/0538, **[DA VERIFICARE]** che sia proprio la Strategia.
  - **Fonti:** https://employment-social-affairs.ec.europa.eu/policies-and-activities/social-protection-social-inclusion/addressing-poverty-and-supporting-social-inclusion/eu-anti-poverty-strategy_en ; http://www.ipex.eu/IPEXL-WEB/dossier/document/COM20260538.do
- **EU-SILC e precisione.**
  - Il Regolamento (UE) 2019/1700 fissa requisiti di precisione nazionali e NUTS2 per AROPE.
  - EU-SILC punta a una precisione di circa 1 punto percentuale su AROPE.
  - La varianza è stimata con linearizzazione e approccio "ultimate cluster".
  - **Fonti:** https://ec.europa.eu/eurostat/cache/metadata/en/ilc_sieusilc.htm ; https://circabc.europa.eu/sd/a/8db0fafd-a762-4427-bd03-ec0ad72e2914/Methodological%20guidelines%202022%20operation%20v7.pdf . I dettagli sui requisiti di precisione vengono dagli snippet, **[DA VERIFICARE]** sul testo.
- **SDG 1.**
  - **Indicatore 1.2.1:** quota di popolazione sotto la linea di povertà nazionale.
  - **Indicatore 1.2.2:** povertà "in tutte le sue dimensioni" secondo definizioni nazionali.
  - **Fonti:** https://unstats.un.org/sdgs/metadata/files/Metadata-01-02-01.pdf ; https://unstats.un.org/sdgs/metadata/?Goal=1
- **World Bank, Poverty and Inequality Platform (PIP).**
  - A giugno 2025 le linee internazionali sono state rivalutate da 2,15 $ a **3,00 $** (2021 PPP), da 3,65 $ a 4,20 $ e da 6,85 $ a 8,30 $.
  - Il cambio di soglia sposta in modo sostanziale le stime: un argomento a favore degli intervalli.
  - **Fonti:** https://pip.worldbank.org/ ; https://documents1.worldbank.org/curated/en/099510306052516849/pdf/IDU-eb272b02-ecd1-4633-9e37-9297e20a711c.pdf ; https://ourworldindata.org/new-international-poverty-line-3-dollars-per-day
- **UNDP/OPHI Global MPI.**
  - **Fonti:** https://hdr.undp.org/content/2025-global-multidimensional-poverty-index-mpi ; https://ophi.org.uk/global-mpi
  - **Scoping study UNDP** sulla povertà multidimensionale in Europa orientale e Asia centrale (area rilevante per i paesi ITC dei Balcani, del Caucaso, per Moldova e Ucraina): https://www.undp.org/eurasia/publications/measuring-multidimensional-poverty-eastern-europe-and-central-asia-scoping-study
- **OECD.** *How's Life? 2024*: oltre 80 indicatori, 11 dimensioni del benessere corrente, con focus sulle disuguaglianze.
  - **Fonte:** https://www.oecd.org/en/publications/how-s-life-2024_90ba854a-en.html
- **JRC, Competence Centre on Composite Indicators and Scoreboards (JRC-COIN).**
  - Fa audit statistici degli indicatori compositi e gestisce l'**EU Multidimensional Inequality Monitoring Framework**.
  - È lo stakeholder metodologico naturale; il suo 10° anniversario è previsto a novembre 2026.
  - **Fonti:** https://knowledge4policy.ec.europa.eu/composite-indicators-cc-coin_en ; https://joint-research-centre.ec.europa.eu/events/competence-centre-composite-indicators-and-scoreboards-cc-coin-10-year-anniversary-2026-11-17_en
- **ISTAT.**
  - Nel 2024 erano in povertà assoluta 2,2 milioni di famiglie (8,4%) e 5,7 milioni di individui (9,8%).
  - **Fonti:** https://www.istat.it/wp-content/uploads/2025/10/La-poverta-in-italia-_-Anno-2024.pdf ; scheda di qualità https://www.istat.it/scheda-qualita/analisi-della-poverta-assoluta/
- **Società civile.** EAPN (European Anti-Poverty Network) e la Coalition on the EU Anti-Poverty Strategy: https://www.eapn.eu/coalition-on-the-eu-anti-poverty-strategy/

---

## 3. Sovrapposizioni con COST Action esistenti

**Limite della ricerca.** Le pagine cost.eu non erano leggibili: WebFetch è bloccato e Firecrawl non era disponibile. Titoli e date vengono da snippet di ricerca e da siti delle Action o delle università. Il browse completo di cost.eu (CA24 e CA25) **non è stato fatto**.

| Codice | Titolo | Anni | URL | Differenza dalla nostra idea |
|---|---|---|---|---|
| CA16232 (ENGAGER) | European Energy Poverty: Agenda Co-Creation and Knowledge Innovation | 07/11/2017 – 06/05/2022 (esteso) | https://www.cost.eu/actions/CA16232/ | Tratta un'unica dimensione (energia), con un taglio di co-creazione di policy. Nessun focus su metodi statistici ad intervallo. |
| CA15218 (MEHO) | Measuring homelessness in Europe | 2016 – 2020/21 **[fonti discordanti]** | https://www.cost.eu/actions/CA15218/ | È un precedente utile: un'Action sulla **misurazione** di un fenomeno di esclusione. Riguarda però homelessness e non usa dati ad intervallo né SDA. |
| CA18213 (RNYN) | Rural NEET Youth Network: Modeling the risks underlying rural NEETs social exclusion | 14/10/2019 – 13/10/2023 | https://www.cost.eu/actions/CA18213/ | Si occupa di esclusione sociale giovanile rurale, con modelli di rischio e un osservatorio. Non tratta la misurazione generale della povertà. |
| CA22116 (GREATLEAP) | The Great Leap. Multidisciplinary approaches to health inequalities, 1800–2022 | 19/09/2023 – 18/09/2027 | https://www.cost.eu/actions/CA22116/ | Disuguaglianze di salute in chiave storica. Nessuna sovrapposizione metodologica. |
| CA21107 | Work inequalities in later life redefined by digitalisation (DIGINET) | **[date DA VERIFICARE]** | (PDF della call STSM su cost.eu) https://www.cost.eu/uploads/2023/01/DIGINET-1st-Call-for-Application_STSM-2023.pdf | Disuguaglianze lavorative in età avanzata. Tema diverso. |
| CA21118 (P-WILL) | Platform Work Inclusion Living Lab | **[DA VERIFICARE]** | https://www.cost.eu/actions/CA21118/ | Lavoro su piattaforma e disuguaglianze socioeconomiche. Non riguarda la misurazione. |
| CA15109 (COSTNET) | European Cooperation for Statistics of Network Data Science | 11/05/2016 – 10/05/2020 | https://www.cost.eu/actions/CA15109/ | È un precedente di Action **statistico-metodologica** (network data), utile come modello di rete statistica. Tema diverso. |

**Esito sulla ricerca di un'Action SDA / dati ad intervallo.** Nessuna COST Action su symbolic data analysis o dati interval-valued è emersa dalle ricerche.

**Esito sulla ricerca "beyond GDP" / benessere / composite indicators.** Nessuna Action trovata. Questa è un'assenza di risultati nel motore di ricerca, **non** una prova che l'Action non esista.

**Action nuove, non controllate:**
- CA24, approvate a maggio 2025: booklet https://www.cost.eu/uploads/2025/05/oc-2024-1-Approved-Actions-Booklet.pdf
- CA25, approvate il 19/05/2026: booklet https://www.cost.eu/uploads/2026/05/COST-OC-2025-1-approved-Actions-booklet.pdf

**RISOLTO dall'orchestratore (27/09/2026, lettura dei PDF via Firecrawl):**
- nel booklet CA25 la stringa "social exclusion, income distribution, poverty" **non è una keyword di un'Action**;
- è l'etichetta del sotto-campo di expertise OECD **"Sociology: Social structure, inequalities, social mobility, social exclusion, income distribution, poverty"**, indicata tra le Areas of Expertise di CA25107 (mental healthcare): **nessuna sovrapposizione**;
- una query sui due booklet (CA24 e CA25) non ha trovato Action su povertà, dati ad intervallo o statistica ufficiale. Le più vicine per tema sociale sono CA25103, CA25176 (child well-being), CA24150 e CA24170.
- La ricerca è stata fatta con estrazione automatica su PDF: è attendibile ma non è una lettura integrale.

(Nota storica) Uno snippet indicava che nel booklet CA25 compaiono keyword come "social exclusion, income distribution, poverty". Non è stato possibile identificare a quale Action si riferiscano, quindi **[DA VERIFICARE con urgenza]**. Nota: il motore di ricerca aveva attribuito erroneamente queste keyword a CA24107, che invece è SAFE-ICU (terapia intensiva).

**Citabilità delle Action nel testo.**
- Le regole in `01-regole-bando.md` vietano di nominare progetti o reti **dei proponenti** e i "CAxxxxx" riconducibili a loro. Non risulta un divieto generale di citare Action di terzi.
- Resta però il divieto generale di link e materiale esterno.
- **Raccomandazione:** citare eventuali Action solo per contenuto, senza link, e solo se nessun proponente vi ha partecipato. Il dettaglio del testo dei [PG] §2.4 su questo punto è **[DA VERIFICARE]**.

---

## 4. Gap di ricerca e di coordinamento documentati

1. **Incertezza non comunicata negli indicatori ufficiali di povertà.** Gli indicatori EU-SILC hanno errori campionari rilevanti e spesso ignorati (Goedemé, 2013). EU-SILC fissa requisiti di precisione di circa 1 p.p. su AROPE, ma la comunicazione pubblica resta puntuale: il comunicato Eurostat 2026 riporta 20,9% senza intervallo nello snippet. Manca un linguaggio condiviso per presentare gli indicatori come intervalli.
2. **Fonti multiple di incertezza trattate in filoni separati:**
   - errore campionario (Goedemé, 2013);
   - non risposta ed errore di misura, tramite bounds (Nicoletti et al., 2011; San Martín et al., 2025; Banks et al., 2025);
   - scelte normative su soglie, pesi e cutoff (Atkinson, 1987; Alkire & Foster, 2011; Saisana et al., 2005);
   - vaghezza concettuale, con i fuzzy (Cheli & Lemmi, 1995; Betti & Verma, 2008).

   Nessuna fonte trovata integra questi livelli in un unico oggetto ad intervallo. È un gap di **coordinamento tra comunità** (econometria dei bounds, SDA, fuzzy, SAE, indicatori compositi) che giustifica una rete.
3. **La SDA non è ancora entrata nella statistica ufficiale.** Verde et al. (2024) lo presentano come un obiettivo in costruzione ("pilot techniques"). Servono casi d'uso sulla povertà e un dialogo con gli istituti nazionali di statistica (INS) ed Eurostat.
4. **Small area e multidimensionalità.** La stima dei contributi dimensionali nelle small area è "grossly ignored" (Das et al., 2025). La SAE per indicatori compositi è recente (Arias-Salazar et al., 2025). L'incertezza è massima proprio al livello locale e regionale su cui si decide la policy.
5. **Sensibilità alle soglie.** La revisione delle linee World Bank del 2025 ha spostato in modo marcato le stime globali. Secondo gli snippet OWID/UNSD, gli individui in povertà estrema sono passati da 677 a 808 milioni. Questo dimostra che una stima puntuale legata a una sola soglia è fragile: un argomento diretto per indicatori a banda o intervallo.
6. **Squilibrio geografico.** I tassi AROPE più alti si registrano in paesi ITC (Bulgaria, Grecia, Romania). L'UNDP ha avviato studi sulla povertà multidimensionale in Europa orientale e Asia centrale. La capacità metodologica è concentrata altrove, il che motiva il capacity building nei paesi ITC richiesto dal bando.

---

## Non trovato / da verificare

- **Strumenti:** Firecrawl e gli strumenti accademici (Scite, Consensus, ecc.) non erano disponibili in questa sessione. Tutto proviene da WebSearch; **nessun PDF è stato aperto**.
- **Browse di cost.eu:** non eseguito. Da verificare le Action CA24 e CA25 su povertà, disuguaglianza e statistica, in particolare l'Action del booklet OC-2025-1 con keyword "poverty / income distribution".
- **Date da confermare:**
  - CA15218: 2016–2020 oppure 2016–2021;
  - CA21107, CA21118: date mancanti.
- **DOI mancanti:** Cheli & Lemmi (1995), di cui vanno verificate anche le pagine; Atkinson (1987).
- **Dettagli bibliografici da confermare:**
  - Brito (2014): pagine;
  - San Martín et al. (2025): volume e pagine;
  - Arias-Salazar et al. (2025): rivista (JOS?), volume e pagine;
  - Crescenzi & Mori: versione JSCS 2025;
  - Nicoletti et al. (2011): ordine degli autori.
- **Anti-Poverty Strategy:** il numero COM/2026/0538 va confermato.
- **EU-SILC:** i requisiti di precisione del Reg. 2019/1700 sono da verificare sul testo.
- **Altro lavoro ad intervallo:** "Interval-based symbolic composite indicators… economic vulnerability in Italy" (2023) risulta solo su ResearchGate. Sede di pubblicazione non verificata, quindi escluso.
- **Citazione di Action di terzi:** eventuali divieti espliciti nelle guidelines [PG] non sono stati riletti in questa sessione.

## Implicazioni per la stesura

1. **Anonimato (critico).**
   - I contributi più vicini al tema (Drago 2021; Drago & Gatto 2022) sembrano riconducibili al proponente, a giudicare dall'email dell'utente (c.drago). Le auto-citazioni sono ammesse "senza evidenziarle".
   - In un campo di nicchia, però, citare più lavori dello stesso autore sugli "interval-based composite indicators" rende il proponente identificabile.
   - **Consiglio:** al massimo 1 riferimento, affiancato ad altri (Saisana et al., 2005; Billard & Diday, 2003), con formulazione impersonale ("interval-based composite indicators have been proposed…").
2. **Main challenge.** Presentarla come "la povertà viene comunicata con numeri puntuali, ma è misurata con incertezza su più livelli (campionaria, non risposta, soglie e pesi, vaghezza concettuale)". I dati ad intervallo e simbolici sono il linguaggio unificante. Ancorarla ad AROPE e al target EPSR 2030, alla Anti-Poverty Strategy del 6/5/2026 e a SDG 1.2.
3. **Rationale per il networking.** Le comunità da far dialogare sono separate:
   - SDA (forte in Portogallo, Slovenia, Croazia, Francia e Italia, secondo gli autori di Verde et al., 2024);
   - fuzzy poverty (scuola italiana);
   - econometria dei bounds (Regno Unito);
   - SAE;
   - JRC-COIN;
   - INS ed Eurostat.

   Nessuna COST Action trovata copre questa intersezione.
4. **Capacity building ITC.** Usare i tassi AROPE più alti (BG, EL, RO) e gli studi UNDP sull'Europa orientale per motivare la partecipazione e le Training Schools nei paesi ITC.
5. **Stakeholder.** Eurostat (EU-SILC), JRC-COIN (audit degli indicatori compositi, MIMF), INS (ISTAT e omologhi), World Bank PIP, OPHI/UNDP, OECD WISE ed EAPN. Nel testo **nessun link**: citarli solo per nome.
6. **References.** Il limite è di 500 parole. Selezionare circa 12–15 voci tra quelle sopra, dando priorità a quelle con DOI verificato: 1, 4, 5 (una sola auto-citazione), 7, 8, 13, 14, 16, 17, 19, 20, 21.
7. **Verifica prima dell'invio.** Controllare i booklet CA24 e CA25 per escludere un'Action approvata nel 2026 su povertà e misurazione. Se esiste, differenziarsi esplicitamente sul contributo metodologico (dati ad intervallo e simbolici, integrazione delle fonti di incertezza).
