-- ============================================================
-- Query 1: Monthly Recurring Revenue (MRR) by Plan
-- Business Question: Which subscription tiers drive the most
-- revenue, and how does MRR trend month over month?
--
-- Relevance to Revolut F&S: Subscription revenue is a key
-- pillar of Revolut's move toward predictable, non-transactional
-- income. This mirrors the kind of analysis a Finance & Strategy
-- team would run ahead of board reporting or investor updates.
-- ============================================================

SELECT
    month,
    plan,
    COUNT(user_id)                          AS active_subscribers,
    SUM(monthly_fee_gbp)                    AS mrr_gbp,
    SUM(SUM(monthly_fee_gbp)) OVER (
        PARTITION BY month
    )                                       AS total_mrr_gbp,
    ROUND(
        100.0 * SUM(monthly_fee_gbp) /
        NULLIF(SUM(SUM(monthly_fee_gbp)) OVER (PARTITION BY month), 0),
    2)                                      AS plan_revenue_pct,
    COUNT(CASE WHEN churned THEN 1 END)     AS churns_this_month,
    ROUND(
        100.0 * COUNT(CASE WHEN churned THEN 1 END) /
        NULLIF(COUNT(user_id), 0),
    2)                                      AS churn_rate_pct
FROM subscription_revenue
GROUP BY month, plan
ORDER BY month, mrr_gbp DESC;

-- ============================================================
-- Query 1b: MRR Growth Rate Month-on-Month
-- ============================================================

WITH monthly_mrr AS (
    SELECT
        month,
        SUM(monthly_fee_gbp) AS mrr_gbp
    FROM subscription_revenue
    GROUP BY month
)
SELECT
    month,
    mrr_gbp,
    LAG(mrr_gbp) OVER (ORDER BY month)     AS prev_month_mrr,
    ROUND(
        100.0 * (mrr_gbp - LAG(mrr_gbp) OVER (ORDER BY month)) /
        NULLIF(LAG(mrr_gbp) OVER (ORDER BY month), 0),
    2)                                      AS mom_growth_pct
FROM monthly_mrr
ORDER BY month;
