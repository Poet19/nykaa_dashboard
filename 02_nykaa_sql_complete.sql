-- ================================================================
--  NYKAA (FSN E-Commerce) — Complete SQL Script
--  Database  : nykaa_financials
--  Engine    : MySQL / PostgreSQL compatible
--  All values: ₹ Crore unless noted
-- ================================================================


-- ================================================================
-- SECTION 1 — DATABASE & TABLE CREATION
-- ================================================================

CREATE DATABASE IF NOT EXISTS nykaa_financials;
USE nykaa_financials;

-- ----- TABLE 1: PROFIT & LOSS -----
-- Stores annual income statement data (FY2018–FY2025)
CREATE TABLE IF NOT EXISTS profit_loss (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    fiscal_year         VARCHAR(4)     NOT NULL,  -- e.g. '2024'
    sales               DECIMAL(10,2),            -- Total Revenue
    raw_material_cost   DECIMAL(10,2),
    change_in_inventory DECIMAL(10,2),
    power_and_fuel      DECIMAL(10,2),
    other_mfr_exp       DECIMAL(10,2),
    employee_cost       DECIMAL(10,2),
    selling_and_admin   DECIMAL(10,2),
    other_expenses      DECIMAL(10,2),
    other_income        DECIMAL(10,2),
    depreciation        DECIMAL(10,2),
    interest            DECIMAL(10,2),
    profit_before_tax   DECIMAL(10,2),
    tax                 DECIMAL(10,2),
    net_profit          DECIMAL(10,2),
    -- Derived Columns (computed at insert time)
    gross_margin_pct    DECIMAL(6,2),
    opm_pct             DECIMAL(6,2),
    npm_pct             DECIMAL(6,2),
    revenue_growth_pct  DECIMAL(6,2),
    UNIQUE KEY uq_year (fiscal_year)
);

-- ----- TABLE 2: BALANCE SHEET -----
CREATE TABLE IF NOT EXISTS balance_sheet (
    id                   INT AUTO_INCREMENT PRIMARY KEY,
    fiscal_year          VARCHAR(4)    NOT NULL,
    equity_share_capital DECIMAL(10,2),
    reserves             DECIMAL(10,2),
    borrowings           DECIMAL(10,2),
    other_liabilities    DECIMAL(10,2),
    total_liabilities    DECIMAL(10,2),
    net_block            DECIMAL(10,2),
    capital_wip          DECIMAL(10,2),
    investments          DECIMAL(10,2),
    other_assets         DECIMAL(10,2),
    total_assets         DECIMAL(10,2),
    receivables          DECIMAL(10,2),
    inventory            DECIMAL(10,2),
    cash_and_bank        DECIMAL(10,2),
    -- Derived
    total_equity         DECIMAL(10,2),
    debt_to_equity       DECIMAL(6,2),
    UNIQUE KEY uq_year (fiscal_year)
);

-- ----- TABLE 3: CASH FLOW -----
CREATE TABLE IF NOT EXISTS cash_flow (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    fiscal_year           VARCHAR(4)   NOT NULL,
    cash_from_operations  DECIMAL(10,2),
    cash_from_investing   DECIMAL(10,2),
    cash_from_financing   DECIMAL(10,2),
    net_cash_flow         DECIMAL(10,2),
    UNIQUE KEY uq_year (fiscal_year)
);

-- ----- TABLE 4: QUARTERLY DATA -----
CREATE TABLE IF NOT EXISTS quarterly_data (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    quarter_label     VARCHAR(10)   NOT NULL,  -- e.g. 'Sep-24'
    quarter_date      DATE,                    -- actual end date
    sales             DECIMAL(10,2),
    expenses          DECIMAL(10,2),
    other_income      DECIMAL(10,2),
    depreciation      DECIMAL(10,2),
    interest          DECIMAL(10,2),
    profit_before_tax DECIMAL(10,2),
    tax               DECIMAL(10,2),
    net_profit        DECIMAL(10,2),
    operating_profit  DECIMAL(10,2),
    UNIQUE KEY uq_quarter (quarter_label)
);


-- ================================================================
-- SECTION 2 — DATA INSERTION
-- ================================================================
-- Why: We insert the cleaned values from our Screener dataset.
--      Derived fields (margins) are calculated inline.

