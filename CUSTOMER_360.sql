USE INTERN

-------------------------------------------------- For Customer_360 TABLE --------------------------------------------------------------------------------
 
--------------- Customer_360 has 98,314 records 

SELECT * FROM CUSTOMER_360

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT C.*,
    FORMAT(MIN(Bill_date_timestamp), 'yyyy-MM-dd') AS First_Tran_Date,
    FORMAT(MAX(Bill_date_timestamp), 'yyyy-MM-dd') AS Last_Trans_Date,
    DATEDIFF(DAY, MAX(Bill_date_timestamp), MIN(Bill_date_timestamp)) AS Tenure,
	DATEDIFF (DAY, MAX (Bill_date_timestamp),(SELECT MAX(Bill_date_timestamp) FROM ORDER_FINAL)) AS Inactive_days,
	COUNT(DISTINCT [Total Amount]) AS Frequency,
	SUM([Total Amount]) AS Monetary,
	SUM([Total Amount]) - SUM((Quantity * [Cost Per Unit])) AS Profit,
	SUM(Discount) AS TOT_DISCOUNT, 
	SUM(Quantity) AS TOT_QTY,
	COUNT(DISTINCT O.product_id) AS Distinct_Purchased,
	COUNT(DISTINCT Category) AS Distinct_Category,
	COUNT(CASE WHEN O.MRP > O.[Cost Per Unit] THEN O.MRP END) AS Transactions_With_Discount,
	COUNT(CASE WHEN O.[Total Amount] < (O.Quantity * O.[Cost Per Unit]) THEN 1 END) AS Transactions_With_Loss,
	COUNT(DISTINCT O.CHANNEL) AS Channels_Used,
	COUNT(DISTINCT Delivered_StoreID) AS Distinct_StoreID,
	COUNT(DISTINCT customer_city) AS Distinct_City,
	COUNT(DISTINCT payment_type) AS Distinct_Payment_type,
	SUM(CASE WHEN OP.payment_type = 'voucher' THEN [Total Amount] ELSE 0 END) AS TRANS_VOUCHER,
	SUM(CASE WHEN OP.payment_type = 'credit card' THEN [Total Amount] ELSE 0 END) AS TRANS_CREDIT,
	SUM(CASE WHEN OP.payment_type = 'DEBIT' THEN [Total Amount] ELSE 0 END) AS TRANS_DEBIT,
	SUM(CASE WHEN OP.payment_type = 'UPI/CASH' THEN [Total Amount] ELSE 0 END) AS TRANS_UPI_CASH,
    COUNT(OP.payment_type) AS Preferred_Pay_Method,
	SUM([Total Amount]) AS Total_Spend, 
	 CASE 
        WHEN SUM([Total Amount]) <= 500 THEN 'Low'
        WHEN SUM([Total Amount]) > 500 AND SUM([Total Amount]) <= 1000 THEN 'Medium'
        ELSE 'High'
    END AS Customer_Segment,
-- FOR INSTORE CHANNEL 
	COUNT(DISTINCT CASE WHEN O.channel = 'INSTORE' THEN [Total Amount] END) AS Distinct_Transactions_INSTORE,
	SUM(CASE WHEN O.[Channel] = 'INSTORE' THEN [Total Amount] ELSE 0 END) AS INSTORE_MONETORY,
	SUM(CASE WHEN O.Channel = 'INSTORE' THEN ([Total Amount]) - (Quantity * [Cost Per Unit]) ELSE 0 END) AS INSTORE_PROFIT,
	SUM(CASE WHEN O.Channel = 'INSTORE' THEN Discount ELSE 0 END) AS INSTORE_TOT_DISCOUNT,
	SUM(CASE WHEN O.Channel = 'INSTORE' THEN Quantity ELSE 0 END) AS INSTORE_TOT_QTY,
	COUNT(DISTINCT CASE WHEN O.Channel = 'INSTORE' THEN O.product_id END) AS INSTORE_DIS_PURCHASED,
	COUNT(DISTINCT CASE WHEN O.Channel = 'INSTORE' AND O.MRP > O.[Cost Per Unit] THEN 1 END) AS INSTORE_DIS_DISCOUNT,
	COUNT(CASE WHEN O.Channel = 'INSTORE' AND O.[Total Amount] < (O.Quantity * O.[Cost Per Unit]) THEN 1 END) AS INSTORE_LOSS,
	COUNT(CASE WHEN O.Channel = 'INSTORE' THEN O.Channel END) AS INSTORE_CHANNEL,
	COUNT(DISTINCT CASE WHEN O. Channel = 'INSTORE' THEN Delivered_StoreID END) AS INSTORE_DIS_STOREID,
	COUNT(DISTINCT CASE WHEN O.Channel = 'INSTORE' THEN customer_city END) AS INSTORE_DIS_CITY,
	COUNT(DISTINCT CASE WHEN O.Channel = 'INSTORE' THEN payment_type END) AS INSTORE_PAY_TYPE,
	SUM(CASE WHEN O.Channel = 'INSTORE' AND OP.payment_type = 'VOUCHER' THEN [Total Amount] ELSE 0 END) AS Instore_VOUCHER_TRANS,
	SUM(CASE WHEN O.Channel = 'INSTORE' AND OP.payment_type = 'CREDIT CARD' THEN [Total Amount] ELSE 0 END) AS Instore_CREDIT_TRANS,
	SUM(CASE WHEN O.Channel = 'INSTORE' AND OP.payment_type = 'UPI/CASH' THEN [Total Amount] ELSE 0 END) AS Instore_UPI_CASH_TRANS,
	SUM(CASE WHEN O.Channel = 'INSTORE' AND OP.payment_type = 'DEBIT' THEN [Total Amount] ELSE 0 END) AS Instore_DEBIT_TRANS,
