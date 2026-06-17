-- ============================================================
-- Query 3: User Cohort Retention & Engagement
-- Business Question: Of users who signed up in a given period,
-- how many remain active transacting users 30/60/90 days later?
--
-- Relevance to Revolut F&S: Retention cohort analysis is a
-- standard metric in fintech strategy decks and investor
-- materials. Revolut's growth thesis depends on high retention
-- of activated users — this query operationalises that KPI.
-- ============================================================

WITH user_first_txn AS (
    -- Identify when each user first transacted (activation date)
    SELECT
        user_id,
        MIN(txn_date) AS first_txn_date
    FROM transactions
    GROUP BY user_id
),
user_activity AS (
    -- All distinct active dates per user
    SELECT DISTINCT
        user_id,
        txn_date AS active_date
    FROM transactions
),
cohort_base AS (
    SELECT
        u.user_id,
        u.signup_date,
        u.plan,
        u.country,
        ft.first_txn_date,
        -- Days from signup to first transaction (activation lag)
        ft.first_txn_date - u.signup_date AS days_to_activate
    FROM users u
    JOIN user_first_txn ft ON u.user_id = ft.user_id
)
SELECT
    cb.user_id,
    cb.plan,
    cb.country,
    cb.signup_date,
    cb.first_txn_date,
    cb.days_to_activate,
    -- Check for activity at 30/60/90-day windows from first transaction
    MAX(CASE
        WHEN ua.active_date BETWEEN cb.first_txn_date + 1
                                AND cb.first_txn_date + 30
        THEN 1 ELSE 0
    END)                                AS active_in_first_30d,
    MAX(CASE
        WHEN ua.active_date BETWEEN cb.first_txn_date + 31
                                AND cb.first_txn_date + 60
        THEN 1 ELSE 0
    END)                                AS active_in_31_60d,
    MAX(CASE
        WHEN ua.active_date BETWEEN cb.first_txn_date + 61
                                AND cb.first_txn_date + 90
        THEN 1 ELSE 0
    END)                                AS active_in_61_90d
FROM cohort_base cb
LEFT JOIN user_activity ua ON cb.user_id = ua.user_id
GROUP BY cb.user_id, cb.plan, cb.country, cb.signup_date,
         cb.first_txn_date, cb.days_to_activate
ORDER BY cb.first_txn_date;

-- ============================================================
-- Query 3b: Retention Rates Aggregated by Plan
-- ============================================================

WITH user_first_txn AS (
    SELECT user_id, MIN(txn_date) AS first_txn_date
    FROM transactions GROUP BY user_id
),
cohort_activity AS (
    SELECT
        u.user_id,
        u.plan,
        ft.first_txn_date,
        MAX(CASE WHEN t.txn_date BETWEEN ft.first_txn_date + 1
                                     AND ft.first_txn_date + 30
                 THEN 1 ELSE 0 END) AS d30,
        MAX(CASE WHEN t.txn_date BETWEEN ft.first_txn_date + 31
                                     AND ft.first_txn_date + 60
                 THEN 1 ELSE 0 END) AS d60,
        MAX(CASE WHEN t.txn_date BETWEEN ft.first_txn_date + 61
                                     AND ft.first_txn_date + 90
                 THEN 1 ELSE 0 END) AS d90
    FROM users u
    JOIN user_first_txn ft ON u.user_id = ft.user_id
    JOIN transactions t    ON u.user_id = t.user_id
    GROUP BY u.user_id, u.plan, ft.first_txn_date
)
SELECT
    plan,
    COUNT(*)                            AS cohort_size,
    ROUND(100.0 * SUM(d30) / COUNT(*), 1) AS retention_30d_pct,
    ROUND(100.0 * SUM(d60) / COUNT(*), 1) AS retention_60d_pct,
    ROUND(100.0 * SUM(d90) / COUNT(*), 1) AS retention_90d_pct
FROM cohort_activity
GROUP BY plan
ORDER BY retention_30d_pct DESC;
