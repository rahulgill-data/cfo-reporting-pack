# =============================================================================
# CFO MONTHLY REPORTING PACK — BOOKING HOLDINGS (Booking.com)
# File: ai_commentary.py  |  Layer 3 — AI Commentary Generator
# Author: Rahul Gill | CA (AIR 39) | Lancaster MBA 2026
# Uses: Google Gemini API (FREE — no credit card needed)
# Get key at: https://aistudio.google.com
# Set key:    export GEMINI_API_KEY="your-key-here"
# =============================================================================

import json, os, google.generativeai as genai
from datetime import datetime

INPUT_PATH  = "python/variance_output.json"
OUTPUT_PATH = "python/cfo_commentary.txt"

print("=" * 65)
print("CFO MONTHLY REPORTING PACK — Booking Holdings")
print("Layer 3: AI Commentary Generator (Google Gemini)")
print("=" * 65)

api_key = os.environ.get("GEMINI_API_KEY")
if not api_key:
    print("\nERROR: Set your key first:\nexport GEMINI_API_KEY='your-key-here'\n")
    exit()

genai.configure(api_key=api_key)

with open(INPUT_PATH) as f:
    data = json.load(f)

s   = data["summary"]
mat = data["material_variances"]
rev = s["total_revenue"]
op  = s["operating_income"]
mk  = s["marketing_efficiency"]
per = s["period"]

# Sort material variances by absolute size
mat = sorted(mat, key=lambda x: abs(x["vs_budget_eur_m"]), reverse=True)

# Short prompt — stays within Gemini free tier limits
prompt = f"""Senior FP&A analyst writing CFO monthly commentary for Booking Holdings.

PERIOD: {per} | Currency: EUR millions

KEY NUMBERS:
- Revenue: EUR {rev['actual']:,.0f}M actual vs EUR {rev['budget']:,.0f}M budget ({rev['vs_budget_pct']:+.1f}%), +{rev['yoy_growth_pct']:.1f}% YoY
- Operating Income: EUR {op['actual']:,.0f}M vs budget EUR {op['budget']:,.0f}M, margin {op['margin_actual_pct']:.1f}% vs {op['margin_budget_pct']:.1f}% budget
- Marketing: {mk['pct_of_revenue_actual']:.1f}% of revenue vs {mk['pct_of_revenue_budget']:.1f}% budget

TOP VARIANCES VS BUDGET:
- Agency revenue: EUR {mat[0]['vs_budget_eur_m']:+,.0f}M ({mat[0]['vs_budget_pct']:+.1f}%) ADVERSE — structural decline, expected
- Merchant revenue: EUR {mat[1]['vs_budget_eur_m']:+,.0f}M ({mat[1]['vs_budget_pct']:+.1f}%) FAVOURABLE — strategic priority
- Performance marketing: EUR {mat[2]['vs_budget_eur_m']:+,.0f}M ({mat[2]['vs_budget_pct']:+.1f}%) ADVERSE
- Payment processing: EUR {mat[3]['vs_budget_eur_m']:+,.0f}M ({mat[3]['vs_budget_pct']:+.1f}%) ADVERSE
- G&A: EUR {mat[4]['vs_budget_eur_m']:+,.0f}M ({mat[4]['vs_budget_pct']:+.1f}%) FAVOURABLE

Write exactly 5 sections, 350 words max:
1. EXECUTIVE SUMMARY — 3 sentences, headline vs budget and YoY
2. REVENUE ANALYSIS — 4 sentences, merchant vs agency strategic story
3. COST & MARGIN ANALYSIS — 3 sentences, marketing and processing costs
4. KEY RISKS & WATCHPOINTS — 3 bullet points
5. OUTLOOK — 2 sentences

Rules: paragraphs for 1-3 (no bullets), specific EUR numbers, no words "significant" or "robust"."""

print(f"\nLoaded: {per} | Material variances: {len(mat)}")
print("Sending to Gemini AI... (10-20 seconds)")

model    = genai.GenerativeModel("gemini-2.0-flash")
response = model.generate_content(prompt)
commentary = response.text

header = f"""BOOKING HOLDINGS — CFO MONTHLY COMMENTARY
Period: {per} | Source: 10-K FY2025, SEC EDGAR | EUR millions
Generated: {datetime.today().strftime('%d %b %Y')} via Google Gemini AI
{'=' * 65}

"""

print("\n" + "=" * 65)
print("AI-GENERATED CFO COMMENTARY")
print("=" * 65 + "\n")
print(header + commentary)

with open(OUTPUT_PATH, "w") as f:
    f.write(header + commentary)

print(f"\nSaved to: {OUTPUT_PATH}")
print("Layer 3 complete.")
