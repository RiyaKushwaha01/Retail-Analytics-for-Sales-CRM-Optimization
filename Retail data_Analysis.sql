USE INTERN 

--------------------------------------------------RETAIL DATA ANALYSIS---------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


--1. Perform Detailed exploratory analysis 
-----------------------------------------------------------------------------------------------------------------------------------------------------

-- Q1 : NUMBER OF ORDERS
SELECT COUNT(order_id) AS COUNT_ORDERS FROM ORDER_FINAL

-- Q2 : Total quantity
SELECT   SUM (Quantity) as Qty 
FROM ORDER_FINAL

-- Q3 : Average Discount per customer  - 92,190
SELECT Customer_id, AVG(Discount) AS Avg_Discount 
FROM ORDER_FINAL
GROUP BY Customer_id
HAVING AVG(Discount) <> 0

-- Q4 : Average discount per order -- 92,275
SELECT order_id, AVG(Discount) as Avg_Discount 
FROM ORDER_6	
GROUP BY order_id

-- Q5:  Average Sales per Customer --98,314
SELECT Customer_id, AVG(Discount) as AVG_Discout
FROM ORDER_FINAL
GROUP BY Customer_id

--Q6 :Average sales per customer -- 98,314

SELECT Customer_id, SUM([Total Amount]) AS TOT_AMT
FROM ORDER_FINAL
GROUP BY Customer_id

-- Q7 : Average profit per customer

SELECT 
    Customer_id,
    AVG([Total Amount] - (Quantity *[Cost Per Unit])) AS AverageProfitPerCustomer
FROM ORDER_FINAL
GROUP BY Customer_id

-- Q8 : Average number of catogies per ORDER
 
WITH CATEGORY_COUNT_PER_CUST AS (
	SELECT order_id,
		COUNT(DISTINCT Category) AS CATEGORY_COUNT
	FROM ORDER_FINAL AS O
	INNER JOIN ProductsInfo$ AS P
	ON O.product_id = P.product_id
	GROUP BY order_id
)
SELECT AVG(CATEGORY_COUNT* 1.0) AS AVG_CATEGORY_PER_CUST
FROM CATEGORY_COUNT_PER_CUST

-- Q9 : Average number of items per order

SELECT order_id,
    AVG(ProductCount) AS AVG_ITEM
FROM (SELECT order_id,
        COUNT(product_id) AS ProductCount
		FROM ORDER_FINAL
		GROUP BY order_id
) AS ProductCounts
GROUP BY order_id

-- Q10 : Number of customer 
SELECT COUNT(DISTINCT Customer_id)
FROM ORDER_FINAL

-- Q11 : Transaction per Customer
SELECT Customer_id , SUM([Total Amount]) as TOT_AMT
FROM ORDER_FINAL
GROUP BY Customer_id

-- Q12 : Total Revenue
SELECT SUM([Total Amount])
FROM ORDER_FINAL

-- Q13 : Total Profit

SELECT SUM([Total Amount]) - SUM(Quantity * [Cost Per Unit]) AS PROFIT
FROM ORDER_FINAL

-- Q14 : Total Cost 
SELECT SUM([Cost Per Unit]) AS TOT_COST
FROM ORDER_FINAL

-- Q15 : Total Quantity
SELECT COUNT(Quantity) AS QTY FROM ORDER_FINAL

-- Q16 : Total Product IN PRODUCT TABLE
SELECT COUNT(product_id) AS TOT_PRODUCT
FROM ProductsInfo$

-- Q17 : Total Categories 
SELECT COUNT(Category) AS TOT_CATEGORY
FROM ProductsInfo$

-- Q18 : Total Stores
SELECT COUNT(StoreID) AS TOT_STORE
FROM Store_level

-- Q19 : Total Location 
SELECT COUNT(DISTINCT customer_city) AS TOT_LOCATION
FROM Customers$

-- Q13 : Total Regions 
SELECT COUNT(DISTINCT Region)AS TOT_REGION
FROM Store_level

-- Q14 : Total Payment Methods 
SELECT COUNT(DISTINCT payment_type)  AS TOT_PAYMENT_METHODS
FROM OrderPayments$

-- Q15 :  Average number of days between two transactions (if the customer has more than one transaction)

WITH TRANSACTION_DIFFERENCE AS (
	SELECT  Customer_id,
	DATEDIFF(DAY,MAX(Bill_date_timestamp), MIN(Bill_date_timestamp)) AS Days_difference
	FROM ORDER_FINAL 
	GROUP BY Customer_id
)
SELECT Customer_id,
	AVG(Days_difference) AS AVG_DAYS_BW_TRANS
FROM TRANSACTION_DIFFERENCE
GROUP BY Customer_id

-- Q16 : Percentage of profit
SELECT 
    SUM([Total Amount]) - SUM(Quantity * [Cost Per Unit]) AS PROFIT,
    (SUM([Total Amount]) - SUM(Quantity * [Cost Per Unit])) * 100.0 / SUM([Total Amount]) AS ProfitPercentage