-- ---- PROFIT & LOSS ----
INSERT INTO profit_loss
  (fiscal_year, sales, raw_material_cost, change_in_inventory, power_and_fuel,
   other_mfr_exp, employee_cost, selling_and_admin, other_expenses, other_income,
   depreciation, interest, profit_before_tax, tax, net_profit,
   gross_margin_pct, opm_pct, npm_pct)
VALUES
  ('2018',  26.77,  26.94,  8.47, 0.07, 0.35,  7.57, 15.90, 0.00,  6.44, 1.02, 0.42, -10.59, -2.75,  -7.85,
   ROUND(((26.77-(26.94+8.47+0.35))/26.77)*100,2), NULL, ROUND((-7.85/26.77)*100,2)),
  ('2019', 102.06,  45.59, 14.28, 0.14, 0.08, 20.46, 61.00, -0.02, 17.19, 4.01, 2.69,  -0.42, -1.20,   0.78,
   ROUND(((102.06-(45.59+14.28+0.08))/102.06)*100,2), NULL, ROUND((0.78/102.06)*100,2)),
  ('2020', 204.13,  98.16, 14.90, 0.19, 0.22, 30.29, 86.63,  0.00, 30.50, 7.40, 4.88,  21.76,  6.69,  15.07,
   ROUND(((204.13-(98.16+14.90+0.22))/204.13)*100,2), NULL, ROUND((15.07/204.13)*100,2)),
  ('2021', 145.81,  48.75,-15.83, 0.13, 1.55, 18.13, 63.53,  0.68, 60.25, 8.43, 4.21,  44.82,  8.64,  36.19,
   ROUND(((145.81-(48.75-15.83+1.55))/145.81)*100,2), NULL, ROUND((36.19/145.81)*100,2)),
  ('2022', 187.70,  91.47, 32.63, 0.21, 3.03, 30.36, 78.75, -0.11,115.71, 4.68, 5.95, 121.70, 18.18, 103.51,
   ROUND(((187.70-(91.47+32.63+3.03))/187.70)*100,2), NULL, ROUND((103.51/187.70)*100,2)),
  ('2023', 275.46, 127.91, 14.36, 0.64,13.33, 51.13,131.92,  2.45,128.77, 7.26, 7.55,  76.40, 19.32,  57.08,
   ROUND(((275.46-(127.91+14.36+13.33))/275.46)*100,2), NULL, ROUND((57.08/275.46)*100,2)),
  ('2024', 312.52, 124.81, -6.62, 0.60,22.84, 73.19,156.26,  3.24,184.64, 8.72, 6.96,  93.92,-27.10, 121.02,
   ROUND(((312.52-(124.81-6.62+22.84))/312.52)*100,2), NULL, ROUND((121.02/312.52)*100,2)),
  ('2025', 419.95, 174.96,-16.76, 0.51, 9.98, 67.46,186.15,  4.60,157.33,11.58, 7.99,  97.29, -0.07,  97.36,
   ROUND(((419.95-(174.96-16.76+9.98))/419.95)*100,2), NULL, ROUND((97.36/419.95)*100,2));

-- ---- BALANCE SHEET ----
INSERT INTO balance_sheet
  (fiscal_year, equity_share_capital, reserves, borrowings, other_liabilities,
   total_liabilities, net_block, capital_wip, investments, other_assets, total_assets,
   receivables, inventory, cash_and_bank, total_equity, debt_to_equity)
VALUES
  ('2018',  13.56, 129.84,  8.25, 13.29, 164.94,  6.34, 0.00,  21.93, 136.67, 164.94,  1.60,  8.47,  35.49, 143.40, ROUND(8.25/143.40,2)),
  ('2019',  14.24, 279.08, 30.23, 30.06, 353.61, 13.51, 0.00, 169.29, 170.81, 353.61,  7.11, 22.75,   4.41, 293.32, ROUND(30.23/293.32,2)),
  ('2020',  14.55, 404.12, 39.99, 39.27, 497.93, 17.51, 0.68,  52.49, 427.25, 497.93, 25.51, 46.34, 169.40, 418.67, ROUND(39.99/418.67,2)),
  ('2021',  15.06, 545.76, 46.06, 39.76, 646.64, 12.90, 0.00,  69.58, 564.16, 646.64, 63.72, 33.22, 192.30, 560.82, ROUND(46.06/560.82,2)),
  ('2022',  47.41,1502.54, 51.41, 89.08,1690.44, 16.46, 0.00, 379.48,1294.50,1690.44, 20.65, 72.55, 220.33,1549.95, ROUND(51.41/1549.95,2)),
  ('2023', 285.25,1170.32, 55.36,324.71,1835.64, 28.62, 0.89, 461.28,1344.85,1835.64, 71.49, 78.00,  51.97,1455.57, ROUND(55.36/1455.57,2)),
  ('2024', 285.60,1249.31, 87.27,245.45,1867.63, 30.35, 9.15, 640.87,1187.26,1867.63,115.79,103.27,  38.63,1534.91, ROUND(87.27/1534.91,2)),
  ('2025', 285.93,1373.68, 86.27,143.95,1889.83, 38.59,19.37, 935.07, 896.80,1889.83, 47.71, 86.12,  28.62,1659.61, ROUND(86.27/1659.61,2));

