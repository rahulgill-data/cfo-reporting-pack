-- =============================================================================
-- BOOKING HOLDINGS (Booking.com) — DIMENSION DATA
-- Source: Booking Holdings 10-K FY2025 (filed February 2026, SEC EDGAR)
-- Amounts: EUR millions | FX: USD/EUR 1.08 avg 2025
-- Fiscal Year: Calendar year (Jan–Dec), standard for Booking Holdings
-- =============================================================================

-- Clear existing data
DELETE FROM dim_period;
DELETE FROM dim_department;
DELETE FROM dim_account;
DELETE FROM dim_entity;

-- -----------------------------------------------------------------------------
-- dim_period: FY2024 (prior year) + FY2025 (current year, Jan–Dec)
-- Booking Holdings reports on calendar year basis
-- -----------------------------------------------------------------------------
INSERT INTO dim_period VALUES
-- FY2024 Prior Year (Jan–Dec 2024)
(1,  2024, 1,  'Jan-2024', 'Q1-FY2024', 'FY2024', 1),
(2,  2024, 2,  'Feb-2024', 'Q1-FY2024', 'FY2024', 1),
(3,  2024, 3,  'Mar-2024', 'Q1-FY2024', 'FY2024', 1),
(4,  2024, 4,  'Apr-2024', 'Q2-FY2024', 'FY2024', 1),
(5,  2024, 5,  'May-2024', 'Q2-FY2024', 'FY2024', 1),
(6,  2024, 6,  'Jun-2024', 'Q2-FY2024', 'FY2024', 1),
(7,  2024, 7,  'Jul-2024', 'Q3-FY2024', 'FY2024', 1),
(8,  2024, 8,  'Aug-2024', 'Q3-FY2024', 'FY2024', 1),
(9,  2024, 9,  'Sep-2024', 'Q3-FY2024', 'FY2024', 1),
(10, 2024, 10, 'Oct-2024', 'Q4-FY2024', 'FY2024', 1),
(11, 2024, 11, 'Nov-2024', 'Q4-FY2024', 'FY2024', 1),
(12, 2024, 12, 'Dec-2024', 'Q4-FY2024', 'FY2024', 1),
-- FY2025 Current Year (Jan–Dec 2025)
-- Note: Q3 is peak season (summer travel) — highest revenue months
(13, 2025, 1,  'Jan-2025', 'Q1-FY2025', 'FY2025', 1),
(14, 2025, 2,  'Feb-2025', 'Q1-FY2025', 'FY2025', 1),
(15, 2025, 3,  'Mar-2025', 'Q1-FY2025', 'FY2025', 1),
(16, 2025, 4,  'Apr-2025', 'Q2-FY2025', 'FY2025', 1),
(17, 2025, 5,  'May-2025', 'Q2-FY2025', 'FY2025', 1),
(18, 2025, 6,  'Jun-2025', 'Q2-FY2025', 'FY2025', 1),
(19, 2025, 7,  'Jul-2025', 'Q3-FY2025', 'FY2025', 1),
(20, 2025, 8,  'Aug-2025', 'Q3-FY2025', 'FY2025', 1),
(21, 2025, 9,  'Sep-2025', 'Q3-FY2025', 'FY2025', 1),
(22, 2025, 10, 'Oct-2025', 'Q4-FY2025', 'FY2025', 0),
(23, 2025, 11, 'Nov-2025', 'Q4-FY2025', 'FY2025', 0),
(24, 2025, 12, 'Dec-2025', 'Q4-FY2025', 'FY2025', 0);

