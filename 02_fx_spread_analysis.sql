-- ============================================================
-- Query 2: FX Spread Revenue Analysis
-- Business Question: How much revenue does Revolut earn from
-- FX spreads, and does plan type affect spread margins?
--
-- Relevance to Revolut F&S: FX exchange is one of Revolut's
-- core monetisation levers. Premium/Metal plans get tighter
-- spreads — this query quantifies the revenue trade-off and
-- identifies which user cohorts drive FX income. This feeds
-- directly into pricing strategy discussions.
-- ============================================================

SELECT
    fx.plan,
    fx.from_currency || '/' || fx.to_currency   AS currency_pair,
    COUNT(*)                                     AS num_exchanges,
    SUM(fx.amount_from)                          AS total_volume_from,
    ROUND(AVG(fx.executed_rate - fx.mid_market_rate), 6)
                                                 AS avg_spread,
    ROUND(
        AVG(
            (fx.executed_rate - fx.mid_market_rate) / fx.mid_market_rate * 100
        ), 4)                                    AS avg_spread_pct,
    -- Revenue earned from spread (in destination currency units)
    ROUND(
        SUM(
            fx.amount_from * (fx.executed_rate - fx.mid_market_rate)
        ), 2)                                    AS est_spread_revenue
FROM fx_exchanges fx
GROUP BY fx.plan, currency_pair
ORDER BY fx.plan, est_spread_revenue DESC;

-- ============================================================
-- Query 2b: Spread Margin Comparison — Paid vs Free Plans
-- Insight: Standard users (none in fx_exchanges here) would
-- face the highest spread; this query groups by plan tier.
-- ============================================================

WITH plan_spreads AS (
    SELECT
        plan,
        ROUND(AVG(
            (executed_rate - mid_market_rate) / mid_market_rate * 100
        ), 4) AS avg_spread_pct,
        SUM(amount_from) AS total_volume
    FROM fx_exchanges
    GROUP BY plan
)
SELECT
    plan,
    avg_spread_pct,
    total_volume,
    -- Rank plans by how much margin Revolut captures
    RANK() OVER (ORDER BY avg_spread_pct DESC) AS spread_rank
FROM plan_spreads
ORDER BY avg_spread_pct DESC;