-- ---- CASH FLOW ----
INSERT INTO cash_flow
  (fiscal_year, cash_from_operations, cash_from_investing, cash_from_financing, net_cash_flow)
VALUES
  ('2018', -62.47,  55.29,  39.64,  32.46),
  ('2019', -56.29, -90.87, 134.40, -12.76),
  ('2020', -90.05,  68.77, 101.93,  80.65),
  ('2021', -84.07, -67.09,  86.92, -64.25),
  ('2022',  72.02,-944.19, 872.66,   0.49),
  ('2023',  -0.44, -41.34,  21.26, -20.51),
  ('2024', -31.19, -25.94,  47.31,  -9.82),
  ('2025', 142.58,-146.09,   7.57,   4.06);

-- ---- QUARTERLY DATA ----
INSERT INTO quarterly_data
  (quarter_label, quarter_date, sales, expenses, other_income, depreciation,
   interest, profit_before_tax, tax, net_profit, operating_profit)
VALUES
  ('Sep-23','2023-09-30', 66.24,  89.65, 39.16, 2.06, 1.75, 11.94, 1.27, 10.67,-23.41),
  ('Dec-23','2023-12-31', 80.19,  98.33, 45.12, 2.23, 1.71, 23.04, 4.20, 18.84,-18.14),
  ('Mar-24','2024-03-31',102.41, 106.97, 61.45, 2.29, 1.66, 52.94,-33.37,86.31, -4.56),
  ('Jun-24','2024-06-30',102.83, 113.90, 39.18, 2.32, 1.86, 23.93,-18.30,42.23,-11.07),
  ('Sep-24','2024-09-30',109.41, 122.87, 39.81, 3.00, 1.56, 21.79,  5.63,16.16,-13.46),
  ('Dec-24','2024-12-31',119.14, 123.30, 41.01, 2.87, 2.50, 31.48,  7.02,24.46, -4.16),
  ('Mar-25','2025-03-31', 88.57, 100.35, 37.34, 3.38, 1.98, 20.20,  5.58,14.62,-11.78),
  ('Jun-25','2025-06-30', 81.83,  98.94, 40.10, 3.20, 2.35, 17.44,  4.52,12.92,-17.11),
  ('Sep-25','2025-09-30', 76.97,  94.53, 40.56, 3.98, 2.50, 16.52,  4.27,12.25,-17.56),
  ('Dec-25','2025-12-31', 95.67, 105.44, 45.40, 3.71, 2.67, 29.25,  7.57,21.68, -9.77);


-- ================================================================
-- SECTION 3 — SQL QUERIES (Basic → Advanced)
-- ================================================================

-- ── BASIC QUERIES ──────────────────────────────────────────────

-- Q1: View all P&L data ordered by year
-- WHY: First check — confirm data loaded correctly.
SELECT * FROM profit_loss ORDER BY fiscal_year;

-- Q2: View latest year only
-- WHY: Quick snapshot of the most recent annual performance.
SELECT * FROM profit_loss WHERE fiscal_year = '2025';

-- Q3: Sales and Net Profit for all years
-- WHY: Core revenue + profitability trend at a glance.
SELECT fiscal_year, sales, net_profit FROM profit_loss ORDER BY fiscal_year;

-- Q4: Years where Nykaa was profitable
-- WHY: Helps identify the profitability turning point.
SELECT fiscal_year, net_profit
FROM profit_loss
WHERE net_profit > 0
ORDER BY fiscal_year;

