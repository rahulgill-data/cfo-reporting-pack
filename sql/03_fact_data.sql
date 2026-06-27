-- =============================================================================
-- BOOKING HOLDINGS — FACT FINANCIAL DATA
-- Source: Booking Holdings 10-K FY2025 (SEC EDGAR, filed February 2026)
--         Q3 2025 Earnings Release (SEC 8-K)
-- All amounts in EUR millions (USD converted at 1.08 avg 2025 rate)
-- =============================================================================
-- KEY ANNUAL FIGURES (EUR millions, converted from USD at 1.08):
--   FY2025 Revenue:  €24,926M  |  FY2024 Revenue: €21,981M  (+13.4% YoY)
--   FY2025 Marketing: €7,593M  |  FY2024: €6,741M  (30.4% of rev both years)
--   FY2025 Personnel: €3,151M  |  FY2024: €3,106M  (12.6% vs 14.1%)
--   FY2025 Op Income: €8,786M  |  FY2024: €6,996M  (35.3% vs 29.5% margin)
--   Headcount 2025: 24,300  |  2024: 24,200
--
-- SEASONALITY (critical for Booking.com — 10-K explicitly notes this):
--   Q1 (Jan-Mar): Lowest revenue, highest losses — booking window effect
--   Q2 (Apr-Jun): Building — summer travel bookings peak
--   Q3 (Jul-Sep): HIGHEST revenue — peak summer travel check-ins
--   Q4 (Oct-Dec): Declining — off-peak, but holiday spike in Dec
--
-- Monthly revenue split approximation from quarterly 8-K disclosures:
--   Q1 2025: €4,409M total  |  Q2: €6,400M  |  Q3: €8,341M  |  Q4: est.€5,776M
-- =============================================================================

-- =============================================================================
-- MERCHANT REVENUE — account_id 1 | Primary revenue driver (66% of total)
-- Mostly Booking.com NL entity (80%+ of group revenue)
-- =============================================================================

-- FY2025 BUDGET — Merchant Revenue (set at start of year, before actuals)
-- Budget assumed 12% growth on FY2024 merchant base of €13,093M
INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
-- NL entity — EU Accommodation (dept 1)
(13,1,1,1,'BUDGET',780),(14,1,1,1,'BUDGET',820),(15,1,1,1,'BUDGET',980),
(16,1,1,1,'BUDGET',1180),(17,1,1,1,'BUDGET',1350),(18,1,1,1,'BUDGET',1520),
(19,1,1,1,'BUDGET',1780),(20,1,1,1,'BUDGET',1820),(21,1,1,1,'BUDGET',1650),
(22,1,1,1,'BUDGET',1200),(23,1,1,1,'BUDGET',1050),(24,1,1,1,'BUDGET',1120),
-- APAC entity — Agoda (dept 2)
(13,2,1,3,'BUDGET',180),(14,2,1,3,'BUDGET',190),(15,2,1,3,'BUDGET',240),
(16,2,1,3,'BUDGET',290),(17,2,1,3,'BUDGET',330),(18,2,1,3,'BUDGET',360),
(19,2,1,3,'BUDGET',420),(20,2,1,3,'BUDGET',430),(21,2,1,3,'BUDGET',390),
(22,2,1,3,'BUDGET',285),(23,2,1,3,'BUDGET',260),(24,2,1,3,'BUDGET',270),
-- Americas (dept 3, US entity)
(13,3,1,2,'BUDGET',110),(14,3,1,2,'BUDGET',115),(15,3,1,2,'BUDGET',140),
(16,3,1,2,'BUDGET',165),(17,3,1,2,'BUDGET',190),(18,3,1,2,'BUDGET',210),
(19,3,1,2,'BUDGET',245),(20,3,1,2,'BUDGET',250),(21,3,1,2,'BUDGET',225),
(22,3,1,2,'BUDGET',170),(23,3,1,2,'BUDGET',148),(24,3,1,2,'BUDGET',157);

