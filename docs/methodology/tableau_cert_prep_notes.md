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
### Day 2 — Consumption composition (stacked area, 6 countries)

**Built:** New worksheet `Consumption composition`. Created two calculated
fields (`Govt Consumption`, `Household Consumption`) using
`IF [Indicator Code] = "..." THEN [Value] END`. Plotted with
`Years` → Columns, `Measure Values` → Rows, `Measure Names` → Color,
and `Country Name` → Columns (facets). Filtered to 6 countries + 2
indicators. Changed Marks to Area. Applied independent axis range,
then locked to shared 0–100.

**Concepts learned:**
- Calculated fields (IF/THEN/END pattern for splitting long-format measures)
- `Measure Names` / `Measure Values` in practice
- Faceting (small multiples) via `Country Name` → Columns
- Stacked area chart construction
- `Edit Axis` — independent vs shared axis ranges

**Exam relevance:**
- Domain 2: calculated fields, Measure Names/Values, chart building
- Domain 4: when stacked areas are appropriate (part-to-whole over time)

**Traps logged:**
- Without `Country Name` on the view, Tableau sums all 6 countries into
  one — the Y-axis showed 0–450% before faceting. Same root cause as the
  Day 1 `SUM(Value)` trap: any Dimension filter only restricts rows, it
  does not split aggregation.
- Independent axis ranges can *mislead* side-by-side comparisons. Use
  shared axes unless the scale difference is the point.

**Insight from chart:** China's household consumption fell from ~60% to
~35% of GDP between 1990 and 2010, mirroring the savings-glut narrative.
India and Bangladesh show household dominance with minimal government
consumption. US and Japan show the widest government-consumption bands.

### Day 2 — chart reading (for design note later)
Shared-axis comparison reveals:
- China: household consumption share collapsed from ~75% (1980) to
  ~35% (2010) — the savings-glut narrative.
- India, Bangladesh: household-dominant composition (~70–80%),
  government thin (~10%) — classic low-tax-base development pattern.
- US, Japan: widest government-consumption band (~15–20% of GDP).
- Viet Nam: sharp household dip ~2020 — COVID shock visible in the data.

This is the visual answer to Chapter 1 Section 3, Q6 (the "government
vs household consumption" ambiguity).

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
| Dimensions vs Measures (blue vs green) | Day 1 | Data pane |
| `Measure Names` / `Measure Values` | Day 2 | Consumption chart |
| Calculated fields (IF/THEN/END) | Day 2 | Consumption chart |
| `Measure Names` / `Measure Values` (in practice) | Day 2 | Consumption chart |

---

### `.twb` vs `.twbx`
- `.twb` = XML only, no embedded data. Breaks if the source file moves.
- `.twbx` = XML + embedded `.hyper` extract. Self-contained, portable.
- **Rule:** always commit `.twbx` to this repo. `.twb` only when the data lives on a server both users can reach.
- **Exam relevance:** Domain 3 (Sharing Insights) — "which format do you send to a colleague?"

---

### Dimensions vs Measures
- **Dimension** (blue): categories/labels. Grouped, not aggregated. e.g. `Country Name`, `Indicator Name`.
- **Measure** (green `#`): numbers you aggregate. Default agg = SUM. e.g. `Value`.
- **Rule of thumb:** "total of X" / "average of X" → Measure. "group by X" / "filter to X" → Dimension.
- **Exam relevance:** Domain 4. Common exam question: "which field is a Measure?"

### `Measure Names` / `Measure Values`
- Auto-generated by Tableau when multiple measures exist.
- `Measure Names` (dimension): holds the names of measures — used on Color / Rows to split one series per measure.
- `Measure Values` (measure): placeholder for actual numbers — used on Rows / Text to plot them.
- **Exam relevance:** Domain 2. Used for dual-measure charts (e.g., GDP and Population together).
### Splitting a long-format measure column
When two measures live in the same column (e.g. `Value` for both government
and household consumption), you cannot plot them separately without first
creating two calculated fields that filter `Value` by `Indicator Code`.
- `[Govt Consumption] = IF [Indicator Code] = "NE.CON.GOVT.ZS" THEN [Value] END`
- `[Household Consumption] = IF [Indicator Code] = "NE.CON.PRVT.ZS" THEN [Value] END`
### Anatomy of `IF ... THEN ... END`
- `IF [condition] THEN [return] END` — returns NULL if condition is false.
- `[Indicator Code]` = column reference. Always square brackets.
- `= "NE.CON.GOVT.ZS"` — string comparison. Use `=` (not `==`). Double quotes for text.
- `THEN [Value]` — what to return when the row matches.
- `END` — required. Without it, Tableau throws a syntax error.
- **When to use this pattern:** whenever a measure lives in a long-format column and you need one measure per category.
- **Exam relevance:** Domain 2. Basic calculated fields are heavily tested; this is the simplest form.
Then use `Measure Names` on Color and `Measure Values` on Rows.
**Exam relevance:** Domain 2. This "long → split" pattern appears in scenario questions.
### Git — what `git add` actually does
- Three areas: working directory → staging area → repository
- `git add <file>` = stage. Moves changes into "ready to commit" zone.
- `git commit` = snapshot staged changes into local history.
- `git push` = send local commits to GitHub.
- Why staging exists: lets you choose WHICH changes go into a commit, not all of them.
- **Analyst relevance:** every commit should be a deliberate, single-topic snapshot. Staging is how you keep that clean.