FROM ORDER_FINAL

-- Q17 : Percentage of discount
SELECT order_id,(([Total Amount] * 100.0)/MRP) AS DISCOUNT_PERCENT
FROM ORDER_FINAL 

-- Q18 : Repeat purchase rate
SELECT 
    Customer_id
FROM ORDER_FINAL
GROUP BY Customer_id
HAVING COUNT(order_id) > 1  -- Customers (3,254)who have made more than one purchase

-- Q19 : One time buyers percentage
WITH OneTimeCustomers AS (
    SELECT 
        Customer_id
    FROM ORDER_FINAL
    GROUP BY Customer_id
    HAVING COUNT(order_id) = 1  -- Customers who have made exactly one purchase
)
SELECT 
    (COUNT(DISTINCT OneTimeCustomers.Customer_id) * 100.0) / COUNT(DISTINCT ORDER_FINAL.Customer_id) AS OneTimeBuyersPercentage
FROM ORDER_FINAL
LEFT JOIN OneTimeCustomers ON ORDER_FINAL.Customer_id = OneTimeCustomers.Customer_id

-- Q20 : Understanding how many new customers acquired every month (who made transaction first time in the data)
WITH FirstTransaction AS (
    SELECT 
        Customer_id,
        MIN(Bill_date_timestamp) AS FirstTransactionDate
    FROM ORDER_FINAL
    GROUP BY Customer_id
)
SELECT 
    YEAR(FirstTransactionDate) AS Year,
    MONTH(FirstTransactionDate) AS Month,
    COUNT(Customer_id) AS NewCustomersAcquired
FROM FirstTransaction
GROUP BY YEAR(FirstTransactionDate), MONTH(FirstTransactionDate)
ORDER BY Year, Month

-- Q21 : Understand the retention of customers on month on month basis
WITH MonthlyCustomers AS (
    SELECT 
        Customer_id,
        YEAR(Bill_date_timestamp) AS OrderYear,
        MONTH(Bill_date_timestamp) AS OrderMonth
    FROM ORDER_FINAL
    GROUP BY Customer_id, YEAR(Bill_date_timestamp), MONTH(Bill_date_timestamp)
),
MonthRetention AS (
    SELECT 
        m1.OrderYear AS RetentionYear,
        m1.OrderMonth AS RetentionMonth,
        COUNT(DISTINCT m1.Customer_id) AS CustomersInMonth,
        COUNT(DISTINCT m2.Customer_id) AS RetainedCustomers
    FROM MonthlyCustomers m1
    LEFT JOIN MonthlyCustomers m2
        ON m1.Customer_id = m2.Customer_id
        AND m1.OrderYear = m2.OrderYear
        AND m2.OrderMonth = m1.OrderMonth + 1  -- Compare next month
    GROUP BY m1.OrderYear, m1.OrderMonth
)
SELECT 
    RetentionYear,
    RetentionMonth,
    CustomersInMonth,
    RetainedCustomers,
    (RetainedCustomers * 100.0) / CustomersInMonth AS RetentionRate
FROM MonthRetention
ORDER BY RetentionYear, RetentionMonth

-- Q22 : How the revenues from existing/new customers on monthly basis
WITH MonthlyCustomers AS (
    SELECT 
        Customer_id,
        YEAR(Bill_date_timestamp) AS OrderYear,
        MONTH(Bill_date_timestamp) AS OrderMonth,
        SUM([Total Amount]) AS MonthlyRevenue
    FROM ORDER_FINAL
    GROUP BY Customer_id, YEAR(Bill_date_timestamp), MONTH(Bill_date_timestamp)
),
FirstPurchase AS (
    SELECT 
        Customer_id,
        MIN(Bill_date_timestamp) AS FirstTransactionDate
    FROM ORDER_FINAL
    GROUP BY Customer_id
),
RevenueClassification AS (
    SELECT
        m.Customer_id,
        m.OrderYear,
        m.OrderMonth,
        m.MonthlyRevenue,
        CASE 
            WHEN m.OrderMonth = MONTH(fp.FirstTransactionDate) AND m.OrderYear = YEAR(fp.FirstTransactionDate) THEN 'New'
            ELSE 'Existing'
        END AS CustomerType
    FROM MonthlyCustomers m
    JOIN FirstPurchase fp
        ON m.Customer_id = fp.Customer_id
)
SELECT 
    OrderYear,
    OrderMonth,
    SUM(CASE WHEN CustomerType = 'New' THEN MonthlyRevenue ELSE 0 END) AS RevenueFromNewCustomers,
    SUM(CASE WHEN CustomerType = 'Existing' THEN MonthlyRevenue ELSE 0 END) AS RevenueFromExistingCustomers
FROM RevenueClassification
GROUP BY OrderYear, OrderMonth
ORDER BY OrderYear, OrderMonth

