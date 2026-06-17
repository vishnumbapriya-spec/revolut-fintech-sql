-- ============================================================
-- Revolut Fintech Analytics | Seed Data
-- Synthetic data only — no real customer information
-- ============================================================

INSERT INTO users VALUES
(1,  'GBR', 'Metal',    '2022-03-15', TRUE,  'organic'),
(2,  'GBR', 'Standard', '2022-07-01', TRUE,  'referral'),
(3,  'DEU', 'Premium',  '2021-11-20', TRUE,  'paid_social'),
(4,  'FRA', 'Plus',     '2023-01-10', TRUE,  'referral'),
(5,  'IND', 'Standard', '2023-06-05', FALSE, 'organic'),
(6,  'AUS', 'Metal',    '2020-09-30', TRUE,  'partner'),
(7,  'GBR', 'Ultra',    '2023-11-01', TRUE,  'organic'),
(8,  'SGP', 'Premium',  '2022-04-18', TRUE,  'paid_social'),
(9,  'USA', 'Standard', '2024-01-22', TRUE,  'referral'),
(10, 'GBR', 'Standard', '2024-02-14', FALSE, 'paid_social'),
(11, 'GBR', 'Plus',     '2022-08-09', TRUE,  'organic'),
(12, 'DEU', 'Metal',    '2021-05-27', TRUE,  'partner'),
(13, 'FRA', 'Standard', '2023-09-03', TRUE,  'referral'),
(14, 'IRL', 'Premium',  '2022-12-19', TRUE,  'organic'),
(15, 'GBR', 'Ultra',    '2024-03-07', TRUE,  'paid_social');

INSERT INTO accounts VALUES
(101, 1,  'GBP', '2022-03-15', TRUE),
(102, 1,  'EUR', '2022-03-16', FALSE),
(103, 1,  'USD', '2022-04-01', FALSE),
(104, 2,  'GBP', '2022-07-01', TRUE),
(105, 3,  'EUR', '2021-11-20', TRUE),
(106, 3,  'USD', '2021-12-01', FALSE),
(107, 4,  'EUR', '2023-01-10', TRUE),
(108, 5,  'INR', '2023-06-05', TRUE),
(109, 6,  'AUD', '2020-09-30', TRUE),
(110, 6,  'GBP', '2020-10-05', FALSE),
(111, 7,  'GBP', '2023-11-01', TRUE),
(112, 8,  'SGD', '2022-04-18', TRUE),
(113, 9,  'USD', '2024-01-22', TRUE),
(114, 10, 'GBP', '2024-02-14', TRUE),
(115, 11, 'GBP', '2022-08-09', TRUE),
(116, 12, 'EUR', '2021-05-27', TRUE),
(117, 13, 'EUR', '2023-09-03', TRUE),
(118, 14, 'EUR', '2022-12-19', TRUE),
(119, 15, 'GBP', '2024-03-07', TRUE);

INSERT INTO transactions VALUES
-- User 1 (Metal, GBR) — heavy user
(1001, 101, 1, '2024-01-05', 120.00, 'GBP', 'card_payment',    'food',        FALSE),
(1002, 101, 1, '2024-01-10', 450.00, 'GBP', 'card_payment',    'travel',      FALSE),
(1003, 101, 1, '2024-01-15', 200.00, 'GBP', 'fx_exchange',     NULL,          FALSE),
(1004, 102, 1, '2024-01-20',  80.00, 'EUR', 'card_payment',    'retail',      FALSE),
(1005, 101, 1, '2024-02-03',  55.00, 'GBP', 'card_payment',    'food',        FALSE),
(1006, 101, 1, '2024-02-18', 999.00, 'GBP', 'card_payment',    'crypto',      TRUE),
(1007, 101, 1, '2024-03-01', 300.00, 'GBP', 'transfer_out',    NULL,          FALSE),
-- User 2 (Standard, GBR) — low engagement
(1008, 104, 2, '2024-01-08',  30.00, 'GBP', 'card_payment',    'food',        FALSE),
(1009, 104, 2, '2024-02-14',  22.50, 'GBP', 'card_payment',    'utilities',   FALSE),
-- User 3 (Premium, DEU)
(1010, 105, 3, '2024-01-12', 340.00, 'EUR', 'card_payment',    'retail',      FALSE),
(1011, 105, 3, '2024-01-25', 180.00, 'EUR', 'fx_exchange',     NULL,          FALSE),
(1012, 106, 3, '2024-02-07',  90.00, 'USD', 'card_payment',    'food',        FALSE),
(1013, 105, 3, '2024-03-10', 500.00, 'EUR', 'card_payment',    'travel',      FALSE),
-- User 4 (Plus, FRA)
(1014, 107, 4, '2024-01-19',  75.00, 'EUR', 'card_payment',    'food',        FALSE),
(1015, 107, 4, '2024-02-22', 250.00, 'EUR', 'transfer_out',    NULL,          FALSE),
-- User 6 (Metal, AUS) — high value
(1016, 109, 6, '2024-01-04', 800.00, 'AUD', 'card_payment',    'travel',      FALSE),
(1017, 109, 6, '2024-01-09', 150.00, 'AUD', 'card_payment',    'food',        FALSE),
(1018, 110, 6, '2024-01-15', 600.00, 'GBP', 'fx_exchange',     NULL,          FALSE),
(1019, 109, 6, '2024-02-01',1200.00, 'AUD', 'card_payment',    'retail',      FALSE),
(1020, 109, 6, '2024-02-20', 400.00, 'AUD', 'card_payment',    'crypto',      TRUE),
-- User 7 (Ultra, GBR)
(1021, 111, 7, '2024-01-06', 220.00, 'GBP', 'card_payment',    'food',        FALSE),
(1022, 111, 7, '2024-01-17', 1500.00,'GBP', 'card_payment',    'travel',      FALSE),
(1023, 111, 7, '2024-02-11', 300.00, 'GBP', 'fx_exchange',     NULL,          FALSE),
(1024, 111, 7, '2024-03-05', 180.00, 'GBP', 'card_payment',    'retail',      FALSE),
-- User 9 (Standard, USA) — new user
(1025, 113, 9, '2024-02-01',  50.00, 'USD', 'top_up',          NULL,          FALSE),
(1026, 113, 9, '2024-02-05',  45.00, 'USD', 'card_payment',    'food',        FALSE),
-- User 11 (Plus, GBR)
(1027, 115, 11,'2024-01-11', 160.00, 'GBP', 'card_payment',    'retail',      FALSE),
(1028, 115, 11,'2024-02-09',  88.00, 'GBP', 'card_payment',    'utilities',   FALSE),
(1029, 115, 11,'2024-03-14', 210.00, 'GBP', 'transfer_out',    NULL,          FALSE),
-- User 12 (Metal, DEU)
(1030, 116, 12,'2024-01-03', 950.00, 'EUR', 'card_payment',    'travel',      FALSE),
(1031, 116, 12,'2024-01-22', 420.00, 'EUR', 'fx_exchange',     NULL,          FALSE),
(1032, 116, 12,'2024-02-17', 300.00, 'EUR', 'card_payment',    'retail',      FALSE),
(1033, 116, 12,'2024-03-08',  75.00, 'EUR', 'card_payment',    'food',        FALSE),
-- Flagged suspicious cluster
(1034, 113, 9, '2024-03-01',4999.00, 'USD', 'transfer_out',    NULL,          TRUE),
(1035, 114,10, '2024-02-28',4800.00, 'GBP', 'card_payment',    'crypto',      TRUE),
(1036, 119,15, '2024-03-15',3200.00, 'GBP', 'fx_exchange',     NULL,          TRUE);

