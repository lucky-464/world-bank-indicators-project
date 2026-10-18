# Chapter 3 — India Labour Extension

This module extends the cross-country digital adoption panel to India. It builds a state-level and occupation-level exposure index using PLFS 2022–2024 microdata and NCO-2015 text descriptions.

## Data & Methodology

- **Labour Outcomes:** PLFS unit-level data (2022–2024). We restrict the sample to the working-age population (15–59) and filter to regular salaried workers for wage analyses.
- **Exposure Index (Text as Data):** We parsed the NCO-2015 Volume II-B PDF (577 pages) and applied Autor, Levy, Murnane (ALM) keyword dictionaries to tag occupations as Routine or Non-Routine. The final `Routine_Intensity` score ranges from 0 to 1.
- **Validation:** A random sample of 10 occupation descriptions was hand-labelled. We updated the keyword dictionary to capture manual routine tasks (e.g., "sow", "sweep") which improved accuracy.
- **Harmonisation:** PLFS 2022/2023 use legacy NSS variable names (e.g., `b5pt1q6`), while 2024 uses descriptive names. We mapped them to a unified schema (see `00_coverage_audit.ipynb`).

## Notebook Pipeline
1. **`00_coverage_audit.ipynb`**: Audits the raw PLFS files, documents the schema mismatch between 2022/23 and 2024, and establishes the 2025 sample revamp exclusion.
2. **`01_plfs_build.ipynb`**: Cleans and stacks the three PLFS rounds. Creates the data dictionary and working-age filters.
3. **`02_text_exposure.ipynb`**: Extracts text from the NCO-2015 PDF, applies keyword scoring, and merges the exposure index back into PLFS.
4. **`03_econometrics.ipynb`**: Runs the baseline log-wage model with State/Year Fixed Effects, clustered by state. Includes heterogeneity splits (Urban/Rural, Low/High Skill).
5. **`04_ml_shap.ipynb`**: Trains an XGBoost model (R² = 0.46) and uses SHAP values to interpret non-linear feature importance.

## Key Findings
1. **The Gender Penalty:** Routine exposure carries a significant *additional* wage penalty for women (-0.34 log points) relative to men.
2. **Skill Heterogeneity:** High-skilled women in routine jobs suffer a larger penalty (-0.40) than low-skilled women (-0.32).
3. **ML Confirmation:** SHAP values from the XGBoost model confirm that Routine Exposure and Gender are the top two drivers of wage suppression, aligning perfectly with the OLS results.

## Limitations
- **Reverse Causality:** Observational data; routine jobs may simply sort into low-wage states.
- **Imputation:** 80 missing PDF codes were imputed using 1-digit ISCO major group averages.
- **Small Clusters:** ~34 state clusters; wild-bootstrap recommended for future robustness checks.
- **2025 Exclusion:** Due to a structural break in the PLFS survey design, 2025 data was excluded to ensure comparability.

## Outputs
- `outputs/tables/task7_results.csv`: Regression coefficients for baseline and heterogeneity models.
- `outputs/figures/task1_india_diffusion.png`: India vs. Global Peers (WDI).
- `outputs/figures/task5_exposure_vs_gap.png`: State-level exposure vs. gender wage gap.
- `outputs/figures/task8_shap_summary.png`: SHAP values for XGBoost model.