-- FOR ONLINE CHANNEL 
	COUNT(DISTINCT CASE WHEN O.channel = 'ONLINE' THEN [Total Amount] END) AS Distinct_Transactions_ONLINE,
	SUM(CASE WHEN O.[Channel] = 'ONLINE' THEN [Total Amount] ELSE 0 END) AS ONLINE_MONETORY,
	SUM(CASE WHEN O.Channel = 'ONLINE' THEN ([Total Amount]) - (Quantity * [Cost Per Unit]) ELSE 0 END) AS ONLINE_PROFIT,
	SUM(CASE WHEN O.Channel = 'ONLINE' THEN Discount ELSE 0 END) AS ONLINE_TOT_DISCOUNT,
	SUM(CASE WHEN O.Channel = 'ONLINE' THEN Quantity ELSE 0 END) AS ONLINE_TOT_QTY,
	COUNT(DISTINCT CASE WHEN O.Channel = 'ONLINE' THEN O.product_id END) AS ONLINE_DIS_PURCHASED,
	COUNT(DISTINCT CASE WHEN O.Channel = 'ONLINE' AND O.MRP > O.[Cost Per Unit] THEN 1 END) AS ONLINE_DIS_DISCOUNT,
	COUNT(CASE WHEN O.Channel = 'ONLINE' AND O.[Total Amount] < (O.Quantity * O.[Cost Per Unit]) THEN 1 END) AS ONLINE_LOSS,
	COUNT(CASE WHEN O.Channel = 'ONLINE' THEN O.Channel END) AS ONLINE_CHANNEL,
	COUNT(DISTINCT CASE WHEN O. Channel = 'ONLINE' THEN Delivered_StoreID END) AS ONLINE_DIS_STOREID,
	COUNT(DISTINCT CASE WHEN O.Channel = 'ONLINE' THEN customer_city END) AS ONLINE_DIS_CITY,
	COUNT(DISTINCT CASE WHEN O.Channel = 'ONLINE' THEN payment_type END) AS ONLINE_PAY_TYPE,
	SUM(CASE WHEN O.Channel = 'ONLINE' AND OP.payment_type = 'VOUCHER' THEN [Total Amount] ELSE 0 END) AS Online_VOUCHER_TRANS,
	SUM(CASE WHEN O.Channel = 'ONLINE' AND OP.payment_type = 'CREDIT CARD' THEN [Total Amount] ELSE 0 END) AS Online_CREDIT_TRANS,
	SUM(CASE WHEN O.Channel = 'ONLINE' AND OP.payment_type = 'UPI/CASH' THEN [Total Amount] ELSE 0 END) AS Online_UPI_CASH_TRANS,
	SUM(CASE WHEN O.Channel = 'ONLINE' AND OP.payment_type = 'DEBIT' THEN [Total Amount] ELSE 0 END) AS Online_DEBIT_TRANS,
-- FOR PHONE DELIVERY CHANNEL
	COUNT(DISTINCT CASE WHEN O.channel = 'PHONE DELIVERY' THEN [Total Amount] END) AS Distinct_Transactions_Phone,
	SUM(CASE WHEN O.[Channel] = 'PHONE DELIVERY' THEN [Total Amount] ELSE 0 END) AS Phone_MONETORY,
	SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN ([Total Amount]) - (Quantity * [Cost Per Unit]) ELSE 0 END) AS Phone_PROFIT,
	SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN Discount ELSE 0 END) AS Phone_TOT_DISCOUNT,
	SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN Quantity ELSE 0 END) AS Phone_TOT_QTY,
	COUNT(DISTINCT CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.product_id END) AS Phone_DIS_PURCHASED,
	COUNT(DISTINCT CASE WHEN O.Channel = 'PHONE DELIVERY' AND O.MRP > O.[Cost Per Unit] THEN 1 END) AS Phone_DIS_DISCOUNT,
	COUNT(CASE WHEN O.Channel = 'PHONE DELIVERY' AND O.[Total Amount] < (O.Quantity * O.[Cost Per Unit]) THEN 1 END) AS Phone_LOSS,
	COUNT(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.Channel END) AS Phone_CHANNEL,
	COUNT(DISTINCT CASE WHEN O. Channel = 'PHONE DELIVERY' THEN Delivered_StoreID END) AS Phone_DIS_STOREID,
	COUNT(DISTINCT CASE WHEN O.Channel = 'PHONE DELIVERY' THEN customer_city END) AS Phone_DIS_CITY,
	COUNT(DISTINCT CASE WHEN O.Channel = 'PHONE DELIVERY' THEN payment_type END) AS Phone_PAY_TYPE,
	SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' AND OP.payment_type = 'VOUCHER' THEN [Total Amount] ELSE 0 END) AS Phone_VOUCHER_TRANS,
	SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' AND OP.payment_type = 'CREDIT CARD' THEN [Total Amount] ELSE 0 END) AS Phone_CREDIT_TRANS,
	SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' AND OP.payment_type = 'UPI/CASH' THEN [Total Amount] ELSE 0 END) AS Phone_UPI_CASH_TRANS,
	SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' AND OP.payment_type = 'DEBIT' THEN [Total Amount] ELSE 0 END) AS Phone_DEBIT_TRANS,
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

--INTO CUSTOMER_360
FROM Customers$ AS C
INNER JOIN ORDER_FINAL AS O
ON C.Custid = O.Customer_id
INNER JOIN ProductsInfo$ AS P
ON O.product_id = P.product_id
INNER JOIN OrderPayments$ AS OP
ON O.order_id = OP.order_id
GROUP BY C.Custid, customer_city, customer_state, Gender 

-----------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM CUSTOMER_360

----------------------------------------------------------------------------------------------------------------------------------------------------------------------