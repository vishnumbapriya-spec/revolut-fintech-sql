-- ============================================================
-- Query 4: Fraud & AML Flag Analysis
-- Business Question: Which users, transaction types, and
-- merchant categories show elevated risk signals?
--
-- Relevance to Revolut F&S: Fraud/AML risk has direct P&L
-- implications (chargebacks, fines, write-offs). Finance &
-- Strategy teams model expected loss rates and stress-test
-- capital adequacy. This query surfaces the patterns a risk
-- team would escalate to a strategy review.
-- ============================================================

-- 4a: Flagged transaction summary
SELECT
    t.user_id,
    u.plan,
    u.country,
    COUNT(*)                                AS total_txns,
    SUM(CASE WHEN t.is_flagged THEN 1 ELSE 0 END)
                                            AS flagged_txns,
    ROUND(
        100.0 * SUM(CASE WHEN t.is_flagged THEN 1 ELSE 0 END) /
        NULLIF(COUNT(*), 0),
    2)                                      AS flag_rate_pct,
    SUM(CASE WHEN t.is_flagged THEN t.amount_local ELSE 0 END)
                                            AS flagged_volume,
    SUM(t.amount_local)                     AS total_volume,
    -- Flag if >1 flagged transaction or flagged volume > 1000
    CASE
        WHEN SUM(CASE WHEN t.is_flagged THEN 1 ELSE 0 END) > 1
          OR SUM(CASE WHEN t.is_flagged THEN t.amount_local ELSE 0 END) > 1000
        THEN 'HIGH RISK'
        WHEN SUM(CASE WHEN t.is_flagged THEN 1 ELSE 0 END) = 1
        THEN 'REVIEW'
        ELSE 'CLEAN'
    END                                     AS risk_tier
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY t.user_id, u.plan, u.country
ORDER BY flagged_volume DESC;

-- ============================================================
-- 4b: Risk by Merchant Category and Transaction Type
-- ============================================================

SELECT
    COALESCE(merchant_cat, txn_type)       AS category,
    COUNT(*)                               AS total_txns,
    SUM(CASE WHEN is_flagged THEN 1 ELSE 0 END)
                                           AS flagged_count,
    ROUND(
        100.0 * SUM(CASE WHEN is_flagged THEN 1 ELSE 0 END) /
        NULLIF(COUNT(*), 0),
    2)                                     AS flag_rate_pct,
    SUM(CASE WHEN is_flagged THEN amount_local ELSE 0 END)
                                           AS flagged_volume
FROM transactions
GROUP BY COALESCE(merchant_cat, txn_type)
HAVING SUM(CASE WHEN is_flagged THEN 1 ELSE 0 END) > 0
ORDER BY flag_rate_pct DESC;

-- ============================================================
-- 4c: KYC gap — unverified users with transaction activity
-- Strategy implication: KYC failures create regulatory risk;
-- quantifying exposed volume helps prioritise remediation.
-- ============================================================

SELECT
    u.user_id,
    u.country,
    u.plan,
    u.kyc_verified,
    COUNT(t.txn_id)         AS txn_count,
    SUM(t.amount_local)     AS total_volume
FROM users u
LEFT JOIN transactions t ON u.user_id = t.user_id
WHERE u.kyc_verified = FALSE
GROUP BY u.user_id, u.country, u.plan, u.kyc_verified
ORDER BY total_volume DESC NULLS LAST;
