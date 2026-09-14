# Chapter 1 — Economic Growth: Data Cleaning Notes

**Scope:** Cleaning decisions and missingness profile for the Economic Growth chapter of the WDI South Asia Analytics Platform. Covers the raw WDI export, the country-vs-aggregate split, and the construction of the Chapter 1 panel.

## Data Profiling

The raw WDI export contains 396,970 rows, 265 country-name values, 1,498 indicators, and year columns spanning 1960–2025. Missing values are encoded as blank cells — confirmed by loading the file with `dtype=str` and counting: 17,184,106 blanks, zero `".."` strings, zero NaNs. Overall missing rate: **65.6%**.

The 265 "countries" are not all countries. 48 of them are regional or income-group aggregates (World, South Asia, OECD members, Low income, and so on). Using the WDI country metadata file, real countries were identified as those with a non-null `Region` field: **217 real countries**. Chapter 1 uses only real countries — aggregates collapse institutions and policy regimes that differ sharply across sovereign states, and the research question is fundamentally about comparing countries, not regions. Aggregates will come back later as comparison bands (e.g., South Asia regional mean plotted against India's trajectory).

## Cleaning Decisions

Two decisions shaped the final panel.

**First, I verified the consumption-indicator composition empirically before trusting the labels.** The un-prefixed indicator "Final consumption expenditure (% of GDP)" could either mean *total* consumption or *households-only*. For India 2015: households and NPISHs (59.01%) plus general government (10.43%) equals the total (69.44%) — so the un-prefixed series is the sum, not a household-only aggregate. This resolved an ambiguity I had flagged in my chapter notes and confirmed the indicator names mean what they say.

**Second, I kept all five Chapter 1 indicators despite the 65.6% overall missing rate.** The missingness is structural, not random: GDP PPP and GNI PPP (constant 2021 intl $) are 100% missing before 1990 across every country uniformly, while consumption and capital-formation indicators go back to 1960. Because the gap is uniform across countries within a time window, the panel stays usable — analysis runs from 1990 onward with a documented cutoff, rather than requiring imputation or dropping indicators.

## Missingness by Decade

What I expected: consistent coverage from 1960 across all five indicators. What the decade breakdown actually showed: PPP-based indicators only begin in 1990 — a consequence of the ICP rebasing to 2021 international dollars. Consumption and capital-formation indicators have data from 1960 but start out ~55–70% missing in that first decade, filling in gradually through the 1990s.

**Takeaway:** missingness is concentrated by *indicator vintage*, not by country or random attrition. The World Bank's data is internally consistent, just not uniform across indicators.

## AI-Assisted Development

AI was used as a tutor and debugging partner — DeepSeek for concept explanations (pandas `melt`, `filter` vs `merge`, boolean masking), and Claude for step-by-step debugging when code failed. No code was copy-pasted blindly.

Things I caught and corrected myself:
- The `..` strings visible in the notebook were a Jupyter display artifact, not the actual data encoding — verified with `value_counts`.
- My first attempt at filtering used `.filter()`, which filters by index labels, not column values. Switched to boolean masking.
- The correct WDI name is `Viet Nam` (with a space), not `Vietnam`.

Results were validated by three independent checks:
1. **Composition check:** India 2015 — household (59.01) + government (10.43) = total (69.44).
2. **Row count checks:** 217 × 5 × 66 = 71,610 rows in the Chapter 1 panel; 396,970 × 66 = 26,200,020 rows after reshaping the raw export.
3. **Structural break check:** the decade-level missingness pattern matched known WDI breaks (PPP series start at 1990).