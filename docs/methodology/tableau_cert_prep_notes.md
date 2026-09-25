# Tableau Desktop Specialist — Prep Notes

Running log of concepts, traps, and exam-domain coverage as I build the
Chapter 1 dashboard for this project. Updated after every build session.

**Goal:** Pass Tableau Desktop Specialist exam within 3–4 weeks.

**Approach:** Learn-by-building. No separate prep course — the dashboard
*is* the practice. Concepts are documented as they come up in real work.

**Exam structure (4 domains):**
1. Connecting to & Preparing Data
2. Exploring & Analyzing Data
3. Sharing Insights (dashboards, stories)
4. Understanding Tableau Concepts

---

## Exam Domain Coverage Tracker

| Domain | Status | First exercised |
|---|---|---|
| 1. Connecting to & Preparing Data | 🟡 Partial | Day 1 (CSV connect) |
| 2. Exploring & Analyzing Data | 🟢 Started | Day 1 (line chart, filters, axis) |
| 3. Sharing Insights (Dashboards) | 🔴 Not started | — |
| 4. Understanding Tableau Concepts | 🟡 Partial | Day 1 (Dimensions/Measures) |

---

## Build Log

### Day 1 — First line chart (GDP PPP, 6 countries)

**Built:** Connected `data/processed/chapter1_economic_growth_panel.csv` to
Tableau Desktop. Built a line chart with `Years` → Columns, `Value` → Rows,
`Country Name` → Color. Filtered to indicator `GDP, PPP (constant 2021 intl $)`
and 6 countries (Bangladesh, China, India, Japan, United States, Viet Nam).
Formatted the axis (`Edit Axis` → rename + currency format), changed Marks
card to `Line`, sorted legend alphabetically. Renamed sheet to
`GDP PPP over time`. Saved as `dashboards/economic_growth_tableau_dashboard.twbx`.

**Concepts learned:**
- Dimensions (blue, categorical) vs Measures (green, numeric)
- Discrete (blue pill) vs Continuous (green pill)
- SUM aggregation trap on `Years` — right-click → Dimension to fix
- Dimension filters (Country Name, Indicator Name)
- Marks card: Color, Size, Detail, Tooltip, Label
- Axis formatting via `Edit Axis`
- Workbook formats: `.twb` (XML) vs `.twbx` (packaged with data)

**Exam relevance:**
- Domain 1: Connecting to text file, data source preview
- Domain 2: Building a line chart, filtering, formatting axes & legends
- Domain 4: Dimensions/Measures, Discrete/Continuous (fundamentals)

**Traps logged:**
- Tableau auto-aggregates every Measure as SUM. For time series, `Years`
  must be a Dimension, not a Measure-summed-into-a-single-value.
- The status bar shows the *grand total* of the current view, not a single
  cell's value. Don't confuse it with a data point.
- `SUM(Value)` on a multi-country chart sums across countries within each
  year. That's correct for total-GDP, but wrong for "per-country trend" if
  you forget `Country Name` is on Color.

**Open decision:** Brief asked for *GDP PPP per capita*. Chapter 1 CSV has
*total GDP PPP* only. Will document the scope decision in
`docs/methodology/economic_growth_tableau_design.md` (write at end of build).

---

## Concept Index

| Concept | Day first seen | Where |
|---|---|---|
| Dimensions vs Measures | Day 1 | Line chart, data pane |
| Discrete vs Continuous (blue/green pills) | Day 1 | Years → Columns |
| SUM aggregation default | Day 1 | Years pill trap |
| Dimension filter | Day 1 | Country Name → Filters |
| Marks card (Color, Line) | Day 1 | Line chart |
| Edit Axis | Day 1 | Y-axis formatting |
| .twb vs .twbx | Day 1 | Save As dialog |
| Table calculations | Day 2 | Consumption chart (upcoming) |
| Calculated fields | Day 3 | Income-group line (upcoming) |
| LOD expressions | Day 3 | Income-group line (upcoming) |
| Dashboard actions | Day 4 | Assembly (upcoming) |
| Joins vs Relationships | Day 6 | Exam drills (upcoming) |

---

### `.twb` vs `.twbx`
- `.twb` = XML only, no embedded data. Breaks if the source file moves.
- `.twbx` = XML + embedded `.hyper` extract. Self-contained, portable.
- **Rule:** always commit `.twbx` to this repo. `.twb` only when the data lives on a server both users can reach.
- **Exam relevance:** Domain 3 (Sharing Insights) — "which format do you send to a colleague?"
