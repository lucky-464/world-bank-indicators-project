# World Bank Indicators — South Asia Analytics Platform

A reproducible data pipeline and analytics platform built on World Bank World Development Indicators (WDI), focused on comparative development patterns across South Asia and peer economies.

## Motivation

WDI publishes ~1,500 indicators across 200+ countries and 60+ years — but the raw export is hostile to analysis: missing values encoded as blanks, aggregates mixed in with real countries, and wide year-columns that make time-series work impossible without reshaping. This project builds a vertical slice of infrastructure to profile, clean, and analyze that data reliably.

## Data

- **Source:** World Bank World Development Indicators (Excel export)
- **Raw file:** `WDIEXCEL.xlsx` (not committed — see `.gitignore`; regenerate from [databank.worldbank.org](https://databank.worldbank.org/source/world-development-indicators))
- **Coverage:** 396,970 rows, 265 country-name values (217 real countries + 48 aggregates), 1,498 indicators, 1960–2025

## Repository Structure
world-bank-indicators-project/
├── data/
│ └── processed/ # Cleaned outputs (committed)
├── docs/
│ └── methodology/ # Cleaning decisions, definitions (committed)
├── notebooks/
│ └── 01_economic_growth/ # Chapter 1 analysis notebook
├── src/
│ └── reshape_utils.py # Reusable WDI wide-to-long reshape function
└── PROJECT_PLAN.md # Roadmap and chapters
## Chapters

| # | Chapter | Status |
|---|---|---|
| 1 | Economic Growth | Complete |
| 2 | Health | Planned |
| 3 | Education | Planned |
| 4 | Labor & Employment | Planned |
| 5 | Trade & Investment | Planned |
| 6 | Governance & Institutions | Planned |

## Chapter 1 — Economic Growth

**Question:** How do South Asian economies' growth trajectories compare against fast-catch-up peers (China, Vietnam) and high-income baselines (US, Japan)?

**Indicators used:**

| Indicator | Code |
|---|---|
| GDP, PPP (constant 2021 international $) | `NY.GDP.MKTP.PP.KD` |
| GNI, PPP (constant 2021 international $) | `NY.GNP.MKTP.PP.KD` |
| General government final consumption expenditure (% of GDP) | `NE.CON.GOVT.ZS` |
| Households and NPISHs final consumption expenditure (% of GDP) | `NE.CON.PRVT.ZS` |
| Gross capital formation (% of GDP) | `NE.GDI.TOTL.ZS` |

**Outputs:**

- `data/processed/chapter1_economic_growth_panel.csv` — 71,610-row long-format panel (217 countries × 5 indicators × 66 years)
- `data/processed/chapter1_missingness_by_decade.csv` — missingness by indicator × decade

**Key findings:**

- Missingness is **structural**, not random. GDP and GNI PPP (2021 base) are 100% missing before 1990 across all countries — a consequence of ICP rebasing. Consumption and capital-formation indicators go back to 1960.
- Verified empirically that `Final consumption expenditure (total) = Households + General government` (India 2015: 69.44% = 59.01% + 10.43%), confirming the two component indicators compose correctly.

**Methodology:** See [`docs/methodology/chapter1_economic_growth_cleaning.md`](docs/methodology/chapter1_economic_growth_cleaning.md)

## Setup

```bash
git clone <repo>
cd world-bank-indicators-project
pip install pandas openpyxl matplotlib
# Download WDIEXCEL.xlsx from the World Bank and place at repo root
