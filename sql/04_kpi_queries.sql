-- =============================================================================
-- CFO MONTHLY REPORTING PACK — BOOKING HOLDINGS (Booking.com)
-- File: 04_kpi_queries.sql
-- Author: Rahul Gill | CA (AIR 39) | Lancaster MBA 2026
-- Source: Booking Holdings 10-K FY2025 (SEC EDGAR, filed February 2026)
-- Description: 5 CFO-grade KPI queries on Booking.com financials
-- Currency: EUR millions | FX: USD/EUR 1.08 avg 2025
-- Run each query separately by selecting it and pressing Cmd+E in VS Code
-- =============================================================================


-- =============================================================================
-- KPI 1: REVENUE BRIDGE — Actual vs Budget vs Prior Year (YTD Jan–Sep 2025)
-- CFO question: "How much revenue did we make, vs what we planned,
--               vs the same period last year?"
-- =============================================================================

SELECT
    f.scenario,
    a.sub_category                      AS revenue_type,
    ROUND(SUM(f.amount), 0)             AS eur_millions,
    ROUND(SUM(f.amount) / 1000.0, 2)   AS eur_billions
FROM fact_financials f
JOIN dim_account a ON f.account_id = a.account_id
JOIN dim_period  p ON f.period_id  = p.period_id
WHERE a.category         = 'Revenue'
  AND p.fiscal_month BETWEEN 1 AND 9
GROUP BY f.scenario, a.sub_category
ORDER BY
    CASE f.scenario
        WHEN 'ACTUAL'     THEN 1
        WHEN 'BUDGET'     THEN 2
        WHEN 'PRIOR_YEAR' THEN 3
    END,
    a.sub_category;


-- =============================================================================
-- KPI 2: MARKETING EFFICIENCY — Monthly revenue vs marketing spend
-- CFO question: "For every euro we spend on marketing,
--               how much revenue are we generating?"
-- Booking.com internal benchmark: marketing should stay under 30% of revenue
-- =============================================================================

WITH monthly_marketing AS (
    SELECT
        p.period_name,
        p.fiscal_month,
        f.scenario,
        SUM(f.amount) AS marketing_spend
    FROM fact_financials f
    JOIN dim_account a ON f.account_id = a.account_id
    JOIN dim_period  p ON f.period_id  = p.period_id
    WHERE a.category = 'Marketing'
      AND p.fiscal_month BETWEEN 1 AND 9
    GROUP BY p.period_name, p.fiscal_month, f.scenario
),
monthly_revenue AS (
    SELECT
        p.fiscal_month,
        f.scenario,
        SUM(f.amount) AS revenue
    FROM fact_financials f
    JOIN dim_account a ON f.account_id = a.account_id
    JOIN dim_period  p ON f.period_id  = p.period_id
    WHERE a.category = 'Revenue'
      AND p.fiscal_month BETWEEN 1 AND 9
    GROUP BY p.fiscal_month, f.scenario
)
SELECT
    m.period_name,
    m.scenario,
    ROUND(m.marketing_spend, 0)                              AS marketing_eur_m,
    ROUND(r.revenue, 0)                                      AS revenue_eur_m,
    ROUND(m.marketing_spend / r.revenue * 100, 1)           AS marketing_pct_of_revenue,
    ROUND(r.revenue / m.marketing_spend, 2)                 AS revenue_per_eur_marketing,
    CASE
        WHEN m.marketing_spend / r.revenue * 100 > 30
        THEN 'Above 30% target'
        ELSE 'Within target'
    END                                                      AS efficiency_flag
FROM monthly_marketing m
JOIN monthly_revenue   r
    ON m.scenario = r.scenario AND m.fiscal_month = r.fiscal_month
WHERE m.scenario = 'ACTUAL'
ORDER BY m.fiscal_month;


-- =============================================================================
-- KPI 3: MERCHANT vs AGENCY REVENUE MIX — Monthly trend FY2025
-- CFO question: "Is our strategic shift from agency to merchant on track?"
-- Context: Merchant = higher quality, more predictable revenue
--          Agency = traditional model, structurally declining
-- =============================================================================

SELECT
    p.period_name,
    ROUND(SUM(CASE WHEN a.sub_category = 'Merchant'
                   THEN f.amount ELSE 0 END), 0)            AS merchant_eur_m,
    ROUND(SUM(CASE WHEN a.sub_category = 'Agency'
                   THEN f.amount ELSE 0 END), 0)            AS agency_eur_m,
    ROUND(SUM(CASE WHEN a.sub_category = 'Advertising'
                   THEN f.amount ELSE 0 END), 0)            AS advertising_eur_m,
    ROUND(SUM(CASE WHEN a.category = 'Revenue'
                   THEN f.amount ELSE 0 END), 0)            AS total_revenue_eur_m,
    ROUND(
        SUM(CASE WHEN a.sub_category = 'Merchant' THEN f.amount ELSE 0 END) /
        NULLIF(SUM(CASE WHEN a.category = 'Revenue' THEN f.amount ELSE 0 END), 0)
        * 100, 1)                                           AS merchant_share_pct,
    ROUND(
        SUM(CASE WHEN a.sub_category = 'Agency' THEN f.amount ELSE 0 END) /
        NULLIF(SUM(CASE WHEN a.category = 'Revenue' THEN f.amount ELSE 0 END), 0)
        * 100, 1)                                           AS agency_share_pct
