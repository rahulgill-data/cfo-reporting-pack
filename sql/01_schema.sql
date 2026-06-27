-- =============================================================================
-- CFO MONTHLY REPORTING PACK — BOOKING HOLDINGS (Booking.com)
-- File: 01_schema.sql
-- Author: Rahul Gill | CA (AIR 39) | Lancaster MBA 2026
-- Source: Booking Holdings 10-K FY2025 (SEC EDGAR, filed February 2026)
-- Description: Star schema for FP&A reporting based on Booking.com financials
-- Currency: EUR millions | FX: USD/EUR 1.08 avg 2025
-- =============================================================================

CREATE TABLE IF NOT EXISTS dim_period (
    period_id         INTEGER PRIMARY KEY,
    fiscal_year       INTEGER NOT NULL,
    fiscal_month      INTEGER NOT NULL,
    period_name       TEXT    NOT NULL,
    quarter           TEXT    NOT NULL,
    fiscal_year_label TEXT    NOT NULL,
    is_closed         INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS dim_department (
    dept_id        INTEGER PRIMARY KEY,
    dept_code      TEXT    NOT NULL UNIQUE,
    dept_name      TEXT    NOT NULL,
    cost_centre    TEXT    NOT NULL,
    function_group TEXT    NOT NULL,
    budget_owner   TEXT    NOT NULL,
    is_active      INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS dim_account (
    account_id     INTEGER PRIMARY KEY,
    account_code   TEXT    NOT NULL UNIQUE,
    account_name   TEXT    NOT NULL,
    category       TEXT    NOT NULL,
    sub_category   TEXT    NOT NULL,
    is_income_stmt INTEGER DEFAULT 1,
    normal_balance TEXT    NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_entity (
    entity_id   INTEGER PRIMARY KEY,
    entity_code TEXT NOT NULL UNIQUE,
    entity_name TEXT NOT NULL,
    country     TEXT NOT NULL,
    currency    TEXT NOT NULL DEFAULT 'EUR',
    region      TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS fact_financials (
    fact_id    INTEGER,
    period_id  INTEGER NOT NULL,
    dept_id    INTEGER NOT NULL,
    account_id INTEGER NOT NULL,
    entity_id  INTEGER NOT NULL,
    scenario   TEXT    NOT NULL,
    amount     REAL    NOT NULL DEFAULT 0,
    headcount  INTEGER DEFAULT 0,
    loaded_at  TEXT    DEFAULT (current_timestamp)
);