-- FY2025 ACTUALS — Merchant Revenue
-- EU: performing above budget driven by connected trip & merchant shift
-- APAC: Agoda strong YoY but slight miss vs aggressive budget in peak months
-- Americas: broadly on budget
INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
-- NL EU Accommodation ACTUAL
(13,1,1,1,'ACTUAL',798),(14,1,1,1,'ACTUAL',842),(15,1,1,1,'ACTUAL',1005),
(16,1,1,1,'ACTUAL',1212),(17,1,1,1,'ACTUAL',1398),(18,1,1,1,'ACTUAL',1565),
(19,1,1,1,'ACTUAL',1850),(20,1,1,1,'ACTUAL',1895),(21,1,1,1,'ACTUAL',1710),
-- APAC Agoda ACTUAL — Q3 miss vs budget (APAC macro softness story)
(13,2,1,3,'ACTUAL',185),(14,2,1,3,'ACTUAL',196),(15,2,1,3,'ACTUAL',248),
(16,2,1,3,'ACTUAL',298),(17,2,1,3,'ACTUAL',338),(18,2,1,3,'ACTUAL',355),
(19,2,1,3,'ACTUAL',398),(20,2,1,3,'ACTUAL',408),(21,2,1,3,'ACTUAL',365),
-- Americas ACTUAL
(13,3,1,2,'ACTUAL',108),(14,3,1,2,'ACTUAL',112),(15,3,1,2,'ACTUAL',138),
(16,3,1,2,'ACTUAL',162),(17,3,1,2,'ACTUAL',188),(18,3,1,2,'ACTUAL',207),
(19,3,1,2,'ACTUAL',242),(20,3,1,2,'ACTUAL',248),(21,3,1,2,'ACTUAL',221);

-- FY2024 PRIOR YEAR — Merchant Revenue (from 10-K: $14,142M = €13,093M total)
-- Seasonal distribution based on 8-K quarterly disclosures
INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
(1,1,1,1,'PRIOR_YEAR',582),(2,1,1,1,'PRIOR_YEAR',612),(3,1,1,1,'PRIOR_YEAR',745),
(4,1,1,1,'PRIOR_YEAR',910),(5,1,1,1,'PRIOR_YEAR',1040),(6,1,1,1,'PRIOR_YEAR',1170),
(7,1,1,1,'PRIOR_YEAR',1385),(8,1,1,1,'PRIOR_YEAR',1410),(9,1,1,1,'PRIOR_YEAR',1280),
(10,1,1,1,'PRIOR_YEAR',940),(11,1,1,1,'PRIOR_YEAR',820),(12,1,1,1,'PRIOR_YEAR',875),
(1,2,1,3,'PRIOR_YEAR',138),(2,2,1,3,'PRIOR_YEAR',145),(3,2,1,3,'PRIOR_YEAR',182),
(4,2,1,3,'PRIOR_YEAR',224),(5,2,1,3,'PRIOR_YEAR',258),(6,2,1,3,'PRIOR_YEAR',285),
(7,2,1,3,'PRIOR_YEAR',335),(8,2,1,3,'PRIOR_YEAR',342),(9,2,1,3,'PRIOR_YEAR',310),
(10,2,1,3,'PRIOR_YEAR',228),(11,2,1,3,'PRIOR_YEAR',198),(12,2,1,3,'PRIOR_YEAR',212);

-- =============================================================================
-- AGENCY REVENUE — account_id 2 | Declining segment (shift to merchant)
-- FY2025: €7,378M | FY2024: €7,889M (-6.5% — structural decline)
-- =============================================================================

INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
-- Agency BUDGET (assumed flat vs 2024 — management didn't budget the decline)
(13,1,2,1,'BUDGET',410),(14,1,2,1,'BUDGET',430),(15,1,2,1,'BUDGET',510),
(16,1,2,1,'BUDGET',620),(17,1,2,1,'BUDGET',710),(18,1,2,1,'BUDGET',800),
(19,1,2,1,'BUDGET',940),(20,1,2,1,'BUDGET',960),(21,1,2,1,'BUDGET',860),
(22,1,2,1,'BUDGET',620),(23,1,2,1,'BUDGET',540),(24,1,2,1,'BUDGET',580),
-- Agency ACTUAL — structurally below budget (faster merchant shift)
(13,1,2,1,'ACTUAL',365),(14,1,2,1,'ACTUAL',382),(15,1,2,1,'ACTUAL',455),
(16,1,2,1,'ACTUAL',548),(17,1,2,1,'ACTUAL',625),(18,1,2,1,'ACTUAL',702),
(19,1,2,1,'ACTUAL',828),(20,1,2,1,'ACTUAL',845),(21,1,2,1,'ACTUAL',758),
-- Agency PRIOR YEAR 2024 ($8,524M = €7,889M)
(1,1,2,1,'PRIOR_YEAR',398),(2,1,2,1,'PRIOR_YEAR',418),(3,1,2,1,'PRIOR_YEAR',498),
(4,1,2,1,'PRIOR_YEAR',610),(5,1,2,1,'PRIOR_YEAR',698),(6,1,2,1,'PRIOR_YEAR',785),
(7,1,2,1,'PRIOR_YEAR',925),(8,1,2,1,'PRIOR_YEAR',942),(9,1,2,1,'PRIOR_YEAR',850),
(10,1,2,1,'PRIOR_YEAR',610),(11,1,2,1,'PRIOR_YEAR',532),(12,1,2,1,'PRIOR_YEAR',570);

-- =============================================================================
-- ADVERTISING & OTHER REVENUE — account_id 3
-- KAYAK referrals + OpenTable subscriptions
-- FY2025: €1,106M | FY2024: €993M (+11.3% YoY)
-- =============================================================================

INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
-- Budget (10% growth assumed on FY2024 base)
(13,1,3,2,'BUDGET',68),(14,1,3,2,'BUDGET',70),(15,1,3,2,'BUDGET',82),
(16,1,3,2,'BUDGET',95),(17,1,3,2,'BUDGET',105),(18,1,3,2,'BUDGET',112),
(19,1,3,2,'BUDGET',118),(20,1,3,2,'BUDGET',120),(21,1,3,2,'BUDGET',108),
(22,1,3,2,'BUDGET',88),(23,1,3,2,'BUDGET',82),(24,1,3,2,'BUDGET',85),
-- Actual (came in slightly above budget — OpenTable growth)
(13,1,3,2,'ACTUAL',72),(14,1,3,2,'ACTUAL',74),(15,1,3,2,'ACTUAL',87),
(16,1,3,2,'ACTUAL',100),(17,1,3,2,'ACTUAL',112),(18,1,3,2,'ACTUAL',118),
(19,1,3,2,'ACTUAL',125),(20,1,3,2,'ACTUAL',128),(21,1,3,2,'ACTUAL',115),
-- Prior year 2024 ($1,073M = €993M)
(1,1,3,2,'PRIOR_YEAR',61),(2,1,3,2,'PRIOR_YEAR',63),(3,1,3,2,'PRIOR_YEAR',74),
(4,1,3,2,'PRIOR_YEAR',86),(5,1,3,2,'PRIOR_YEAR',95),(6,1,3,2,'PRIOR_YEAR',102),
(7,1,3,2,'PRIOR_YEAR',107),(8,1,3,2,'PRIOR_YEAR',109),(9,1,3,2,'PRIOR_YEAR',98),
(10,1,3,2,'PRIOR_YEAR',80),(11,1,3,2,'PRIOR_YEAR',74),(12,1,3,2,'PRIOR_YEAR',78);

-- =============================================================================
-- PERFORMANCE MARKETING — account_id 7 | Largest cost line
-- FY2025: €7,593M total marketing | ~85% is performance (paid search, meta)
-- Performance marketing = €6,454M | Brand = €1,139M
-- Seasonal: peaks in Q2/Q3 ahead of summer bookings (leading indicator)
-- =============================================================================

INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
-- Performance Marketing BUDGET
(13,4,7,1,'BUDGET',370),(14,4,7,1,'BUDGET',390),(15,4,7,1,'BUDGET',480),
(16,4,7,1,'BUDGET',620),(17,4,7,1,'BUDGET',720),(18,4,7,1,'BUDGET',780),
(19,4,7,1,'BUDGET',850),(20,4,7,1,'BUDGET',860),(21,4,7,1,'BUDGET',720),
(22,4,7,1,'BUDGET',520),(23,4,7,1,'BUDGET',445),(24,4,7,1,'BUDGET',480),
-- Performance Marketing ACTUAL — over budget in Q1 (brand push) / Q3 (social media)
(13,4,7,1,'ACTUAL',388),(14,4,7,1,'ACTUAL',412),(15,4,7,1,'ACTUAL',502),
(16,4,7,1,'ACTUAL',645),(17,4,7,1,'ACTUAL',748),(18,4,7,1,'ACTUAL',808),
(19,4,7,1,'ACTUAL',892),(20,4,7,1,'ACTUAL',905),(21,4,7,1,'ACTUAL',755),
-- Prior year 2024 (85% of $6,741M = $5,730M = €5,306M performance)
(1,4,7,1,'PRIOR_YEAR',328),(2,4,7,1,'PRIOR_YEAR',345),(3,4,7,1,'PRIOR_YEAR',425),
(4,4,7,1,'PRIOR_YEAR',548),(5,4,7,1,'PRIOR_YEAR',638),(6,4,7,1,'PRIOR_YEAR',692),
(7,4,7,1,'PRIOR_YEAR',755),(8,4,7,1,'PRIOR_YEAR',768),(9,4,7,1,'PRIOR_YEAR',640),
(10,4,7,1,'PRIOR_YEAR',462),(11,4,7,1,'PRIOR_YEAR',395),(12,4,7,1,'PRIOR_YEAR',422);

-- Brand Marketing BUDGET + ACTUAL + PY
INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
(13,5,8,1,'BUDGET',62),(14,5,8,1,'BUDGET',65),(15,5,8,1,'BUDGET',78),
(16,5,8,1,'BUDGET',92),(17,5,8,1,'BUDGET',105),(18,5,8,1,'BUDGET',118),
(19,5,8,1,'BUDGET',128),(20,5,8,1,'BUDGET',130),(21,5,8,1,'BUDGET',112),
(22,5,8,1,'BUDGET',88),(23,5,8,1,'BUDGET',78),(24,5,8,1,'BUDGET',82),
(13,5,8,1,'ACTUAL',65),(14,5,8,1,'ACTUAL',68),(15,5,8,1,'ACTUAL',82),
(16,5,8,1,'ACTUAL',98),(17,5,8,1,'ACTUAL',112),(18,5,8,1,'ACTUAL',125),
(19,5,8,1,'ACTUAL',138),(20,5,8,1,'ACTUAL',142),(21,5,8,1,'ACTUAL',118),
(1,5,8,1,'PRIOR_YEAR',55),(2,5,8,1,'PRIOR_YEAR',58),(3,5,8,1,'PRIOR_YEAR',72),
(4,5,8,1,'PRIOR_YEAR',88),(5,5,8,1,'PRIOR_YEAR',100),(6,5,8,1,'PRIOR_YEAR',112),
(7,5,8,1,'PRIOR_YEAR',122),(8,5,8,1,'PRIOR_YEAR',125),(9,5,8,1,'PRIOR_YEAR',105),
(10,5,8,1,'PRIOR_YEAR',78),(11,5,8,1,'PRIOR_YEAR',68),(12,5,8,1,'PRIOR_YEAR',72);

-- =============================================================================
-- PERSONNEL — accounts 9,10,11,12 | FY2025: €3,151M (24,300 headcount)
-- Spread across Tech/IT (largest), Customer Ops, Finance, HR, Legal
-- =============================================================================

INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount,headcount) VALUES
-- Technology & IT (dept 10) — largest headcount group (~40% of total)
-- ~9,700 FTEs, avg cost €325k/FTE annualised
(13,10,9,1,'BUDGET',218,9700),(14,10,9,1,'BUDGET',218,9700),(15,10,9,1,'BUDGET',222,9700),
(16,10,9,1,'BUDGET',225,9800),(17,10,9,1,'BUDGET',225,9800),(18,10,9,1,'BUDGET',225,9800),
(19,10,9,1,'BUDGET',228,9900),(20,10,9,1,'BUDGET',228,9900),(21,10,9,1,'BUDGET',228,9900),
(13,10,9,1,'ACTUAL',221,9680),(14,10,9,1,'ACTUAL',220,9680),(15,10,9,1,'ACTUAL',224,9720),
(16,10,9,1,'ACTUAL',228,9750),(17,10,9,1,'ACTUAL',230,9780),(18,10,9,1,'ACTUAL',229,9800),
(19,10,9,1,'ACTUAL',232,9850),(20,10,9,1,'ACTUAL',234,9850),(21,10,9,1,'ACTUAL',231,9820),
(1,10,9,1,'PRIOR_YEAR',208),(2,10,9,1,'PRIOR_YEAR',208),(3,10,9,1,'PRIOR_YEAR',210),
(4,10,9,1,'PRIOR_YEAR',212),(5,10,9,1,'PRIOR_YEAR',213),(6,10,9,1,'PRIOR_YEAR',213),
(7,10,9,1,'PRIOR_YEAR',215),(8,10,9,1,'PRIOR_YEAR',215),(9,10,9,1,'PRIOR_YEAR',215),
(10,10,9,1,'PRIOR_YEAR',212),(11,10,9,1,'PRIOR_YEAR',210),(12,10,9,1,'PRIOR_YEAR',211),
-- Customer Operations (dept 6) — ~5,800 FTEs
(13,6,9,1,'BUDGET',128,5800),(14,6,9,1,'BUDGET',128,5800),(15,6,9,1,'BUDGET',130,5800),
(16,6,9,1,'BUDGET',132,5850),(17,6,9,1,'BUDGET',132,5850),(18,6,9,1,'BUDGET',132,5850),
(19,6,9,1,'BUDGET',135,5900),(20,6,9,1,'BUDGET',135,5900),(21,6,9,1,'BUDGET',135,5900),
(13,6,9,1,'ACTUAL',126,5780),(14,6,9,1,'ACTUAL',127,5780),(15,6,9,1,'ACTUAL',128,5790),
(16,6,9,1,'ACTUAL',130,5810),(17,6,9,1,'ACTUAL',131,5820),(18,6,9,1,'ACTUAL',130,5820),
(19,6,9,1,'ACTUAL',133,5840),(20,6,9,1,'ACTUAL',132,5830),(21,6,9,1,'ACTUAL',131,5820),
-- Finance (dept 8) — ~1,200 FTEs
(13,8,9,1,'BUDGET',28,1200),(14,8,9,1,'BUDGET',28,1200),(15,8,9,1,'BUDGET',28,1200),
(16,8,9,1,'BUDGET',29,1200),(17,8,9,1,'BUDGET',29,1200),(18,8,9,1,'BUDGET',29,1200),
(19,8,9,1,'BUDGET',30,1250),(20,8,9,1,'BUDGET',30,1250),(21,8,9,1,'BUDGET',30,1250),
(13,8,9,1,'ACTUAL',27,1195),(14,8,9,1,'ACTUAL',27,1195),(15,8,9,1,'ACTUAL',28,1200),
(16,8,9,1,'ACTUAL',28,1200),(17,8,9,1,'ACTUAL',28,1200),(18,8,9,1,'ACTUAL',29,1210),
(19,8,9,1,'ACTUAL',29,1220),(20,8,9,1,'ACTUAL',30,1220),(21,8,9,1,'ACTUAL',30,1215);

