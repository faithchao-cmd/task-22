# Cohort Retention Basics: OnlineRetailMini

A beginner analytics project building a cohort retention table and heatmap, modeled on the UCI "Online Retail II" dataset.

## Objective
Group customers by signup month and track what share of each cohort is still buying in the months that follow, to understand retention over time.

## Tools
- Microsoft SQL Server (T-SQL) — builds the cohort retention table
- Python (matplotlib) — renders the retention heatmap

## Dataset
`OnlineRetailMini`, a scaled-down version of Online Retail II with a realistic retention decay built in. Two tables:

| Table | Rows | Description |
|-------|------|-------------|
| Customers | 261 | `CustomerID`, `Country`, `SignupMonth` |
| Invoices | 2,831 lines / 915 invoices | `InvoiceNo`, `CustomerID`, `InvoiceDate`, product, price, quantity |

Cohorts run from January to August 2024.

## Files
| File | Purpose |
|------|---------|
| `online_retail_mini_mssql.sql` | Creates the database and loads the data |
| `cohort_retention.sql` | Builds the cohort retention table (long format + pivot) |
| `cohort_heatmap.png` | Heatmap of retention % by cohort and months-since-signup |
| `cohort_report.docx` | Full write-up: method, table, heatmap, insights |
| `README.md` | This file |

## How to run
1. Run `online_retail_mini_mssql.sql` once in SSMS or Azure Data Studio to create `OnlineRetailMini`.
2. Run `cohort_retention.sql` to produce the cohort table.
3. (Optional) Export the pivoted result to CSV and regenerate the heatmap, or use conditional formatting in Excel.

## Method
- A cohort = all customers whose `SignupMonth` falls in the same calendar month.
- For each invoice, `DATEDIFF(MONTH, SignupMonth, InvoiceDate)` gives "months since signup" (M0, M1, M2, …).
- Retention % = customers active in month N ÷ cohort's starting size.

## Key insights
- Retention drops sharply after month 0 (100% → ~35–50% at M1), then declines more gradually.
- The January cohort (the only one with 7 full months of data) settles around 20–25% long-term retention.
- February's cohort has a dip at M5 that looks like noise from a small sample (35 customers), not a real trend.