-- Q5: Total revenue earned across all years
-- WHY: Cumulative business scale metric.
SELECT ROUND(SUM(sales), 2) AS total_cumulative_revenue_cr
FROM profit_loss;


-- ── INTERMEDIATE QUERIES ───────────────────────────────────────

-- Q6: Year-over-Year Revenue Growth
-- WHY: Core growth metric. Uses LAG window function to compare each year with previous.
SELECT
    fiscal_year,
    sales AS current_sales,
    LAG(sales) OVER (ORDER BY fiscal_year) AS prev_sales,
    ROUND(
        (sales - LAG(sales) OVER (ORDER BY fiscal_year)) /
        LAG(sales) OVER (ORDER BY fiscal_year) * 100, 2
    ) AS revenue_growth_pct
FROM profit_loss
ORDER BY fiscal_year;

-- Q7: Gross Margin, OPM, and Net Margin all at once
-- WHY: Three-tier margin analysis = profitability story.
SELECT
    fiscal_year,
    sales,
    ROUND((sales - raw_material_cost - change_in_inventory - other_mfr_exp) / sales * 100, 2) AS gross_margin_pct,
    ROUND(
        (sales - raw_material_cost - change_in_inventory - power_and_fuel -
         other_mfr_exp - employee_cost - selling_and_admin - other_expenses)
        / sales * 100, 2
    ) AS operating_margin_pct,
    ROUND(net_profit / sales * 100, 2) AS net_margin_pct
FROM profit_loss
ORDER BY fiscal_year;

-- Q8: Debt-to-Equity Ratio over years
-- WHY: Key solvency metric. D/E > 1 = high leverage risk.
SELECT
    fiscal_year,
    borrowings,
    equity_share_capital + reserves AS total_equity,
    ROUND(borrowings / (equity_share_capital + reserves), 2) AS debt_to_equity
FROM balance_sheet
ORDER BY fiscal_year;

-- Q9: Quarterly trend — sales & net profit
-- WHY: Detect seasonality and quarter-by-quarter momentum.
SELECT
    quarter_label,
    sales,
    net_profit,
    ROUND(net_profit / sales * 100, 2) AS npm_pct
FROM quarterly_data
ORDER BY quarter_date;

-- Q10: Cash conversion quality (Operating Cash vs Net Profit)
-- WHY: If OCF < Net Profit consistently, earnings quality is suspect.
SELECT
    p.fiscal_year,
    p.net_profit,
    c.cash_from_operations,
    ROUND(c.cash_from_operations / NULLIF(p.net_profit, 0), 2) AS cash_conversion_ratio
FROM profit_loss p
JOIN cash_flow c ON p.fiscal_year = c.fiscal_year
ORDER BY p.fiscal_year;


-- ── ADVANCED QUERIES ───────────────────────────────────────────

-- Q11: FULL MASTER VIEW — Join all 3 tables into one analytical row
-- WHY: This is the source for Power BI's main table.
SELECT
    p.fiscal_year,
    p.sales                                              AS revenue,
    p.net_profit,
    ROUND(p.net_profit / p.sales * 100, 2)               AS npm_pct,
    b.borrowings,
    b.equity_share_capital + b.reserves                  AS total_equity,
    ROUND(b.borrowings/(b.equity_share_capital+b.reserves), 2) AS de_ratio,
    b.cash_and_bank,
    c.cash_from_operations,
    c.net_cash_flow
FROM profit_loss p
JOIN balance_sheet b ON p.fiscal_year = b.fiscal_year
JOIN cash_flow     c ON p.fiscal_year = c.fiscal_year
ORDER BY p.fiscal_year;

-- Q12: CAGR Calculation (Compound Annual Growth Rate)
-- WHY: CAGR is the "true" growth rate used by investors and analysts.
--      Formula: (End/Start)^(1/n) - 1
SELECT
    MIN(fiscal_year)  AS start_year,
    MAX(fiscal_year)  AS end_year,
    MIN(sales)        AS start_revenue,
    MAX(sales)        AS end_revenue,
    COUNT(*) - 1      AS num_years,
    ROUND(
        (POWER(MAX(sales) / MIN(sales), 1.0 / (COUNT(*) - 1)) - 1) * 100, 2
    ) AS revenue_cagr_pct
FROM profit_loss;