FROM fact_financials f
JOIN dim_account a ON f.account_id = a.account_id
JOIN dim_period  p ON f.period_id  = p.period_id
WHERE f.scenario       = 'ACTUAL'
  AND p.fiscal_month BETWEEN 1 AND 9
  AND a.category       = 'Revenue'
GROUP BY p.period_name, p.fiscal_month
ORDER BY p.fiscal_month;


-- =============================================================================
-- KPI 4: HEADCOUNT COST PER FTE — by Department (YTD annualised)
-- CFO question: "How much are we spending per person in each department,
--               and is it within budget?"
-- =============================================================================

SELECT
    d.dept_name,
    d.function_group,
    d.budget_owner,
    f.scenario,
    ROUND(SUM(f.amount), 0)                                 AS total_people_cost_eur_m,
    ROUND(AVG(NULLIF(f.headcount, 0)), 0)                   AS average_headcount,
    ROUND(
        SUM(f.amount) /
        NULLIF(AVG(NULLIF(f.headcount, 0)), 0)
        / 9 * 12 * 1000, 0)                                AS annualised_cost_per_fte_eur_k
FROM fact_financials f
JOIN dim_department d ON f.dept_id    = d.dept_id
JOIN dim_account    a ON f.account_id = a.account_id
JOIN dim_period     p ON f.period_id  = p.period_id
WHERE a.category         = 'Headcount'
  AND p.fiscal_month BETWEEN 1 AND 9
  AND f.scenario         = 'ACTUAL'
  AND f.headcount        > 0
GROUP BY d.dept_name, d.function_group, d.budget_owner, f.scenario
ORDER BY annualised_cost_per_fte_eur_k DESC;


-- =============================================================================
-- KPI 5: REVENUE BY REGION — Actual vs Budget vs Prior Year
-- CFO question: "Which parts of the world are growing,
--               which are missing plan, and by how much?"
-- Context: Netherlands = 80.6% of total revenue per 10-K geographic segment
-- =============================================================================

SELECT
    e.region,
    e.entity_name,
    e.country,
    ROUND(SUM(CASE WHEN f.scenario = 'ACTUAL'
                   THEN f.amount ELSE 0 END), 0)            AS actual_eur_m,
    ROUND(SUM(CASE WHEN f.scenario = 'BUDGET'
                   THEN f.amount ELSE 0 END), 0)            AS budget_eur_m,
    ROUND(SUM(CASE WHEN f.scenario = 'PRIOR_YEAR'
                   THEN f.amount ELSE 0 END), 0)            AS prior_year_eur_m,
    ROUND(
        (SUM(CASE WHEN f.scenario = 'ACTUAL' THEN f.amount ELSE 0 END) -
         SUM(CASE WHEN f.scenario = 'BUDGET' THEN f.amount ELSE 0 END)) /
        NULLIF(SUM(CASE WHEN f.scenario = 'BUDGET' THEN f.amount ELSE 0 END), 0)
        * 100, 1)                                           AS vs_budget_pct,
    ROUND(
        (SUM(CASE WHEN f.scenario = 'ACTUAL'     THEN f.amount ELSE 0 END) -
         SUM(CASE WHEN f.scenario = 'PRIOR_YEAR' THEN f.amount ELSE 0 END)) /
        NULLIF(SUM(CASE WHEN f.scenario = 'PRIOR_YEAR' THEN f.amount ELSE 0 END), 0)
        * 100, 1)                                           AS yoy_growth_pct,
    CASE
        WHEN SUM(CASE WHEN f.scenario = 'ACTUAL' THEN f.amount ELSE 0 END) >=
             SUM(CASE WHEN f.scenario = 'BUDGET' THEN f.amount ELSE 0 END)
        THEN 'On or above budget'
        WHEN SUM(CASE WHEN f.scenario = 'ACTUAL' THEN f.amount ELSE 0 END) >=
             SUM(CASE WHEN f.scenario = 'BUDGET' THEN f.amount ELSE 0 END) * 0.97
        THEN 'Within 3 percent of budget'
        ELSE 'More than 3 percent below budget'
    END                                                     AS performance_status
FROM fact_financials f
JOIN dim_entity  e ON f.entity_id  = e.entity_id
JOIN dim_account a ON f.account_id = a.account_id
JOIN dim_period  p ON f.period_id  = p.period_id
WHERE a.category       = 'Revenue'
  AND p.fiscal_month BETWEEN 1 AND 9
GROUP BY e.region, e.entity_name, e.country
HAVING SUM(CASE WHEN f.scenario = 'ACTUAL' THEN f.amount ELSE 0 END) > 0
ORDER BY actual_eur_m DESC;
