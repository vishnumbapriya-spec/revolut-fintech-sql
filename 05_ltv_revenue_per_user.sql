-- ============================================================
-- Query 5: Revenue Per User & Lifetime Value (LTV) Proxy
-- Business Question: Who are Revolut's highest-value users,
-- and what drives revenue concentration?
--
-- Relevance to Revolut F&S: LTV modelling is central to
-- growth strategy — customer acquisition cost (CAC) only makes
-- sense relative to LTV. This query builds a revenue per user
-- view combining subscription fees and estimated FX spread
-- revenue, mimicking what an F&S analyst would present to
-- leadership ahead of a budget cycle or fundraise.
-- ============================================================

WITH sub_revenue AS (
    SELECT
        user_id,
        SUM(monthly_fee_gbp)    AS total_sub_revenue_gbp
    FROM subscription_revenue
    GROUP BY user_id
),
fx_revenue AS (
    -- Estimated revenue from FX spread (in from_currency units)
    SELECT
        user_id,
        ROUND(SUM(amount_from * (executed_rate - mid_market_rate)), 2)
                                AS total_fx_spread_rev
    FROM fx_exchanges
    GROUP BY user_id
),
txn_volume AS (
    SELECT
        user_id,
        COUNT(*)                AS total_txns,
        SUM(amount_local)       AS gross_txn_volume,
        MIN(txn_date)           AS first_txn,
        MAX(txn_date)           AS last_txn,
        MAX(txn_date) - MIN(txn_date)
                                AS active_days_span
    FROM transactions
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.plan,
    u.country,
    u.referral_source,
    u.signup_date,
    tv.total_txns,
    tv.gross_txn_volume,
    tv.active_days_span,
    COALESCE(sr.total_sub_revenue_gbp, 0)   AS sub_revenue_gbp,
    COALESCE(fx.total_fx_spread_rev, 0)     AS fx_spread_rev,
    COALESCE(sr.total_sub_revenue_gbp, 0)
        + COALESCE(fx.total_fx_spread_rev, 0)
                                            AS total_est_revenue,
    -- Revenue rank
    RANK() OVER (
        ORDER BY (
            COALESCE(sr.total_sub_revenue_gbp, 0)
            + COALESCE(fx.total_fx_spread_rev, 0)
        ) DESC
    )                                       AS revenue_rank
FROM users u
LEFT JOIN sub_revenue sr   ON u.user_id = sr.user_id
LEFT JOIN fx_revenue fx    ON u.user_id = fx.user_id
LEFT JOIN txn_volume tv    ON u.user_id = tv.user_id
ORDER BY total_est_revenue DESC;

-- ============================================================
-- 5b: Revenue Concentration — Pareto check (80/20 rule)
-- ============================================================

WITH user_revenue AS (
    SELECT
        s.user_id,
        SUM(s.monthly_fee_gbp)
            + COALESCE(
                (SELECT SUM(amount_from*(executed_rate-mid_market_rate))
                 FROM fx_exchanges f WHERE f.user_id = s.user_id),
              0)                            AS total_rev
    FROM subscription_revenue s
    GROUP BY s.user_id
),
ranked AS (
    SELECT
        user_id,
        total_rev,
        SUM(total_rev) OVER ()              AS grand_total,
        SUM(total_rev) OVER (
            ORDER BY total_rev DESC
        )                                   AS cumulative_rev,
        ROUND(100.0 * SUM(total_rev) OVER (ORDER BY total_rev DESC)
              / NULLIF(SUM(total_rev) OVER (), 0), 2)
                                            AS cumulative_pct
    FROM user_revenue
)
SELECT
    user_id,
    ROUND(total_rev, 2)                     AS user_revenue,
    ROUND(cumulative_pct, 2)                AS cumulative_revenue_pct,
    CASE
        WHEN cumulative_pct <= 80 THEN 'Top 80% Revenue Contributors'
        ELSE 'Tail Users'
    END                                     AS user_segment
FROM ranked
ORDER BY total_rev DESC;
