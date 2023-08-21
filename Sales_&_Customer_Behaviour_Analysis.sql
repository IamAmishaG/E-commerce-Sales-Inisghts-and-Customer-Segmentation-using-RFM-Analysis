----DATA EXPLORATION----
-----------------------------------------SALES ANALYSIS-----------------------------------------
--1. What are the total sales and total revenue for each country?
SELECT
    Country,
    SUM([Sales Amount]) AS TotalSales,
	SUM(([Unit Price] * Quantity)) AS TotalRevenue
FROM
	online_retail
GROUP BY 
	Country
ORDER BY
    TotalRevenue DESC;

--2. What are the top-selling products based on sales quantity?
SELECT TOP 10
    [Description], 
    SUM([Quantity]) AS TotalQuantitySold
FROM
    online_retail
GROUP BY
    [Description]
ORDER BY
    TotalQuantitySold DESC;

--3. What is the monthly sales trend over time?
SELECT
    MONTH([Invoice Date]) AS Month,
    SUM([Sales Amount]) AS MonthlySales
FROM
    online_retail
GROUP BY
    MONTH([Invoice Date])
ORDER BY
    Month;

--4. Which customers have the highest total spend?
SELECT TOP 10
    [Customer ID],
    SUM([Sales Amount]) AS TotalSpend
FROM
    online_retail
GROUP BY
    [Customer ID]
ORDER BY
    TotalSpend DESC; 

--5. What is the average order value over time?
SELECT
    YEAR([Invoice Date]) AS Year,
    MONTH([Invoice Date]) AS Month,
    AVG([Sales Amount]) AS AverageOrderValue
FROM
    online_retail
GROUP BY
    YEAR([Invoice Date]),
    MONTH([Invoice Date])
ORDER BY
    Year, Month;

--6. Average Order Value by Country
SELECT
    Country,
    AVG([Sales Amount] / [Quantity]) AS AverageOrderValue
FROM
    online_retail
GROUP BY
    Country
ORDER BY
    AverageOrderValue DESC;


--7. Month-over-Month Growth Rate
SELECT
    YEAR([Invoice Date]) AS Year,
    MONTH([Invoice Date]) AS Month,
    (SUM([Sales Amount]) - LAG(SUM([Sales Amount])) OVER (ORDER BY YEAR([Invoice Date]), MONTH([Invoice Date]))) / LAG(SUM([Sales Amount])) OVER (ORDER BY YEAR([Invoice Date]), MONTH([Invoice Date])) * 100 AS MonthlyGrowthRate
FROM
    online_retail
GROUP BY
    YEAR([Invoice Date]),
    MONTH([Invoice Date])
ORDER BY
    Year, Month;


-----------------------------------------CUSTOMER ANALYSIS-----------------------------------------
--1. Customer Purchase Frequency
SELECT
    [Customer ID],
    COUNT(DISTINCT [Invoice ID]) AS PurchaseCount
FROM
    online_retail
GROUP BY
    [Customer ID]
ORDER BY
    PurchaseCount DESC;

--2. Average Purchase Amount per Customer
SELECT
    [Customer ID],
    AVG([Sales Amount]) AS AvgPurchaseAmount
FROM
    online_retail
GROUP BY
    [Customer ID]
ORDER BY
    AvgPurchaseAmount DESC;

--3. Customer Loyalty based on Recency
SELECT
    ST.[Customer ID],
    ST.[Invoice Date],
    DATEDIFF(DAY, ST.[Invoice Date], CLP.LastPurchaseDate) AS DaysSinceLastPurchase
FROM
    online_retail ST
JOIN (
    SELECT
        [Customer ID],
        MAX([Invoice Date]) AS LastPurchaseDate
    FROM
        online_retail
    GROUP BY
        [Customer ID]
) CLP ON ST.[Customer ID] = CLP.[Customer ID]
ORDER BY
    ST.[Customer ID], ST.[Invoice Date];


--4. Top Spending Customers
SELECT TOP 10
    [Customer ID],
    SUM([Sales Amount]) AS TotalSpending
FROM
    online_retail
GROUP BY
    [Customer ID]
ORDER BY
    TotalSpending DESC;

--5. Customer Churn Rate 
WITH CustomerChurn AS (
    SELECT
        [Customer ID],
        MIN([Invoice Date]) AS FirstPurchaseDate,
        MAX([Invoice Date]) AS LastPurchaseDate
    FROM
        online_retail
    GROUP BY
        [Customer ID]
)
SELECT
    SUM(CASE WHEN DATEDIFF(DAY, FirstPurchaseDate, LastPurchaseDate) > 365 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    COUNT(DISTINCT [Customer ID]) AS TotalCustomers,
    100.0 * SUM(CASE WHEN DATEDIFF(DAY, FirstPurchaseDate, LastPurchaseDate) > 365 THEN 1 ELSE 0 END) / COUNT(DISTINCT [Customer ID]) AS ChurnRate
FROM
    CustomerChurn;

--6. Customer Acquisition by Month
SELECT
    MONTH([Invoice Date]) AS Month,
    COUNT(DISTINCT [Customer ID]) AS NewCustomers
FROM
    online_retail
GROUP BY
    MONTH([Invoice Date])
ORDER BY
     Month;

--7. Customer Repeat Purchase Rate
SELECT
    [Customer ID],
    COUNT(DISTINCT [Invoice ID]) AS TotalOrders,
    COUNT(DISTINCT CASE WHEN [Quantity] > 1 THEN [Invoice ID] END) AS RepeatOrders
FROM
    online_retail
GROUP BY
    [Customer ID]
ORDER BY
    TotalOrders DESC;

--8. Customer Purchase Behavior by Day of Week
SELECT
    DATEPART(WEEKDAY, [Invoice Date]) AS DayOfWeek,
    COUNT(DISTINCT [Customer ID]) AS UniqueCustomers
FROM
    online_retail
GROUP BY
    DATEPART(WEEKDAY, [Invoice Date])
ORDER BY
    DayOfWeek;










