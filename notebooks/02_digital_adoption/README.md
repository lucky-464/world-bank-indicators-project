# Digital Adoption, Productivity, and Female Labour-Force Participation

A cross-country panel analysis using World Bank WDI data.

---

## 1. Question

Does digital adoption raise labour productivity and female labour-force participation across countries? And does the male-female internet gender gap weaken that effect?

The CDT lists "Inclusion and Bridging Digital Divide" and "Effects of digitization on jobs, incomes, and wages" among its research themes. This project tests both claims on a panel of 86 countries from 2011 to 2024.

---

## 2. Findings

1. **Productivity.** A positive within-country association between lagged internet adoption and productivity. Coefficient 55.6 USD per percentage point (p ≈ 0.08-0.10). Significant at the 10% level, not at 5%.

2. **Female LFP.** No detectable association. Coefficient −0.0175 (p ≈ 0.41). Null.

3. **Interaction.** No detectable interaction between internet adoption and the gender gap on female LFP. Coefficient −0.0021 (p ≈ 0.55). Null.

**Comparison to pooled OLS.** Pooled OLS on productivity gives −57.6. Two-way fixed effects gives +55.6. The sign flips. This is the bias that country fixed effects correct. The pooled estimator was picking up an unobserved country trait that drives both internet use and productivity.

---

## 3. Data

**Source:** World Bank World Development Indicators, pulled via the World Bank API.

**Indicators:** 20 shortlisted from 1,499 WDI series. Selection procedure:

- Keyword matching over indicator names and definitions, 56 candidates surfaced
- Filtered to codes that matched the target construct, unit, and population breakdown
- 20 kept, 36 dropped with documented reasons
- Full log: [`shortlist_decisions.csv`](shortlist_decisions.csv)

**Coverage audit:**

| | Observations | Countries | Years |
|---|---|---|---|
| Raw long panel (all 20 indicators) | 92,105 | 217 | 1990-2025 |
| Gender-split internet use | 1,363 / 1,362 | 137 | 2000-2025 |
| Account ownership (Findex) | 705 / 679 | 161 / 159 | 6 survey years only |
| Final analysis window | 761 | 86 | 2011-2024 |

The binding constraint is gender-split internet use. Only ~70-90 countries report in any given year. Findex survey years are 2011, 2014, 2017, 2021, 2024.

**Window choice:** 2011-2024. Widest window that keeps all controls non-missing for at least 100 countries. See `coverage_by_indicator.csv` for per-indicator counts.

**Sample filter:** Countries with fewer than 3 years of complete data were dropped before lag construction. This removes 21 countries (13 with 1 year, 8 with 2 years). Rationale: countries with 1-2 observations contribute almost nothing to within-country identification.

---

## 4. Method

**Specification:**

Outcome_it = β · IT_lag1_it + γ · X_it + α_i + δ_t + ε_it


- `Outcome`: productivity (`SL.GDP.PCAP.EM.KD`) or female LFP (`SL.TLF.CACT.FE.ZS`)
- `IT_lag1`: internet penetration, lagged one year
- `X`: seven controls — GDP per capita (PPP constant), tertiary enrolment, trade share, urbanisation, electricity access, government effectiveness, regulatory quality
- `α_i`: country fixed effects
- `δ_t`: year fixed effects
- Errors clustered by country

**Why fixed effects:**

Country FE absorb all time-invariant country characteristics — geography, legal origin, colonial history, institutional structure. Year FE absorb global shocks common across countries. The coefficient on `IT_lag1` is identified from within-country deviations from a country's own internet trend.

**Why lag:**