INSERT INTO fx_exchanges VALUES
(201, 1,  '2024-01-15', 'GBP', 'EUR', 200.00, 233.60, 1.1720, 1.1680, 'Metal'),
(202, 3,  '2024-01-25', 'EUR', 'USD', 180.00, 194.40, 1.0850, 1.0800, 'Premium'),
(203, 6,  '2024-01-15', 'AUD', 'GBP', 600.00, 308.40, 0.5200, 0.5140, 'Metal'),
(204, 7,  '2024-02-11', 'GBP', 'EUR', 300.00, 349.50, 1.1680, 1.1650, 'Ultra'),
(205, 12, '2024-01-22', 'EUR', 'GBP', 420.00, 358.05, 0.8580, 0.8525, 'Metal'),
(206, 15, '2024-03-15', 'GBP', 'USD', 3200.00,4006.40,1.2560, 1.2520, 'Ultra'),
(207, 1,  '2024-03-20', 'USD', 'GBP',  500.00, 393.50, 0.7900, 0.7870, 'Metal'),
(208, 4,  '2024-02-22', 'EUR', 'GBP',  250.00, 213.25, 0.8580, 0.8530, 'Plus');

INSERT INTO subscription_revenue VALUES
(301, 1,  'Metal',    '2024-01-01', 14.99, FALSE),
(302, 1,  'Metal',    '2024-02-01', 14.99, FALSE),
(303, 1,  'Metal',    '2024-03-01', 14.99, FALSE),
(304, 2,  'Standard', '2024-01-01',  0.00, FALSE),
(305, 2,  'Standard', '2024-02-01',  0.00, TRUE),   -- churned
(306, 3,  'Premium',  '2024-01-01',  7.99, FALSE),
(307, 3,  'Premium',  '2024-02-01',  7.99, FALSE),
(308, 3,  'Premium',  '2024-03-01',  7.99, FALSE),
(309, 4,  'Plus',     '2024-01-01',  3.99, FALSE),
(310, 4,  'Plus',     '2024-02-01',  3.99, TRUE),   -- churned
(311, 6,  'Metal',    '2024-01-01', 14.99, FALSE),
(312, 6,  'Metal',    '2024-02-01', 14.99, FALSE),
(313, 6,  'Metal',    '2024-03-01', 14.99, FALSE),
(314, 7,  'Ultra',    '2024-01-01', 45.00, FALSE),
(315, 7,  'Ultra',    '2024-02-01', 45.00, FALSE),
(316, 7,  'Ultra',    '2024-03-01', 45.00, FALSE),
(317, 11, 'Plus',     '2024-01-01',  3.99, FALSE),
(318, 11, 'Plus',     '2024-02-01',  3.99, FALSE),
(319, 11, 'Plus',     '2024-03-01',  3.99, FALSE),
(320, 12, 'Metal',    '2024-01-01', 14.99, FALSE),
(321, 12, 'Metal',    '2024-02-01', 14.99, FALSE),
(322, 12, 'Metal',    '2024-03-01', 14.99, FALSE),
(323, 14, 'Premium',  '2024-01-01',  7.99, FALSE),
(324, 14, 'Premium',  '2024-02-01',  7.99, TRUE),   -- churned
(325, 15, 'Ultra',    '2024-03-01', 45.00, FALSE);
