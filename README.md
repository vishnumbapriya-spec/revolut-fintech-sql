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