-- =============================================================================
-- SALES & OTHER EXPENSES (COGS) — accounts 4,5,6
-- FY2025: €3,194M | Growing with merchant shift
-- =============================================================================

INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
-- Merchant Transaction Costs (account 4) — grows with merchant revenue shift
(13,7,4,1,'BUDGET',145),(14,7,4,1,'BUDGET',152),(15,7,4,1,'BUDGET',185),
(16,7,4,1,'BUDGET',225),(17,7,4,1,'BUDGET',258),(18,7,4,1,'BUDGET',292),
(19,7,4,1,'BUDGET',342),(20,7,4,1,'BUDGET',348),(21,7,4,1,'BUDGET',315),
(22,7,4,1,'BUDGET',228),(23,7,4,1,'BUDGET',198),(24,7,4,1,'BUDGET',212),
-- Actual — higher than budget due to faster merchant shift
(13,7,4,1,'ACTUAL',158),(14,7,4,1,'ACTUAL',165),(15,7,4,1,'ACTUAL',202),
(16,7,4,1,'ACTUAL',245),(17,7,4,1,'ACTUAL',282),(18,7,4,1,'ACTUAL',318),
(19,7,4,1,'ACTUAL',375),(20,7,4,1,'ACTUAL',382),(21,7,4,1,'ACTUAL',345),
-- Prior year 2024
(1,7,4,1,'PRIOR_YEAR',118),(2,7,4,1,'PRIOR_YEAR',124),(3,7,4,1,'PRIOR_YEAR',152),
(4,7,4,1,'PRIOR_YEAR',185),(5,7,4,1,'PRIOR_YEAR',212),(6,7,4,1,'PRIOR_YEAR',240),
(7,7,4,1,'PRIOR_YEAR',282),(8,7,4,1,'PRIOR_YEAR',288),(9,7,4,1,'PRIOR_YEAR',260),
(10,7,4,1,'PRIOR_YEAR',188),(11,7,4,1,'PRIOR_YEAR',163),(12,7,4,1,'PRIOR_YEAR',175);