-- Q13: Running Total Revenue (Cumulative)
-- WHY: Shows the "total business done" at each year-end.
SELECT
    fiscal_year,
    sales,
    ROUND(SUM(sales) OVER (ORDER BY fiscal_year), 2) AS cumulative_revenue
FROM profit_loss
ORDER BY fiscal_year;

-- Q14: Expense Breakdown as % of Sales (Cost Structure Analysis)
-- WHY: Identify where Nykaa spends the most (selling/admin vs employees etc.)
SELECT
    fiscal_year,
    ROUND(raw_material_cost    / sales * 100, 1) AS raw_mat_pct,
    ROUND(employee_cost        / sales * 100, 1) AS emp_pct,
    ROUND(selling_and_admin    / sales * 100, 1) AS selling_pct,
    ROUND(depreciation         / sales * 100, 1) AS depr_pct,
    ROUND(interest             / sales * 100, 1) AS interest_pct
FROM profit_loss
ORDER BY fiscal_year;

-- Q15: Working Capital Analysis
-- WHY: Working capital = money tied up in day-to-day operations.
--      Negative = company uses supplier credit well.
SELECT
    fiscal_year,
    receivables,
    inventory,
    cash_and_bank,
    other_liabilities,
    ROUND(receivables + inventory - other_liabilities, 2) AS working_capital
FROM balance_sheet
ORDER BY fiscal_year;

-- Q16: Rank years by Net Profit Margin
-- WHY: Quickly spot the best and worst performing years.
SELECT
    fiscal_year,
    net_profit,
    npm_pct,
    RANK() OVER (ORDER BY npm_pct DESC) AS margin_rank
FROM profit_loss
ORDER BY margin_rank;

-- Q17: Quarterly QoQ Sales Growth
-- WHY: Detect momentum — is each quarter stronger than the last?
SELECT
    quarter_label,
    sales,
    LAG(sales) OVER (ORDER BY quarter_date) AS prev_q_sales,
    ROUND(
        (sales - LAG(sales) OVER (ORDER BY quarter_date)) /
        LAG(sales) OVER (ORDER BY quarter_date) * 100, 2
    ) AS qoq_growth_pct
FROM quarterly_data
ORDER BY quarter_date;

-- Q18: ROE and ROCE (using joined tables)
-- WHY: ROE = return for shareholders | ROCE = total capital efficiency
SELECT
    p.fiscal_year,
    p.net_profit,
    b.equity_share_capital + b.reserves      AS total_equity,
    b.total_assets,
    ROUND(p.net_profit / (b.equity_share_capital + b.reserves) * 100, 2) AS roe_pct,
    ROUND(p.profit_before_tax / b.total_assets * 100, 2)                  AS roce_pct
FROM profit_loss p
JOIN balance_sheet b ON p.fiscal_year = b.fiscal_year
ORDER BY p.fiscal_year;

-- Q19: Cash Health Score (simple composite metric)
-- WHY: Combines OCF, D/E, and cash position into one view.
SELECT
    p.fiscal_year,
    c.cash_from_operations,
    b.cash_and_bank,
    b.borrowings,
    CASE
        WHEN c.cash_from_operations > 0 AND b.borrowings < 100 THEN 'Healthy'
        WHEN c.cash_from_operations < 0 AND b.borrowings > 80  THEN 'Stressed'
        ELSE 'Moderate'
    END AS cash_health
FROM profit_loss p
JOIN cash_flow     c ON p.fiscal_year = c.fiscal_year
JOIN balance_sheet b ON p.fiscal_year = b.fiscal_year
ORDER BY p.fiscal_year;

-- Q20: Pivot — Quarterly Sales by Year (for Power BI matrix)
-- WHY: Useful for multi-year quarterly comparison matrix.
SELECT
    YEAR(quarter_date) AS yr,
    SUM(CASE WHEN MONTH(quarter_date) IN (4,5,6)  THEN sales END) AS Q1,
    SUM(CASE WHEN MONTH(quarter_date) IN (7,8,9)  THEN sales END) AS Q2,
    SUM(CASE WHEN MONTH(quarter_date) IN (10,11,12)THEN sales END) AS Q3,
    SUM(CASE WHEN MONTH(quarter_date) IN (1,2,3)  THEN sales END) AS Q4
FROM quarterly_data
GROUP BY YEAR(quarter_date)
ORDER BY yr;
