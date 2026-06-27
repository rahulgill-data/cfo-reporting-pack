# =============================================================================
# CFO MONTHLY REPORTING PACK — BOOKING HOLDINGS (Booking.com)
# File: variance_engine.py  |  Layer 2 — Python Variance Engine
# Author: Rahul Gill | CA (AIR 39) | Lancaster MBA 2026
# Source: Booking Holdings 10-K FY2025 (SEC EDGAR, filed February 2026)
#
# What this script does (in plain English):
#   1. Connects to the database built in Layer 1
#   2. Pulls all financial data for FY2025 YTD (Jan-Sep)
#   3. Calculates variances: Actual vs Budget, and Actual vs Prior Year
#   4. Flags anything "material" — over 5% or over EUR 100M difference
#   5. Produces a clean summary JSON file ready for the AI layer (Layer 3)
#   6. Prints a formatted variance report to the screen
#
# Think of it as: the analyst who sits between the database and the CFO report
# =============================================================================

import duckdb
import json
import os
from datetime import datetime

# =============================================================================
# CONFIGURATION
# =============================================================================

DB_PATH     = "cfo_pack_booking.duckdb"   # Layer 1 database
OUTPUT_PATH = "python/variance_output.json" # Output for Layer 3 (AI)
REPORT_MONTH = "Sep-2025"                  # Latest closed month
YTD_MONTHS   = 9                           # Jan through Sep = 9 months

# Materiality thresholds — below these, variance is not worth flagging
# In a real company these are set by the CFO / finance policy
MATERIALITY_PCT = 5.0    # 5% variance triggers a flag
MATERIALITY_EUR = 100.0  # EUR 100M absolute variance triggers a flag

# =============================================================================
# STEP 1 — CONNECT TO DATABASE
# =============================================================================

print("=" * 65)
print("CFO MONTHLY REPORTING PACK — Booking Holdings")
print(f"Variance Engine | YTD Jan–{REPORT_MONTH}")
print(f"Source: 10-K FY2025, SEC EDGAR | Currency: EUR millions")
print("=" * 65)

# Check database exists
if not os.path.exists(DB_PATH):
    print(f"\nERROR: Database not found at {DB_PATH}")
    print("Make sure you are running this from your cfo-reporting-pack folder")
    print("Run: cd ~/Desktop/cfo-reporting-pack && python3 python/variance_engine.py")
    exit()

con = duckdb.connect(DB_PATH)
print(f"\nConnected to database: {DB_PATH}")

# Quick check — how many rows do we have?
row_count = con.execute("SELECT COUNT(*) FROM fact_financials").fetchone()[0]
print(f"Fact table rows loaded: {row_count}")

# =============================================================================
# STEP 2 — PULL DATA FROM DATABASE
# Pull all YTD actuals, budget, and prior year in one query
# =============================================================================

print("\nPulling YTD data from database...")

raw_data = con.execute(f"""
    SELECT
        a.category,
        a.sub_category,
        a.account_name,
        a.normal_balance,
        f.scenario,
        ROUND(SUM(f.amount), 1) AS amount_eur_m
    FROM fact_financials f
    JOIN dim_account a ON f.account_id = a.account_id
    JOIN dim_period  p ON f.period_id  = p.period_id
    WHERE p.fiscal_month BETWEEN 1 AND {YTD_MONTHS}
      AND a.is_income_stmt = 1
    GROUP BY a.category, a.sub_category, a.account_name,
             a.normal_balance, f.scenario
    ORDER BY a.category, a.sub_category, f.scenario
""").fetchall()

print(f"Rows returned: {len(raw_data)}")

# =============================================================================
# STEP 3 — ORGANISE THE DATA
# Convert raw rows into a clean dictionary structure
# Key = (category, sub_category) | Value = {ACTUAL: x, BUDGET: y, PRIOR_YEAR: z}
# =============================================================================

data = {}
for row in raw_data:
    category, sub_cat, acc_name, normal_bal, scenario, amount = row
    key = (category, sub_cat)
    if key not in data:
        data[key] = {
            "category":       category,
            "sub_category":   sub_cat,
            "account_name":   acc_name,
            "normal_balance": normal_bal,
            "ACTUAL":         0.0,
            "BUDGET":         0.0,
            "PRIOR_YEAR":     0.0
        }
    data[key][scenario] = amount

# =============================================================================
# STEP 4 — CALCULATE VARIANCES
# For each line:
#   vs_budget     = Actual - Budget
#   vs_prior_year = Actual - Prior Year
#   pct_vs_budget = variance as a percentage of budget
#   is_material   = True if variance exceeds thresholds
#
# IMPORTANT sign convention (same as real FP&A):
#   Revenue:  positive variance = GOOD (we made more than planned)
#   Costs:    positive variance = BAD  (we spent more than planned)
# =============================================================================

