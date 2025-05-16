USE INTERN

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------ORDER_360 TABLE----------------------------------------------------------------

-- Order_360 has 104788 rows


SELECT * FROM ORDER_360

---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT O.*,
	Cust_satisfaction_Score,
	Category,
	payment_type,
	COUNT(DISTINCT O.product_id) AS NO_OF_ITEMS,
	YEAR(Bill_date_timestamp) AS YEAR,
	MONTH(Bill_date_timestamp) AS MONTH,
	SUM([Total Amount]) - SUM((Quantity * [Cost Per Unit])) AS Profit,
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
	-- Amount paid using Credit Card in Instore
	SUM(CASE WHEN OP.payment_type = 'Credit_Card' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_Credit_pay,
	-- Amount paid using Debit Card in Instore
	SUM(CASE WHEN OP.payment_type = 'Debit_Card' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_Debit_pay,
	-- Amount paid using UPI/Cash in Instore
	SUM(CASE WHEN OP.payment_type = 'UPI/Cash' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_UPI_Cash_pay,
	-- Amount paid using Voucher in Instore
	SUM(CASE WHEN OP.payment_type = 'Voucher' AND O.channel = 'Instore' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Instore_Voucher_pay,
	--ONLINE
    SUM(CASE WHEN O.Channel = 'ONLINE' THEN O.[Total Amount] ELSE 0 END) AS Online_Revenue,
    COUNT(CASE WHEN O.Channel = 'ONLINE' THEN O.order_id END) AS Online_Orders,
    SUM(CASE WHEN O.Channel = 'ONLINE' THEN O.Quantity ELSE 0 END) AS Online_Quantity,
    SUM(CASE WHEN O.Channel = 'ONLINE' THEN (O.[Total Amount] - (O.Quantity * O.[Cost Per Unit])) ELSE 0 END) AS Online_Profit,
    SUM(CASE WHEN O.Channel = 'ONLINE' THEN O.Discount ELSE 0 END) AS Online_Discount,
	-- Amount paid using Credit Card in Online
	SUM(CASE WHEN OP.payment_type = 'Credit_Card' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_Credit_pay,
	-- Amount paid using Debit Card in Online
	SUM(CASE WHEN OP.payment_type = 'Debit_Card' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_Debit_pay,
	-- Amount paid using UPI/Cash in Online
	SUM(CASE WHEN OP.payment_type = 'UPI/Cash' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_UPI_Cash_pay,
	-- Amount paid using Voucher in Online
	SUM(CASE WHEN OP.payment_type = 'Voucher' AND O.channel = 'Online' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Online_Voucher_pay,
		--PHONE_DELIVERY
    SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.[Total Amount] ELSE 0 END) AS Phone_Revenue,
    COUNT(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.order_id END) AS Phone_Orders,
    SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.Quantity ELSE 0 END) AS Phone_Quantity,
    SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN (O.[Total Amount] - (O.Quantity * O.[Cost Per Unit])) ELSE 0 END) AS Phone_Profit,
    SUM(CASE WHEN O.Channel = 'PHONE DELIVERY' THEN O.Discount ELSE 0 END) AS Phone_Discount,
	-- Amount paid using Credit Card in Phone Delivery
	SUM(CASE WHEN OP.payment_type = 'Credit_Card' AND O.channel = 'Phone Delivery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Phone_Credit_pay,
	-- Amount paid using Debit Card in Phone Delivery
	SUM(CASE WHEN OP.payment_type = 'Debit_Card' AND O.channel = 'Phone Delivery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Phone_Debit_pay,
	-- Amount paid using UPI/Cash in Phone Delivery
	SUM(CASE WHEN OP.payment_type = 'UPI/Cash' AND O.channel = 'Phone Delivery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Phone_UPI_Cash_pay,
	-- Amount paid using Voucher in Phone Delivery
	SUM(CASE WHEN OP.payment_type = 'Voucher' AND O.channel = 'Phone Delivery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END ) AS Phone_Voucher_pay,
	--CATEGORY LEVEL
	-- BABY 
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS BABY_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS BABY_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Baby' THEN (O.order_id) ELSE NULL END) AS BABY_NO_TRANS,
	COUNT(CASE WHEN P.Category = 'Baby' THEN (O.product_id) ELSE NULL END) AS  BABY_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Baby' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS BABY_MONETARY,
	SUM(CASE WHEN P.Category = 'Baby' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS  BABY_PROFIT,
	SUM(CASE WHEN P.Category = 'Baby' THEN (O.Discount) ELSE 0 END) AS BABY_TOT_DISCOUNT,
	--AUTO
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS AUTO_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS AUTO_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Auto' THEN (O.order_id) ELSE NULL END) AS AUTO_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Auto' THEN (O.product_id) ELSE NULL END) AS AUTO_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Auto' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS AUTO_MONETARY,
	SUM(CASE WHEN P.Category = 'Auto' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS AUTO_PROFIT,
	SUM(CASE WHEN P.Category = 'Auto' THEN (O.Discount) ELSE 0 END) AS AUTO_TOT_DISCOUNT,
	--FASHION 
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS FASHION_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS FASHION_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Fashion' THEN (O.order_id) ELSE NULL END) AS FASHION_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Fashion' THEN (O.product_id) ELSE NULL END) AS FASHION_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS FASHION_MONETARY,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS FASHION_PROFIT,
	SUM(CASE WHEN P.Category = 'Fashion' THEN (O.Discount) ELSE 0 END) AS FASHION_TOT_DISCOUNT,
	--FOOD & BEVEGERS 
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS FOOD_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS FOOD_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Food & Beverages' THEN (O.order_id) ELSE NULL END) AS FOOD_BEVEGERS_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Food & Beverages' THEN (O.product_id) ELSE NULL END) AS FOOD_BEVEGERS_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS FOOD_BEVEGERS_MONETARY,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS FOOD_BEVEGERS_PROFIT ,
	SUM(CASE WHEN P.Category = 'Food & Beverages' THEN (O.Discount) ELSE 0 END) FOOD_BEVEGERS_TOT_DISCOUNT,
	--FURNITURE
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS FURNITURE_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS FURNITURE_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Furniture' THEN (O.order_id) ELSE NULL END) AS FURNITURE_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Furniture' THEN (O.product_id) ELSE NULL END) AS FURNITURE_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS FURNITURE_MONETARY,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS FURNITURE_PROFIT,
	SUM(CASE WHEN P.Category = 'Furniture' THEN (O.Discount) ELSE 0 END) AS FURNITURE_TOT_DISCOUNT,
	-- HOME APPLIANCES 
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS HOME_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS HOME_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Home_Appliances' THEN (O.order_id) ELSE NULL END) AS HOME_APPLIANCES_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Home_Appliances' THEN (O.product_id) ELSE NULL END) AS HOME_APPLIANCES_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS HOME_APPLIANCES_MONETARY,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS HOME_APPLIANCES_PROFIT,
	SUM(CASE WHEN P.Category = 'Home_Appliances' THEN (O.Discount) ELSE 0 END) AS HOME_APPLIANCES_TOT_DISCOUNT,
	-- LUGGAGE ACCESSORIES  
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS LUGGAGE_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS LUGGAGE_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.order_id) ELSE NULL END) AS LUGGAGE_ACCESSORIES_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.product_id) ELSE NULL END) AS LUGGAGE_ACCESSORIES_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS LUGGAGE_ACCESSORIES_MONETARY,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS LUGGAGE_ACCESSORIES_PROFIT,
	SUM(CASE WHEN P.Category = 'Luggage_Accessories' THEN (O.Discount) ELSE 0 END) AS LUGGAGE_ACCESSORIES_TOT_DISC,
	-- PET SHOP  
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS PET_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS PET_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Pet_Shop' THEN (O.order_id) ELSE NULL END) AS PET_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Pet_Shop' THEN (O.product_id) ELSE NULL END) AS PET_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS PET_MONETARY,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS PET_PROFIT,
	SUM(CASE WHEN P.Category = 'Pet_Shop' THEN (O.Discount) ELSE 0 END) AS PET_TOT_DISC,
	-- STATIONERY
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS STATIONERY_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS STATIONERY_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Stationery' THEN (O.order_id) ELSE NULL END) AS STATIONERY_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Stationery' THEN (O.product_id) ELSE NULL END) AS STATIONERY_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS STATIONERY_MONETARY,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS STATIONERY_PROFIT,
	SUM(CASE WHEN P.Category = 'Stationery' THEN (O.Discount) ELSE 0 END) AS STATIONERY_TOT_DISC,
	--TOYS & GIFTS
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS TOYS_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS TOYS_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Toys & Gifts' THEN (O.order_id) ELSE NULL END) AS TOYD_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.product_id) ELSE NULL END) AS TOYS_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS TOYS_MONETARY,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS TOYS_PROFIT,
	SUM(CASE WHEN P.Category = 'Toys & Gifts' THEN (O.Discount) ELSE 0 END) AS TOYS_TOT_DISC,
	-- COMPUTERS & ACCESSORIES 
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS COMPUTERS_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS COMPUTERS_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Computers & Accessories' THEN (O.order_id) ELSE NULL END) AS COMPUTER_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.product_id) ELSE NULL END) AS COMPUTER_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS COMPUTER_MONETARY,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS COMPUTER_PROFIT,
	SUM(CASE WHEN P.Category = 'Computers & Accessories' THEN (O.Discount) ELSE 0 END) AS COMPUTER_TOT_DISC,
	-- CONSTRUCTION TOOLS
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS CONSTRUCTION_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS CONSTRUCTION_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Construction_Tools' THEN (O.order_id) ELSE NULL END) AS CONSTRUCTION_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Construction_Tools' THEN (O.product_id) ELSE NULL END) AS CONSTRUCTION_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS CONSTRUCTION_MONETARY,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS CONSTRUCTION_PROFIT,
	SUM(CASE WHEN P.Category = 'Construction_Tools' THEN (O.Discount) ELSE 0 END) AS CONSTRUCTION_TOT_DIS,
	-- ELECTRONICS 
	SUM(CASE WHEN P.Category = 'Baby' THEN [Total Amount] ELSE 0 END) AS ELECTRONICS_TOT_REVENUE,
	SUM(CASE WHEN P.Category = 'Baby' THEN Quantity ELSE 0 END) AS ELECTRONICS_TOT_QTY,
	COUNT(DISTINCT CASE WHEN P.Category = 'Electronics' THEN (O.order_id) ELSE NULL END) AS ELECTRONICS_NO_OF_TRANS,
	COUNT(CASE WHEN P.Category = 'Electronics' THEN (O.product_id) ELSE NULL END) AS ELECTRONICS_NO_OF_PROD,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (O.Quantity * (O.MRP - O.Discount)) ELSE 0 END) AS ELECTRONICS_MONETARY,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (O.Quantity * (O.MRP - O.Discount)) - (O.Quantity * O.[Cost Per Unit]) ELSE 0 END) AS ELECTRONICS_PROFIT,
	SUM(CASE WHEN P.Category = 'Electronics' THEN (O.Discount) ELSE 0 END) AS ELECTRONICS_TOT_DISC
	
INTO ORDER_360
FROM ORDER_FINAL AS O
INNER JOIN OrderPayments$ AS OP
ON O.order_id = OP.order_id
INNER JOIN ORDER_REVIEW AS R
ON O.order_id = R.order_id 
INNER JOIN ProductsInfo$ AS P
ON O.product_id = P.product_id
GROUP BY O.Customer_id, O.order_id,O.product_id, O.Channel,O.Delivered_StoreID, O.Bill_date_timestamp,
O.Quantity, O.[Cost Per Unit],O.MRP,O.Discount,O.[Total Amount],Category,payment_type, Cust_satisfaction_Score

---------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