-- -----------------------------------------------------------------------------
-- dim_department: Booking Holdings organisational structure
-- Source: 10-K cost line structure + Booking.com public org info
-- -----------------------------------------------------------------------------
INSERT INTO dim_department VALUES
-- Commercial / Revenue-generating
(1, 'ACCOMM-EU',  'Accommodation EU',        'CC-1001', 'Commercial',   'Chief Commercial Officer', 1),
(2, 'ACCOMM-APAC','Accommodation APAC',       'CC-1002', 'Commercial',   'Chief Commercial Officer', 1),
(3, 'ACCOMM-AMER','Accommodation Americas',   'CC-1003', 'Commercial',   'Chief Commercial Officer', 1),
(4, 'PERF-MKTG',  'Performance Marketing',    'CC-2001', 'Marketing',    'Chief Marketing Officer',  1),
(5, 'BRAND-MKTG', 'Brand & Social Marketing', 'CC-2002', 'Marketing',    'Chief Marketing Officer',  1),
-- Operations
(6, 'CUST-OPS',   'Customer Operations',      'CC-3001', 'Operations',   'Chief Operating Officer',  1),
(7, 'PAYMENTS',   'Payments & Merchant Svcs', 'CC-3002', 'Operations',   'Chief Operating Officer',  1),
-- G&A
(8, 'FINANCE',    'Finance & Accounting',     'CC-4001', 'G&A',          'CFO',                      1),
(9, 'HR-PEOPLE',  'People & Organisation',    'CC-4002', 'G&A',          'Chief People Officer',     1),
(10,'TECH-IT',    'Technology & IT',          'CC-4003', 'G&A',          'CTO',                      1),
(11,'LEGAL-COMPL','Legal & Compliance',       'CC-4004', 'G&A',          'General Counsel',          1);

-- -----------------------------------------------------------------------------
-- dim_account: Booking Holdings chart of accounts
-- Mirrors actual 10-K income statement line items exactly
-- -----------------------------------------------------------------------------
INSERT INTO dim_account VALUES
-- Revenue lines (from 10-K: Merchant, Agency, Advertising & Other)
(1,  '4100', 'Merchant Revenue',           'Revenue',   'Merchant',            1, 'CREDIT'),
(2,  '4200', 'Agency Revenue',             'Revenue',   'Agency',              1, 'CREDIT'),
(3,  '4300', 'Advertising & Other Rev',    'Revenue',   'Advertising',         1, 'CREDIT'),
-- Cost of Revenue / COGS (Sales & Other from 10-K)
(4,  '5100', 'Merchant Transaction Costs', 'COGS',      'Payment Processing',  1, 'DEBIT'),
(5,  '5200', 'Customer Service Costs',     'COGS',      'Customer Ops',        1, 'DEBIT'),
(6,  '5300', 'Credit Loss Provision',      'COGS',      'Risk & Fraud',        1, 'DEBIT'),
-- Marketing (largest single cost line — ~30% of revenue)
(7,  '6100', 'Performance Marketing',      'Marketing', 'Paid Search/Meta',    1, 'DEBIT'),
(8,  '6200', 'Brand & Social Marketing',   'Marketing', 'Brand Awareness',     1, 'DEBIT'),
-- Personnel (12.6% of revenue per 10-K)
(9,  '7100', 'Salaries & Wages',           'Headcount', 'Compensation',        1, 'DEBIT'),
(10, '7200', 'Bonus & Incentives',         'Headcount', 'Compensation',        1, 'DEBIT'),
(11, '7300', 'Stock-Based Compensation',   'Headcount', 'Equity Comp',         1, 'DEBIT'),
(12, '7400', 'Employer Benefits & NI',     'Headcount', 'Benefits',            1, 'DEBIT'),
-- G&A and Tech (from 10-K)
(13, '8100', 'General & Administrative',   'Opex',      'G&A',                 1, 'DEBIT'),
(14, '8200', 'Information Technology',     'Opex',      'Technology',          1, 'DEBIT'),
(15, '8300', 'Depreciation & Amort',       'Opex',      'Non-Cash',            1, 'DEBIT'),
(16, '8400', 'Transformation Costs',       'Opex',      'Restructuring',       1, 'DEBIT');

-- -----------------------------------------------------------------------------
-- dim_entity: Booking Holdings legal entities / reporting segments
-- Source: 10-K geographic revenue disclosure
-- Netherlands = 80.6% of revenue ($21.7B of $26.9B)
-- USA = 9.6% ($2.58B) | APAC remainder | others
-- -----------------------------------------------------------------------------
INSERT INTO dim_entity VALUES
(1, 'NL-BKNG',  'Booking.com BV (Netherlands HQ)', 'Netherlands', 'EUR', 'EMEA'),
(2, 'US-BKNG',  'Booking Holdings Inc. (US)',       'USA',         'USD', 'Americas'),
(3, 'SG-AGODA', 'Agoda (Singapore / APAC)',         'Singapore',   'SGD', 'APAC'),
(4, 'UK-BKNG',  'Booking.com UK',                  'UK',          'GBP', 'EMEA');
