-- Cohort Retention Table for OnlineRetailMini (SQL Server / T-SQL)
USE OnlineRetailMini;
GO

WITH Activity AS (
    -- one row per customer per calendar month they placed at least one order,
    -- with "months since signup" measured against their cohort month
    SELECT DISTINCT
        i.CustomerID,
        c.SignupMonth,
        DATEDIFF(MONTH, c.SignupMonth, i.InvoiceDate) AS MonthsSince
    FROM Invoices i
    JOIN Customers c ON c.CustomerID = i.CustomerID
),
CohortSizes AS (
    -- how many customers each cohort started with
    SELECT SignupMonth, COUNT(*) AS CohortSize
    FROM Customers
    GROUP BY SignupMonth
)
SELECT
    a.SignupMonth,
    a.MonthsSince,
    COUNT(DISTINCT a.CustomerID)                         AS ActiveCustomers,
    cs.CohortSize,
    CAST(100.0 * COUNT(DISTINCT a.CustomerID) / cs.CohortSize AS DECIMAL(5,1)) AS RetentionPct
FROM Activity a
JOIN CohortSizes cs ON cs.SignupMonth = a.SignupMonth
GROUP BY a.SignupMonth, a.MonthsSince, cs.CohortSize
ORDER BY a.SignupMonth, a.MonthsSince;
GO

-- Optional: pivot into the wide "cohort x months-since-signup" shape used for a heatmap
SELECT SignupMonth,
    [0] AS M0, [1] AS M1, [2] AS M2, [3] AS M3,
    [4] AS M4, [5] AS M5, [6] AS M6, [7] AS M7
FROM (
    SELECT
        a.SignupMonth,
        DATEDIFF(MONTH, a.SignupMonth, a.InvoiceDate) AS MonthsSince,
        a.CustomerID
    FROM (
        SELECT DISTINCT i.CustomerID, c.SignupMonth, i.InvoiceDate
        FROM Invoices i
        JOIN Customers c ON c.CustomerID = i.CustomerID
    ) a
) src
PIVOT (
    COUNT(CustomerID)
    FOR MonthsSince IN ([0],[1],[2],[3],[4],[5],[6],[7])
) AS p
ORDER BY SignupMonth;
GO