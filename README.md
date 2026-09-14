readme = """# World Bank Indicators — South Asia Analytics Platform

A reproducible data pipeline and analytics platform built on World Bank World Development Indicators (WDI), focused on comparative development patterns across South Asia and peer economies.

## Motivation

WDI publishes ~1,500 indicators across 200+ countries and 60+ years — but the raw export is hostile to analysis: missing values encoded as blanks, aggregates mixed in with real countries, and wide year-columns that make time-series work impossible without reshaping. This project builds a vertical slice of infrastructure to profile, clean, and analyze that data reliably.

## Data

- **Source:** World Bank World Development Indicators (Excel export)
- **Raw file:** `WDIEXCEL.xlsx` (not committed — see `.gitignore`; regenerate from [databank.worldbank.org](https://databank.worldbank.org/source/world-development-indicators))
- **Coverage:** 396,970 rows, 265 country-name values (217 real countries + 48 aggregates), 1,498 indicators, 1960–2025

## Repository Structure
