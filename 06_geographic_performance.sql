-- ============================================================
-- Query 6: Geographic Performance & Expansion Signals
-- Business Question: Which markets show the strongest
-- engagement and revenue per user? Where should Revolut
-- prioritise next-phase growth investment?
--
-- Relevance to Revolut F&S: Geographic expansion decisions
-- sit squarely in Strategy. This query produces the market
-- scorecard a Finance & Strategy analyst would build to
-- support a market entry memo or regional budget allocation.
-- ============================================================

WITH market_metrics AS (
    SELECT
        u.country,
        COUNT(DISTINCT u.user_id)                   AS total_users,
        COUNT(DISTINCT CASE WHEN u.kyc_verified THEN u.user_id END)
                                                    AS verified_users,
        COUNT(DISTINCT t.user_id)                   AS active_users,
        COUNT(t.txn_id)                             AS total_txns,
        ROUND(AVG(t.amount_local), 2)               AS avg_txn_value,
        SUM(t.amount_local)                         AS gross_volume,
        -- Paid plan penetration (non-Standard users)
        COUNT(DISTINCT CASE
            WHEN u.plan != 'Standard' THEN u.user_id
        END)                                        AS paid_plan_users
    FROM users u
    LEFT JOIN transactions t ON u.user_id = t.user_id
    GROUP BY u.country
),
market_revenue AS (
    SELECT
        u.country,
        SUM(sr.monthly_fee_gbp)             AS sub_revenue
    FROM subscription_revenue sr
    JOIN users u ON sr.user_id = u.user_id
    GROUP BY u.country
)
SELECT
    mm.country,
    mm.total_users,
    mm.verified_users,
    mm.active_users,
    ROUND(100.0 * mm.active_users / NULLIF(mm.total_users, 0), 1)
                                            AS activation_rate_pct,
    ROUND(100.0 * mm.paid_plan_users / NULLIF(mm.total_users, 0), 1)
                                            AS paid_penetration_pct,
    mm.total_txns,
    mm.avg_txn_value,
    mm.gross_volume,
    COALESCE(mr.sub_revenue, 0)             AS sub_revenue_gbp,
    ROUND(
        COALESCE(mr.sub_revenue, 0) / NULLIF(mm.active_users, 0),
    2)                                      AS arpu_gbp,
    -- Simple market opportunity score (normalised, higher = better)
    ROUND(
        (mm.active_users * 0.3)
        + (mm.avg_txn_value * 0.01)
        + (COALESCE(mr.sub_revenue, 0) * 0.5)
        + (mm.paid_plan_users * 5),
    2)                                      AS opportunity_score
FROM market_metrics mm
LEFT JOIN market_revenue mr ON mm.country = mr.country
ORDER BY opportunity_score DESC;
