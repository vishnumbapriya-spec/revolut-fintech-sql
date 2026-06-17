# Revolut Fintech SQL Analytics

**A Finance & Strategy analytics project using SQL to model key business metrics for a neobank.**

Built as a portfolio project demonstrating financial analysis, product thinking, and data storytelling relevant to Revolut's Finance & Strategy function.

---

## Why This Project

Revolut's Finance & Strategy team sits at the intersection of data and decision-making — running the analyses that inform pricing changes, market expansion, product investment, and investor reporting.

This project models six of those core analytical workflows using a purpose-built synthetic database that mirrors how a neobank's transactional data actually looks. Every query is written with a real business question in mind, not just to demonstrate SQL syntax.

---

## Project Structure

```
revolut-fintech-sql/
├── data/
│   ├── 01_schema.sql        # Table definitions
│   └── 02_seed_data.sql     # Synthetic data (~15 users, ~35 transactions)
├── queries/
│   ├── 01_mrr_by_plan.sql          # Subscription revenue & MoM growth
│   ├── 02_fx_spread_analysis.sql   # FX margin & spread revenue
│   ├── 03_cohort_retention.sql     # User retention at 30/60/90 days
│   ├── 04_fraud_aml_flags.sql      # Risk flagging & KYC gap analysis
│   ├── 05_ltv_revenue_per_user.sql # LTV proxy & Pareto concentration
│   └── 06_geographic_performance.sql # Market scorecard & ARPU
└── README.md
```

---

## The Data Model

Five tables modelling a neobank's core data layer:

| Table | What it contains |
|---|---|
| `users` | 15 synthetic users across GBR, DEU, FRA, AUS, SGP, IND, USA, IRL — with plan tier and referral source |
| `accounts` | Multi-currency accounts (GBP, EUR, USD, AUD, SGD, INR) |
| `transactions` | ~36 transactions covering card payments, FX exchanges, top-ups, and transfers |
| `fx_exchanges` | FX conversion detail with mid-market vs executed rates (spread capture) |
| `subscription_revenue` | Monthly billing records across Standard, Plus, Premium, Metal, Ultra plans |

---

## Query Breakdown

### 1 · MRR by Plan (`01_mrr_by_plan.sql`)
**Business question:** Which subscription tiers drive revenue, and how is MRR trending?

Uses window functions to compute each plan's share of total MRR per month, alongside churn counts. A second query tracks month-on-month MRR growth using `LAG()`.

> **F&S context:** This is the top-line metric in any board or investor pack. Revolut's path to profitability hinges on predictable subscription revenue displacing pure transaction interchange.

---

### 2 · FX Spread Analysis (`02_fx_spread_analysis.sql`)
**Business question:** How much does Revolut earn from FX spreads, and does plan tier affect margin?

Computes spread (executed rate − mid-market rate) per currency pair and plan. Ranks plans by margin captured.

> **F&S context:** FX is one of Revolut's highest-margin revenue lines. Spread differentiation by plan tier is a deliberate pricing strategy — Standard users subsidise premium users' zero-spread benefit. Quantifying this trade-off informs plan pricing reviews.

---

### 3 · Cohort Retention (`03_cohort_retention.sql`)
**Business question:** Of newly activated users, how many return at 30, 60, and 90 days?

Tags each user's activity against 30/60/90-day windows from their first transaction. Aggregates retention rates by plan.

> **F&S context:** Retention is the denominator in every LTV calculation. Neobanks often have strong acquisition but weak D90 retention — surfacing this by plan tier helps identify where product investment pays off.

---

### 4 · Fraud & AML Flag Analysis (`04_fraud_aml_flags.sql`)
**Business question:** Which users and transaction categories carry elevated risk? Where are the KYC gaps?

Builds a three-tier risk classification (Clean / Review / High Risk) per user, identifies high-flag merchant categories, and surfaces unverified users with transaction activity.

> **F&S context:** Fraud losses and regulatory fines appear on the P&L. Finance & Strategy teams model expected loss rates and work with Risk to set provisioning assumptions. KYC gaps create regulatory capital implications under FCA/DFSA frameworks.

---

### 5 · LTV & Revenue per User (`05_ltv_revenue_per_user.sql`)
**Business question:** Who are the highest-value users? Is revenue concentrated in a small cohort?

Combines subscription fees and estimated FX spread revenue into a per-user total. A Pareto analysis checks whether 80% of revenue comes from ~20% of users.

> **F&S context:** LTV is the justification for CAC. If top-tier plan users generate 10x the revenue of Standard users, that directly informs acquisition channel spending and referral bonus economics.

---

### 6 · Geographic Performance (`06_geographic_performance.sql`)
**Business question:** Which markets show the highest engagement and revenue per user? Where to invest next?

Builds a market scorecard with activation rate, paid plan penetration, ARPU, and a composite opportunity score.

> **F&S context:** Revolut's geographic expansion (currently 38+ countries) requires a clear framework for prioritising market investment. This query produces the market scorecard that would accompany a regional strategy memo.

---

## How to Run

**Option 1 — PostgreSQL (recommended)**
```bash
psql -U your_user -d your_db -f data/01_schema.sql
psql -U your_user -d your_db -f data/02_seed_data.sql
psql -U your_user -d your_db -f queries/01_mrr_by_plan.sql
# ... repeat for other queries
```

**Option 2 — SQLite (quick test)**

The schema uses standard ANSI SQL with minor adjustments needed for SQLite (replace `BOOLEAN` with `INTEGER`, date arithmetic uses `julianday()`).

**Option 3 — DB Fiddle / SQLiteOnline**

Paste `01_schema.sql` then `02_seed_data.sql` into [sqlfiddle.com](https://sqlfiddle.com) or [sqliteonline.com](https://sqliteonline.com), then run any query file.

---

## Key SQL Techniques Used

- Window functions: `RANK()`, `LAG()`, `SUM() OVER (PARTITION BY ...)`, cumulative sums
- CTEs (Common Table Expressions) for multi-step logic
- Conditional aggregation with `CASE WHEN`
- `COALESCE` and `NULLIF` for null-safe arithmetic
- Self-referencing subqueries for Pareto analysis
- Date arithmetic for cohort windowing

---

## About

Built by **Vishnu** — Global MBA candidate (Consulting & Business Analytics), SP Jain School of Global Management. Prior background in agri-biotech operations and CFA Level I candidate (Nov 2026).

This project is part of a broader portfolio focused on finance, strategy, and fintech analytics.

> *All data is entirely synthetic. No real customer data is used or represented.*

