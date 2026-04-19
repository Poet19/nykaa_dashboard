# 💄 Nykaa Financial Dashboard (Power BI)

An interactive **financial analytics dashboard** built using **Power BI** to analyze Nykaa’s business performance across revenue, profitability, margins, and cash flow trends.

---

## 📊 Project Overview

This dashboard provides a **clear, visual story of financial performance** using a modern dark-themed UI and business-focused KPIs.

It helps answer:

* How is revenue growing over time?
* Are margins improving or declining?
* Is the company generating healthy cash flows?
* How leveraged is the business (Debt-to-Equity)?

---

## 🚀 Features

### 🔹 KPI Cards

* Total Revenue
* Net Profit
* Net Profit Margin (%)
* Debt-to-Equity Ratio

---

### 📈 Revenue Trend

* Year-wise revenue growth
* Area + line visualization
* Data labels for clarity

---

### 📉 Margin Analysis

* Gross Margin %
* Net Margin %
* Multi-line comparison across years

---

### 💰 Cash Flow vs Profit

* Comparison of:

  * Operating Cash Flow
  * Net Profit
* Helps detect **earnings quality**

---

### 📆 (Optional) Quarterly Analysis

* Quarter-wise performance tracking
* Time-based insights

---

## 🧠 DAX Measures Used

```DAX
Revenue Growth % =
VAR CurrentYear = MAX(profit_loss[Year])
VAR CurrentSales = [Total Revenue]
VAR PrevSales =
    CALCULATE(
        [Total Revenue],
        profit_loss[Year] = CurrentYear - 1
    )
RETURN
DIVIDE(CurrentSales - PrevSales, PrevSales, 0) * 100


Net Margin % =
DIVIDE(
    SUM(profit_loss[Net_profit]),
    SUM(profit_loss[Sales]),
    0
) * 100


Gross Margin % =
DIVIDE(
    SUM(profit_loss[Sales]) - SUM(profit_loss[COGS]),
    SUM(profit_loss[Sales]),
    0
) * 100


D/E Ratio =
DIVIDE(
    SUM(balance_sheet[Borrowings]),
    SUM(balance_sheet[Total_Equity]),
    0
)
```

---

## 🗂️ Data Sources

* `profit_loss_enriched.csv`
* `balance_sheet_enriched.csv`
* `cash_flow_clean.csv`
* `master_annual.csv`
* `quarters_clean.csv`

---

## 🔗 Data Model

* `profit_loss` → Primary (fact table)
* Connected via **Year**
* Relationships:

  * Profit ↔ Balance Sheet
  * Profit ↔ Cash Flow

---

## 🎨 Dashboard Design

* **Theme:** Dark UI (#1a1a2e / #16213e)

* **Accent Colors:**

  * Pink → Revenue (#e94560)
  * Yellow → Margin (#ffd460)
  * Green → Profit (#05c46b)
  * Blue → Cash Flow (#4cc9f0)

* **Layout:** Z-pattern (Top KPIs → Middle Trends → Bottom Analysis)

---

## 🛠️ Tools & Technologies

* Power BI Desktop
* DAX (Data Analysis Expressions)
* Power Query
* Python (for preprocessing & cleaning)

---

## 📸 Dashboard Preview

![Dashboard Preview](data/final_dashboard.png)

---

## 📌 Key Insights

* Consistent revenue growth trend
* Improving profitability after early losses
* Cash flow stability vs profit fluctuations
* Low debt → strong financial health

---

## 🧩 Future Improvements

* Add drill-through pages
* Dynamic tooltips
* Forecasting (time series)
* User filters (Year / Quarter slicers)

---

## 👤 Author

**Gunjan Bagga**
Aspiring Data Analyst | Power BI | SQL | Python

---

## ⭐ If you like this project

Give it a ⭐ on GitHub and feel free to fork!

---
