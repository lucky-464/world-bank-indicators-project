
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
