-- ============================================================
-- Revolut Fintech Analytics | Schema
-- Author: Vishnu (Finance & Strategy Portfolio Project)
-- Description: Synthetic schema modelling a neobank's core
--              transactional and product data
-- ============================================================

-- Users
CREATE TABLE users (
    user_id         INTEGER PRIMARY KEY,
    country         VARCHAR(3),          -- ISO 3166-1 alpha-3
    plan            VARCHAR(20),         -- Standard, Plus, Premium, Metal, Ultra
    signup_date     DATE,
    kyc_verified    BOOLEAN,
    referral_source VARCHAR(30)          -- organic, paid_social, referral, partner
);

-- Accounts (users can hold multiple currency accounts)
CREATE TABLE accounts (
    account_id      INTEGER PRIMARY KEY,
    user_id         INTEGER REFERENCES users(user_id),
    currency        VARCHAR(3),
    created_date    DATE,
    is_primary      BOOLEAN
);

-- Transactions
CREATE TABLE transactions (
    txn_id          INTEGER PRIMARY KEY,
    account_id      INTEGER REFERENCES accounts(account_id),
    user_id         INTEGER REFERENCES users(user_id),
    txn_date        DATE,
    amount_local    DECIMAL(12,2),       -- amount in account currency
    currency        VARCHAR(3),
    txn_type        VARCHAR(30),         -- card_payment, transfer_out, transfer_in, top_up, fx_exchange, subscription_fee
    merchant_cat    VARCHAR(40),         -- MCC category: retail, food, travel, crypto, utilities etc.
    is_flagged      BOOLEAN              -- internal fraud/AML flag
);

-- FX Exchanges (subset of transactions where txn_type = 'fx_exchange')
CREATE TABLE fx_exchanges (
    fx_id           INTEGER PRIMARY KEY,
    user_id         INTEGER REFERENCES users(user_id),
    txn_date        DATE,
    from_currency   VARCHAR(3),
    to_currency     VARCHAR(3),
    amount_from     DECIMAL(12,2),
    amount_to       DECIMAL(12,2),
    mid_market_rate DECIMAL(14,6),
    executed_rate   DECIMAL(14,6),       -- rate Revolut charged
    plan            VARCHAR(20)          -- copied for easy analysis
);

-- Subscriptions / Revenue
CREATE TABLE subscription_revenue (
    rev_id          INTEGER PRIMARY KEY,
    user_id         INTEGER REFERENCES users(user_id),
    plan            VARCHAR(20),
    month           DATE,                -- first day of billing month
    monthly_fee_gbp DECIMAL(8,2),
    churned         BOOLEAN              -- did user downgrade/leave this month?
);
