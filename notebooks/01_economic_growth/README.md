# Chapter 1 — Economic Growth

## Overview
This chapter builds the foundational analytics infrastructure for the South Asia Analytics Platform. It profiles the raw World Bank World Development Indicators (WDI) export, separates real countries from regional aggregates, resolves indicator ambiguities, and constructs a clean, long-format panel for analyzing global growth trajectories.

## Research Question
How do South Asian economies' growth trajectories compare against fast-catch-up peers (China, Vietnam) and high-income baselines (US, Japan)? How does the composition of GDP (consumption vs. investment) differ across these groups?

## Data Profile & Cleaning Decisions
- **Source:** WDI Excel export (`WDIEXCEL.xlsx`).
- **Scale:** 396,970 rows, 265 country-name values, 1,498 indicators, spanning 1960–2025.
- **Aggregates vs. Real Countries:** The raw data includes 48 regional/income aggregates (e.g., "World", "OECD members"). We merged with the WDI country metadata to filter to **217 real countries** (identified by a non-null `Region` field). Aggregates collapse institutions and policy regimes that differ sharply across sovereign states.
- **Missingness Encoding:** Confirmed that missing values are encoded as **blank strings**, not `..` or `NaN`. The overall missing rate is 65.6%.
- **Structural Missingness:** We discovered that missingness is not random; it is driven by indicator vintage. PPP-based GDP and GNI series are 100% missing before 1990 (a consequence of ICP rebasing to 2021 international dollars), while consumption and capital-formation data go back to 1960.
- **Composition Validation:** Before trusting the WDI indicator labels, we empirically verified the consumption composition. For India in 2015, Households + NPISHs (59.01%) plus General Government (10.43%) equaled Total Final Consumption (69.44%). This confirmed the un-prefixed series is the sum, not a household-only aggregate.

## Outputs
- **Data:** `data/processed/chapter1_economic_growth_panel.csv` (71,610-row long-format panel).
- **Notebook:** `notebooks/01_economic_growth/01_profiling_and_reshaping.ipynb`

## Interactive Tableau Dashboard
To make these insights accessible to a non-technical audience, the cleaned Chapter 1 panel is connected to an interactive Tableau dashboard.

- **Dashboard Highlights:**
  - GDP PPP per capita over time (comparing India, China, US, Japan, etc.).
  - Consumption composition (stacked area: Government vs. Households).
  - Gross capital formation snapshot (investment rates).
- **Links:**
  - 📊 **[View the Live Tableau Dashboard Here](https://github.com/lucky-464/world-bank-indicators-project/blob/main/notebooks/01_economic_growth/dashboardseconomic_growth_tableau_dashboard.twbx)**
  - 📁 **Workbook File:** `dashboards/economic_growth_tableau.twbx` *(Packaged workbook containing both the viz and the data)*

## Key Findings
1. **The 1990 Structural Break:** PPP-based GDP/GNI data does not exist before 1990. Any growth analysis comparing countries prior to 1990 must rely on constant local currency or current USD, or explicitly restrict the timeline to 1990–2025.
2. **Convergence and Divergence:** While China and Vietnam show steep exponential catch-up growth from the 1990s, India's trajectory is steadier, and high-income baselines (US, Japan) show the expected plateauing.
3. **Investment vs. Consumption:** High-income economies (US) are heavily consumption-driven, whereas fast-catch-up economies (China) show significantly higher gross capital formation as a percentage of GDP.

---