-- =============================================================================
-- G&A AND IT OPEX — accounts 13,14,15
-- G&A FY2025: €794M (down from €959M — Italian tax settlement in 2024)
-- IT FY2025: €787M | D&A: €593M
-- =============================================================================

INSERT INTO fact_financials (period_id,dept_id,account_id,entity_id,scenario,amount) VALUES
-- G&A (account 13) — BUDGET assumed flat €959M/12 monthly
(13,8,13,1,'BUDGET',80),(14,8,13,1,'BUDGET',80),(15,8,13,1,'BUDGET',80),
(16,8,13,1,'BUDGET',80),(17,8,13,1,'BUDGET',80),(18,8,13,1,'BUDGET',80),
(19,8,13,1,'BUDGET',80),(20,8,13,1,'BUDGET',80),(21,8,13,1,'BUDGET',80),
(22,8,13,1,'BUDGET',80),(23,8,13,1,'BUDGET',80),(24,8,13,1,'BUDGET',80),
-- G&A ACTUAL — lower than budget (Italian tax accrual was 2024 one-off)
(13,8,13,1,'ACTUAL',62),(14,8,13,1,'ACTUAL',62),(15,8,13,1,'ACTUAL',65),
(16,8,13,1,'ACTUAL',65),(17,8,13,1,'ACTUAL',68),(18,8,13,1,'ACTUAL',68),
(19,8,13,1,'ACTUAL',70),(20,8,13,1,'ACTUAL',70),(21,8,13,1,'ACTUAL',68),
-- G&A PRIOR YEAR 2024 ($1,036M = €959M — included Italian tax €312M)
(1,8,13,1,'PRIOR_YEAR',62),(2,8,13,1,'PRIOR_YEAR',62),(3,8,13,1,'PRIOR_YEAR',62),
(4,8,13,1,'PRIOR_YEAR',65),(5,8,13,1,'PRIOR_YEAR',65),(6,8,13,1,'PRIOR_YEAR',68),
(7,8,13,1,'PRIOR_YEAR',68),(8,8,13,1,'PRIOR_YEAR',68),(9,8,13,1,'PRIOR_YEAR',68),
(10,8,13,1,'PRIOR_YEAR',150),(11,8,13,1,'PRIOR_YEAR',65),(12,8,13,1,'PRIOR_YEAR',68),
-- IT Expenses (account 14)
(13,10,14,1,'BUDGET',62),(14,10,14,1,'BUDGET',62),(15,10,14,1,'BUDGET',65),
(16,10,14,1,'BUDGET',65),(17,10,14,1,'BUDGET',68),(18,10,14,1,'BUDGET',68),
(19,10,14,1,'BUDGET',72),(20,10,14,1,'BUDGET',72),(21,10,14,1,'BUDGET',72),
(22,10,14,1,'BUDGET',72),(23,10,14,1,'BUDGET',72),(24,10,14,1,'BUDGET',72),
(13,10,14,1,'ACTUAL',64),(14,10,14,1,'ACTUAL',65),(15,10,14,1,'ACTUAL',68),
(16,10,14,1,'ACTUAL',68),(17,10,14,1,'ACTUAL',70),(18,10,14,1,'ACTUAL',71),
(19,10,14,1,'ACTUAL',76),(20,10,14,1,'ACTUAL',78),(21,10,14,1,'ACTUAL',75),
(1,10,14,1,'PRIOR_YEAR',54),(2,10,14,1,'PRIOR_YEAR',54),(3,10,14,1,'PRIOR_YEAR',56),
(4,10,14,1,'PRIOR_YEAR',56),(5,10,14,1,'PRIOR_YEAR',58),(6,10,14,1,'PRIOR_YEAR',58),
(7,10,14,1,'PRIOR_YEAR',62),(8,10,14,1,'PRIOR_YEAR',62),(9,10,14,1,'PRIOR_YEAR',62),
(10,10,14,1,'PRIOR_YEAR',60),(11,10,14,1,'PRIOR_YEAR',58),(12,10,14,1,'PRIOR_YEAR',58);