Digital adoption does not affect productivity or LFP instantly. Workers learn, firms reorganise. A one-year lag allows for adjustment and partially addresses reverse causality (current productivity cannot cause last year's internet use).

**Third specification:**

Outcome_it = β · IT_lag1 + γ · gender_gap + λ · (IT_lag1 × gender_gap) + X_it γ + α_i + δ_t + ε_it

where `gender_gap = male internet use − female internet use`.

**Three-language replication:**

Same specification estimated in Python (`linearmodels.PanelOLS`), R (`fixest::feols`), and Stata (`reghdfe`). Coefficients reconciled.

---

## 5. Results

### Coefficient on `IT_lag1` across languages

| Specification | Python | R | Stata |
|---|---|---|---|
| Productivity FE | 55.639 | 55.640 | 55.640 |
| Female LFP FE | −0.0175 | −0.0175 | −0.0175 |
| Interaction (`IT_lag1_x_gap`) | −0.0021 | −0.0021 | −0.0021 |

Coefficients match to three decimals. Full table: [`task3_reconciliation.csv`](task3_reconciliation.csv).

### Standard errors

| Specification | Python | R | Stata |
|---|---|---|---|
| Productivity FE | 33.29 | 31.48 | 31.48 |
| Female LFP FE | 0.0215 | 0.0203 | 0.0203 |
| Interaction | 0.0035 | 0.0033 | 0.0034 |

R and Stata match exactly. Python's `linearmodels` differs slightly because of a finite-sample correction factor for clustered SEs. The difference is expected, not a bug. The point estimates are what matter for reconciliation.

### Pooled OLS vs FE

| Outcome | Pooled OLS | FE | Sign flip |
|---|---|---|---|
| Productivity | −57.62 (69.88) | 55.64 (33.29) | Yes |
| Female LFP | 0.059 (0.064) | −0.0175 (0.021) | Yes |

Both outcomes show the sign flipping between pooled and FE. On productivity, the pooled estimate was negative while FE is positive. This is exactly what Gujarati's airline example predicts when the country-specific unobservable is correlated with the regressor.

### Fit statistics

| Spec | Within R² | Poolability F-test |
|---|---|---|
| Productivity | 0.896 | 244.6 (p = 0.000) |
| Female LFP | 0.053 | 243.5 (p = 0.000) |
| Interaction | 0.064 | 203.5 (p = 0.000) |

Poolability test rejects the pooled model in every specification. Country and year effects matter.

---

## 6. Interpretation

**Productivity.** The coefficient is 55.6 USD per percentage point of lagged internet penetration. On a base of ~40,000 USD per worker, a 10-point rise in internet use is associated with a ~1.4% productivity gain. The 10% significance level means the estimate is imprecise. Cannot rule out zero at conventional levels.

**Female LFP.** No detectable association. Within-country R² is 0.053. The regressors explain almost none of the variation. Female labour supply within countries is driven by things not in this model.

**Interaction.** No detectable interaction. Either the gender gap does not moderate the effect, or the sample is too small and the measure too coarse to detect it.

**Pooled vs FE.** The sign flip is the cleanest evidence that pooled OLS is biased here. Country institutions and income levels correlate with internet use and productivity. Pooled OLS attributed that correlation to internet, and got the wrong sign.

---

## 7. Limitations

**Reverse causality.** Richer, better-governed countries adopt the internet faster. Lagging helps but does not eliminate the problem. A proper instrument (e.g., Czernich et al.'s legacy telephone infrastructure) is needed for causal claims. We do not attempt that here.

**Measurement.** Country-level internet penetration is a coarse proxy. It cannot distinguish household from business use, quality from quantity, fixed from mobile. Measurement error in the regressor biases the coefficient toward zero.

**Fixed effects absorb time-invariant characteristics.** Region, legal origin, colonial history, geography are controlled for but not identified. Any variable constant within a country cannot be estimated with country FE.

**Short-run deviation effect.** Country FE absorb within-country trends. The coefficient is the effect of deviations from a country's own internet trend, not the effect of the long-run trend itself. This narrows the claim we can make.

**Unbalanced panel.** Coverage varies by country and year. Countries drop in and out. Composition changes year to year. We dropped countries with fewer than 3 years to keep within-variation meaningful, but the panel is still not balanced.

**Female LFP null.** The null could be real, or it could reflect the coarse annual lag, unmeasured drivers (childcare policy, social norms, sectoral composition), or the limitations of country-level internet measurement.

**Aggregation.** The unit is the country. Results describe country-level associations, not household-level behaviour. Aggregate associations can differ from micro-level ones.

---

## 8. Reproducibility

**Files in this chapter folder:**

| File | Purpose |
|---|---|
| `DigitalAdoption.ipynb` | Data pull, coverage audit, NLP shortlist, panel build, Python models |
| `task4_simulation.ipynb` | Monte Carlo showing pooled OLS bias |
| `task3_models.R` | R replication (fixest) |
| `task3_models.do` | Stata replication (reghdfe) |
| `panel_task2.csv` | Clean analysis panel — 86 countries, 761 observations |
| `panel_long.csv` | Raw long-format panel (92,105 observations) |
| `coverage_by_indicator.csv` | Coverage audit table |
| `shortlist_decisions.csv` | 56 shortlist candidates, keep/drop with reasons |
| `task3_reconciliation.csv` | Python-R-Stata coefficient comparison |
| `countries_real.json` | 217 real countries (aggregates excluded) |
| `indicators_catalog.csv` | Full WDI indicator catalog |

**To reproduce:**

1. Run `DigitalAdoption.ipynb` top to bottom. Pulls all data via API. No manual downloads.
2. Run `task3_models.R` in RStudio.
3. Run `task3_models.do` in Stata.
4. Run `task4_simulation.ipynb`.

All outputs are regenerated.

**Dependencies:**
- Python: `pandas`, `numpy`, `requests`, `linearmodels`, `matplotlib`
- R: `fixest`, `dplyr`, `readr`
- Stata: `reghdfe`, `ftools`

---

## 9. Notes

**Decision log:**

- **API instead of Excel.** Chose the World Bank API for reproducibility. The pipeline can be re-run by anyone without downloading files manually. The cost is more code. The benefit is a reviewer can clone the repo and run it.
- **Window 2011-2024.** Chosen from coverage audit. Not assumed.
- **Drop countries with <3 years.** Explicit criterion, stated upfront, not silent deletion.
- **Lag length.** One year. Longer lags would reduce sample further. Shorter lags would not allow for adjustment.
- **Three languages.** To prove the pipeline is reproducible. Not to chase significance.

**What I would do differently:**

- Add the Czernich instrument for internet adoption. Legacy telephone infrastructure. Would require historical data not in WDI.
- Extend the female LFP analysis with India state-level data from PLFS. The country-level aggregation likely hides the mechanism.
- Use a longer panel for productivity. Gender-split internet is the binding constraint; productivity alone goes back further.

**What surprised me:**

- The pooled FE sign flip. Not just magnitude, direction.
- How sparse the gender-split data is. 1,363 observations sounds like a lot until you divide by 137 countries.
- How stable the coefficients are across three languages. Exactly the same to three decimals.

**What remains uncertain:**

- Whether the productivity result is causal or confounded by reverse causality.
- Whether the female LFP null is real or a measurement artifact.
- Whether the gender gap interaction would show up in a larger sample or a different specification.