print("\nCalculating variances...")

results = []

for key, d in data.items():
    actual     = d["ACTUAL"]
    budget     = d["BUDGET"]
    prior_year = d["PRIOR_YEAR"]
    is_revenue = d["normal_balance"] == "CREDIT"

    # Variance calculations
    vs_budget     = round(actual - budget, 1)
    vs_prior_year = round(actual - prior_year, 1)

    # Percentage variance (avoid divide by zero)
    pct_vs_budget = round(vs_budget / budget * 100, 1) if budget != 0 else 0.0
    pct_vs_py     = round(vs_prior_year / prior_year * 100, 1) if prior_year != 0 else 0.0

    # Favourable or Adverse?
    # Revenue: over budget = FAV | Cost: over budget = ADV
    if is_revenue:
        fav_adv_budget = "FAV" if vs_budget >= 0 else "ADV"
        fav_adv_py     = "FAV" if vs_prior_year >= 0 else "ADV"
    else:
        fav_adv_budget = "ADV" if vs_budget > 0 else "FAV"
        fav_adv_py     = "ADV" if vs_prior_year > 0 else "FAV"

    # Materiality flag — is this worth calling out in the CFO report?
    is_material = (
        abs(pct_vs_budget) >= MATERIALITY_PCT or
        abs(vs_budget)     >= MATERIALITY_EUR
    )

    results.append({
        "category":        d["category"],
        "sub_category":    d["sub_category"],
        "account_name":    d["account_name"],
        "is_revenue":      is_revenue,
        "actual_eur_m":    actual,
        "budget_eur_m":    budget,
        "prior_year_eur_m":prior_year,
        "vs_budget_eur_m": vs_budget,
        "vs_budget_pct":   pct_vs_budget,
        "fav_adv_budget":  fav_adv_budget,
        "vs_py_eur_m":     vs_prior_year,
        "vs_py_pct":       pct_vs_py,
        "fav_adv_py":      fav_adv_py,
        "is_material":     is_material
    })

# =============================================================================
# STEP 5 — CALCULATE SUMMARY TOTALS
# Total Revenue, Total Costs, Gross Profit, Operating Income
# =============================================================================

def sum_by_category(results, categories, field="actual_eur_m"):
    return round(sum(r[field] for r in results if r["category"] in categories), 1)

total_revenue_actual = sum_by_category(results, ["Revenue"])
total_revenue_budget = sum_by_category(results, ["Revenue"], "budget_eur_m")
total_revenue_py     = sum_by_category(results, ["Revenue"], "prior_year_eur_m")

total_costs_actual   = sum_by_category(results, ["COGS","Marketing","Headcount","Opex"])
total_costs_budget   = sum_by_category(results, ["COGS","Marketing","Headcount","Opex"], "budget_eur_m")
total_costs_py       = sum_by_category(results, ["COGS","Marketing","Headcount","Opex"], "prior_year_eur_m")

op_income_actual     = round(total_revenue_actual - total_costs_actual, 1)
op_income_budget     = round(total_revenue_budget - total_costs_budget, 1)
op_income_py         = round(total_revenue_py - total_costs_py, 1)

op_margin_actual     = round(op_income_actual / total_revenue_actual * 100, 1) if total_revenue_actual else 0
op_margin_budget     = round(op_income_budget / total_revenue_budget * 100, 1) if total_revenue_budget else 0
op_margin_py         = round(op_income_py / total_revenue_py * 100, 1) if total_revenue_py else 0

mktg_actual          = sum_by_category(results, ["Marketing"])
mktg_pct_actual      = round(mktg_actual / total_revenue_actual * 100, 1) if total_revenue_actual else 0
mktg_budget          = sum_by_category(results, ["Marketing"], "budget_eur_m")
mktg_pct_budget      = round(mktg_budget / total_revenue_budget * 100, 1) if total_revenue_budget else 0

