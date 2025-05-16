USE INTERN

----------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------STORE_360 TABLE ---------------------------------------------------------------------------------

-- STORE_360 HAS 37 ROWS

SELECT * FROM STORE_360

----------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT S.* ,
	COUNT(DISTINCT O.order_id) AS Total_Orders,
	SUM(O.Quantity) AS Total_Quantity,
    SUM(O.[Total Amount]) AS Total_Revenue,
    SUM(O.[Total Amount] - (O.Quantity * O.[Cost Per Unit])) AS Total_Profit,
    SUM(O.Discount) AS Total_Discount,
	AVG(O.[Total Amount]) AS Average_Order_Value,
    COUNT(DISTINCT O.product_id) AS Distinct_Products_Sold,
	COUNT(DISTINCT P.Category) AS Distinct_Categories_Sold,
	COUNT(DISTINCT O.Customer_id) AS Distinct_Customers,
	MIN(O.Bill_date_timestamp) AS First_Sale_Date, 
    MAX(O.Bill_date_timestamp) AS Last_Sale_Date,
	((SUM(O.Quantity * (O.MRP - O.Discount)))/(DATEDIFF(DAY, MIN(O.Bill_date_timestamp), MAX(O.Bill_date_timestamp)))) AS Avg_daily_Sale,
	-- Payment Insights
   
    SUM(CASE WHEN OP.payment_type = 'voucher' THEN O.[Total Amount] ELSE 0 END) AS Revenue_From_Voucher,
    SUM(CASE WHEN OP.payment_type = 'credit card' THEN O.[Total Amount] ELSE 0 END) AS Revenue_From_Credit,
    SUM(CASE WHEN OP.payment_type = 'UPI/CASH' THEN O.[Total Amount] ELSE 0 END) AS Revenue_From_UPI_Cash,
    SUM(CASE WHEN OP.payment_type = 'DEBIT' THEN O.[Total Amount] ELSE 0 END) AS Revenue_From_Debit,
	 -- Channel-Specific Metrics
	 --INSTORE
    SUM(CASE WHEN O.Channel = 'INSTORE' THEN O.[Total Amount] ELSE 0 END) AS Instore_Revenue,
    COUNT(CASE WHEN O.Channel = 'INSTORE' THEN O.order_id END) AS Instore_Orders,
    SUM(CASE WHEN O.Channel = 'INSTORE' THEN O.Quantity ELSE 0 END) AS Instore_Quantity,
    SUM(CASE WHEN O.Channel = 'INSTORE' THEN (O.[Total Amount] - (O.Quantity * O.[Cost Per Unit])) ELSE 0 END) AS Instore_Profit,
    SUM(CASE WHEN O.Channel = 'INSTORE' THEN O.Discount ELSE 0 END) AS Instore_Discount,
	-- PAYMENT_TYPE
	SUM(CASE WHEN OP.payment_type = 'Credit_Card' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_Credit_pay,
	SUM(CASE WHEN OP.payment_type = 'Debit_Card' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_Debit_pay,
	SUM(CASE WHEN OP.payment_type = 'UPI/Cash' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_UPI_Cash_pay,
	SUM(CASE WHEN OP.payment_type = 'Voucher' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_Voucher_pay,

	--ONLINE
    SUM(CASE WHEN O.Channel = 'ONLINE' THEN O.[Total Amount] ELSE 0 END) AS Online_Revenue,
    COUNT(CASE WHEN O.Channel = 'ONLINE' THEN O.order_id END) AS Online_Orders,
    SUM(CASE WHEN O.Channel = 'ONLINE' THEN O.Quantity ELSE 0 END) AS Online_Quantity,
    SUM(CASE WHEN O.Channel = 'ONLINE' THEN (O.[Total Amount] - (O.Quantity * O.[Cost Per Unit])) ELSE 0 END) AS Online_Profit,
    SUM(CASE WHEN O.Channel = 'ONLINE' THEN O.Discount ELSE 0 END) AS Online_Discount,
	--PAYMENT_TYPE
	SUM(CASE WHEN OP.payment_type = 'Credit_Card' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_Credit_pay,
	SUM(CASE WHEN OP.payment_type = 'Debit_Card' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_Debit_pay,
	SUM(CASE WHEN OP.payment_type = 'UPI/Cash' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_UPI_Cash_pay,
	SUM(CASE WHEN OP.payment_type = 'Voucher' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_Voucher_pay,
    
	--PHONE_DELIVERY
    SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.[Total Amount] ELSE 0 END) AS Phone_Revenue,
    COUNT(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.order_id END) AS Phone_Orders,
    SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.Quantity ELSE 0 END) AS Phone_Quantity,
    SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN (O.[Total Amount] - (O.Quantity * O.[Cost Per Unit])) ELSE 0 END) AS Phone_Profit,
    SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.Discount ELSE 0 END) AS Phone_Discount,
	-- PAYMENT_TYPE
	SUM(CASE WHEN OP.payment_type = 'Credit_Card' AND O.channel = 'Phone Delivery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Phone_Credit_pay,
	SUM(CASE WHEN OP.payment_type = 'Debit_Card' AND O.channel = 'Phone Delivery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Phone_Debit_pay,
	SUM(CASE WHEN OP.payment_type = 'UPI/Cash' AND O.channel = 'Phone Delivery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Phone_UPI_Cash_pay,
	SUM(CASE WHEN OP.payment_type = 'Voucher' AND O.channel = 'Phone Delivery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Phone_Voucher_pay,

	-- BABY  
	COUNT(DISTINCT CASE WHEN P.Category = 'Baby' THEN (O.order_id) ELSE NULL END) AS BABY_NO_TRANS,
	COUNT(CASE WHEN P.Category = 'Baby' THEN (O.product_id) ELSE NULL END) AS  BABY_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Baby' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS BABY_MONETARY,
	SUM(CASE WHEN P.Category = 'Baby' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS  BABY_PROFIT,
	SUM(CASE WHEN P.Category = 'Baby' THEN (O.Discount) ELSE 0 END) AS BABY_TOT_DISCOUNT,

	-- AUTO  
	COUNT(DISTINCT CASE WHEN P.Category = 'Auto' THEN (O.order_id) ELSE NULL END) AS AUTO_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Auto' THEN (O.product_id) ELSE NULL END) AS AUTO_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Auto' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS AUTO_MONETARY,
	SUM(CASE WHEN P.Category = 'Auto' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS AUTO_PROFIT,
	SUM(CASE WHEN P.Category = 'Auto' THEN (O.Discount) ELSE 0 END) AS AUTO_TOT_DISCOUNT,
	
	-- FASHION  
	COUNT(DISTINCT CASE WHEN P.Category = 'Fashion' THEN (O.order_id) ELSE NULL END) AS FASHION_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Fashion' THEN (O.product_id) ELSE NULL END) AS FASHION_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS FASHION_MONETARY,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS FASHION_PROFIT,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (O.Discount) ELSE 0 END) AS FASHION_TOT_DISCOUNT,
	
	-- FOOD & BEVERAGES  
	COUNT(DISTINCT CASE WHEN P.Category = 'Food & Beverages' THEN (O.order_id) ELSE NULL END) AS FOOD_BEVEGERS_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Food & Beverages' THEN (O.product_id) ELSE NULL END) AS FOOD_BEVEGERS_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS FOOD_BEVEGERS_MONETARY,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS FOOD_BEVEGERS_PROFIT ,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (O.Discount) ELSE 0 END) FOOD_BEVEGERS_TOT_DISCOUNT,
	
	-- FURNITURE  
	COUNT(DISTINCT CASE WHEN P.Category = 'Furniture' THEN (O.order_id) ELSE NULL END) AS FURNITURE_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Furniture' THEN (O.product_id) ELSE NULL END) AS FURNITURE_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS FURNITURE_MONETARY,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS FURNITURE_PROFIT,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (O.Discount) ELSE 0 END) AS FURNITURE_TOT_DISCOUNT,
	
	-- HOME APPLIANCES 
	COUNT(DISTINCT CASE WHEN P.Category = 'Home_Appliances' THEN (O.order_id) ELSE NULL END) AS HOME_APPLIANCES_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Home_Appliances' THEN (O.product_id) ELSE NULL END) AS HOME_APPLIANCES_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS HOME_APPLIANCES_MONETARY,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS HOME_APPLIANCES_PROFIT,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (O.Discount) ELSE 0 END) AS HOME_APPLIANCES_TOT_DISCOUNT,
	
	-- LUGGAGE ACCESSORIES  
	COUNT(DISTINCT CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.order_id) ELSE NULL END) AS LUGGAGE_ACCESSORIES_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.product_id) ELSE NULL END) AS LUGGAGE_ACCESSORIES_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS LUGGAGE_ACCESSORIES_MONETARY,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS LUGGAGE_ACCESSORIES_PROFIT,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.Discount) ELSE 0 END) AS LUGGAGE_ACCESSORIES_TOT_DISC,
	
	-- PET SHOP  
	COUNT(DISTINCT CASE WHEN P.Category = 'Pet_Shop' THEN (O.order_id) ELSE NULL END) AS PET_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Pet_Shop' THEN (O.product_id) ELSE NULL END) AS PET_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS PET_MONETARY,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS PET_PROFIT,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (O.Discount) ELSE 0 END) AS PET_TOT_DISC,
	
	-- STATIONERY  
	COUNT(DISTINCT CASE WHEN P.Category = 'Stationery' THEN (O.order_id) ELSE NULL END) AS STATIONERY_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Stationery' THEN (O.product_id) ELSE NULL END) AS STATIONERY_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS STATIONERY_MONETARY,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS STATIONERY_PROFIT,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (O.Discount) ELSE 0 END) AS STATIONERY_TOT_DISC,
	
	-- TOYS & GIFTS  
	COUNT(DISTINCT CASE WHEN P.Category = 'Toys & Gifts' THEN (O.order_id) ELSE NULL END) AS TOYD_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.product_id) ELSE NULL END) AS TOYS_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS TOYS_MONETARY,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS TOYS_PROFIT,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.Discount) ELSE 0 END) AS TOYS_TOT_DISC,
	
	-- COMPUTERS & ACCESSORIES  
	COUNT(DISTINCT CASE WHEN P.Category = 'Computers & Accessories' THEN (O.order_id) ELSE NULL END) AS COMPUTER_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.product_id) ELSE NULL END) AS COMPUTER_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS COMPUTER_MONETARY,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS COMPUTER_PROFIT,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.Discount) ELSE 0 END) AS COMPUTER_TOT_DISC,
	
	-- CONSTRUCTION TOOLS  
	COUNT(DISTINCT CASE WHEN P.Category = 'Construction_Tools' THEN (O.order_id) ELSE NULL END) AS CONSTRUCTION_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Construction_Tools' THEN (O.product_id) ELSE NULL END) AS CONSTRUCTION_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS CONSTRUCTION_MONETARY,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS CONSTRUCTION_PROFIT,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (O.Discount) ELSE 0 END) AS CONSTRUCTION_TOT_DIS,
	
	-- ELECTRONICS  
	COUNT(DISTINCT CASE WHEN P.Category = 'Electronics' THEN (O.order_id) ELSE NULL END) AS ELECTRONICS_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Electronics' THEN (O.product_id) ELSE NULL END) AS ELECTRONICS_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS ELECTRONICS_MONETARY,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS ELECTRONICS_PROFIT,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (O.Discount) ELSE 0 END) AS ELECTRONICS_TOT_DISC
INTO STORE_360
FROM Store_level as S
INNER JOIN Order_6 AS O 
ON O.Delivered_StoreID = S.StoreID
INNER JOIN Customers$ AS C
ON O.Customer_id = C.Custid
INNER JOIN ProductsInfo$ AS P
ON O.product_id = P.product_id
INNER JOIN OrderPayments$ AS OP
ON O.order_id = OP.order_id
GROUP BY S.StoreID, seller_city,seller_state,Region 
ORDER BY Total_orders
---------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM STORE_360

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------