-- Q23 : Understand the trends/seasonality of sales, quantity by category, region, store, channel, payment method etc…
 
 -- 1. Monthly Sales Trends by Category

SELECT 
	YEAR(Bill_date_timestamp) AS SALE_YEAR,
	MONTH(Bill_date_timestamp) AS SALE_MONTH,
	Category,
	SUM(Quantity) AS TOT_QTY,
	SUM([Total Amount]) AS TOT_SALES,
	AVG([Total Amount]) AS AVG_SALE_AMT
FROM ORDER_FINAL AS O 
INNER JOIN ProductsInfo$ AS P
ON O.product_id = P.product_id
GROUP BY YEAR(Bill_date_timestamp), MONTH(Bill_date_timestamp),Category
ORDER BY TOT_QTY DESC

-- 2. Sales Trends by Region and Store
SELECT DISTINCT 
	YEAR(Bill_date_timestamp) AS SALE_YEAR,
	MONTH(Bill_date_timestamp) AS SALE_MONTH,
	Region,
	StoreID,
	SUM(Quantity) AS TOT_QTY,
	SUM([Total Amount]) AS TOT_SALES
FROM Store_level AS S
INNER JOIN ORDER_FINAL AS O 
ON S.StoreID = O.Delivered_StoreID
GROUP BY YEAR(Bill_date_timestamp), MONTH(Bill_date_timestamp), Region, StoreID

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q1 : Total Discount
SELECT SUM(Discount) AS TOT_DISCOUNT
FROM ORDER_FINAL

-- Q2 : REGION PER STORE_ID COUNT
SELECT Region, COUNT(StoreID)
FROM Store_level
GROUP BY Region

-- Q3: REGION WITH TOT_REVENUE
SELECT Region, SUM([Total Amount]) AS TOT_REVENUE 
FROM Store_level AS S
INNER JOIN ORDER_FINAL AS O
ON S.StoreID = O.Delivered_StoreID
GROUP BY Region

-- Q4 : CATEGORY WITH TOTAL REVENUE
SELECT Category, SUM([Total Amount]) AS TOT_REVENUE
FROM ORDER_FINAL AS O 
INNER JOIN ProductsInfo$ AS P
ON O.product_id = P.product_id
GROUP BY Category

-- Q5 : SELLER_CITY WITH CUSTOMER_COUNT
SELECT TOP 10 seller_city, COUNT(Customer_id) AS NO_OF_CUSTOMERS
FROM Store_level AS S
INNER JOIN ORDER_FINAL AS O 
ON S.StoreID = O.Delivered_StoreID
GROUP BY seller_city
ORDER BY COUNT(Customer_id) DESC

-- Q6 : GENDER COUNT
SELECT GENDER, COUNT(Custid) as CUST_COUNT
FROM Customers$
GROUP BY Gender

-- Q7 :  GENDER VS TOT_REVENUE
SELECT Gender, SUM([Total Amount]) AS TOT_REVENUE
FROM ORDER_FINAL AS O
INNER JOIN Customers$ AS C
ON O.Customer_id = C.Custid
GROUP BY Gender

-- Q8 : QTY BY CHANNEL 
SELECT Channel, COUNT(Quantity) AS QTY
FROM ORDER_FINAL
GROUP BY Channel

-- Q9 : STORE_ID BY REGION 
 
SELECT YEAR(Bill_date_timestamp) AS YEAR , SUM(Quantity) AS QTY
FROM ORDER_FINAL
GROUP BY YEAR(Bill_date_timestamp) 

--Q10 : PREFFERD PAYMENT TYPE 

SELECT payment_type, COUNT(order_id) AS ORDERS
FROM OrderPayments$ 
GROUP BY payment_type
ORDER BY COUNT(order_id) DESC

-- Q11 : INACTIVE DAYS
SELECT Custid,Inactive_days
FROM CUSTOMER_360
ORDER BY Inactive_days DESC

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------

--5. Customer satisfaction towards category & product 

--Q1 : Which categories (top 10) are maximum rated & minimum rated and average rating score? 

-- MAXIMUM RATED 
SELECT  TOP 10 Category, AVG(Cust_satisfaction_Score) AS AVG_RATING_SCORE
FROM ORDER_360
GROUP BY Category
ORDER BY AVG_RATING_SCORE DESC

-- MINIMUM RATED 
SELECT  TOP 10 Category, AVG(Cust_satisfaction_Score) AS AVG_RATING_SCORE
FROM ORDER_360
GROUP BY Category
ORDER BY AVG_RATING_SCORE  -- WHERE NO_DATA IS #N/A


-- Q2 : Average rating by location, store, product, category, month, etc.
SELECT Delivered_StoreID,product_id,Category, MONTH(Bill_date_timestamp) as MONTH_BILL ,AVG(Cust_satisfaction_Score) AS AVG_RATING
FROM ORDER_360
GROUP BY Delivered_StoreID, product_id, Category,MONTH(Bill_date_timestamp)