summary = {
    "report_date":         datetime.today().strftime("%d %b %Y"),
    "company":             "Booking Holdings (Booking.com)",
    "period":              f"YTD Jan–{REPORT_MONTH}",
    "source":              "10-K FY2025, SEC EDGAR, filed February 2026",
    "currency":            "EUR millions",
    "total_revenue": {
        "actual": total_revenue_actual, "budget": total_revenue_budget,
        "prior_year": total_revenue_py,
        "vs_budget": round(total_revenue_actual - total_revenue_budget, 1),
        "vs_budget_pct": round((total_revenue_actual - total_revenue_budget) / total_revenue_budget * 100, 1),
        "yoy_growth_pct": round((total_revenue_actual - total_revenue_py) / total_revenue_py * 100, 1)
    },
    "operating_income": {
        "actual": op_income_actual, "budget": op_income_budget, "prior_year": op_income_py,
        "vs_budget": round(op_income_actual - op_income_budget, 1),
        "margin_actual_pct": op_margin_actual,
        "margin_budget_pct": op_margin_budget,
        "margin_py_pct":     op_margin_py
    },
    "marketing_efficiency": {
        "spend_actual_eur_m":  mktg_actual,
        "pct_of_revenue_actual": mktg_pct_actual,
        "pct_of_revenue_budget": mktg_pct_budget,
        "vs_budget_pp": round(mktg_pct_actual - mktg_pct_budget, 1)
    }
}

# =============================================================================
# STEP 6 — PRINT THE VARIANCE REPORT
# This is what a real FP&A analyst would produce and send to the CFO
# =============================================================================

print("\n" + "=" * 65)
print("BOOKING HOLDINGS — CFO VARIANCE REPORT")
print(f"Period: YTD Jan–{REPORT_MONTH} | All figures EUR millions")
print("=" * 65)

print(f"""
P&L SUMMARY
{'':.<40} {'ACTUAL':>10} {'BUDGET':>10} {'VAR €M':>10} {'VAR%':>8}
{'-'*68}
{'Total Revenue':<40} {total_revenue_actual:>10,.1f} {total_revenue_budget:>10,.1f} {total_revenue_actual-total_revenue_budget:>+10,.1f} {(total_revenue_actual-total_revenue_budget)/total_revenue_budget*100:>+7.1f}%
{'Total Costs':<40} {total_costs_actual:>10,.1f} {total_costs_budget:>10,.1f} {total_costs_actual-total_costs_budget:>+10,.1f} {(total_costs_actual-total_costs_budget)/total_costs_budget*100:>+7.1f}%
{'Operating Income':<40} {op_income_actual:>10,.1f} {op_income_budget:>10,.1f} {op_income_actual-op_income_budget:>+10,.1f}
{'Operating Margin':<40} {op_margin_actual:>9.1f}% {op_margin_budget:>9.1f}%
{'YoY Revenue Growth':<40} {(total_revenue_actual-total_revenue_py)/total_revenue_py*100:>9.1f}%
""")

print("=" * 65)
print("MATERIAL VARIANCES (>5% or >EUR 100M vs budget)")
print("=" * 65)

material_items = [r for r in results if r["is_material"]]
if material_items:
    print(f"\n{'Line Item':<35} {'Actual':>9} {'Budget':>9} {'Var €M':>9} {'Var%':>8} {'Flag'}")
    print("-" * 78)
    for r in sorted(material_items, key=lambda x: abs(x["vs_budget_eur_m"]), reverse=True):
        flag = f"{'ADV' if r['fav_adv_budget']=='ADV' else 'FAV'}"
        icon = "🔴" if r["fav_adv_budget"] == "ADV" else "🟢"
        print(f"{r['sub_category']:<35} {r['actual_eur_m']:>9,.1f} "
              f"{r['budget_eur_m']:>9,.1f} {r['vs_budget_eur_m']:>+9,.1f} "
              f"{r['vs_budget_pct']:>+7.1f}% {icon} {flag}")
else:
    print("\nNo material variances identified.")

print("\n" + "=" * 65)
print("MARKETING EFFICIENCY")
print("=" * 65)
print(f"\n  Marketing spend YTD:     EUR {mktg_actual:,.1f}M")
print(f"  As % of revenue (Actual): {mktg_pct_actual:.1f}%")
print(f"  As % of revenue (Budget): {mktg_pct_budget:.1f}%")
print(f"  Variance vs budget:       {mktg_pct_actual-mktg_pct_budget:+.1f} percentage points")
if mktg_pct_actual > 30:
    print(f"  ⚠️  Above 30% internal target — review required")
else:
    print(f"  ✅ Within 30% internal target")

# =============================================================================
# STEP 7 — SAVE OUTPUT JSON FOR LAYER 3 (AI Commentary)
# The AI layer will read this file and write the CFO narrative
# =============================================================================

output = {
    "summary":          summary,
    "line_items":       results,
    "material_variances": [r for r in results if r["is_material"]],
    "generated_at":     datetime.today().isoformat()
}

os.makedirs("python", exist_ok=True)
with open(OUTPUT_PATH, "w") as f:
    json.dump(output, f, indent=2)

print(f"\n{'=' * 65}")
print(f"Output saved to: {OUTPUT_PATH}")
print(f"This file will be read by Layer 3 (AI Commentary Generator)")
print(f"{'=' * 65}")
print("\nLayer 2 complete.")
