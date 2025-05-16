# Retail-Analytics-for-Sales-CRM-Optimization

- Tools Used: Excel
        SQL Server Management Studio
- Available Data: 
Data has been provided from Sep 2021 to Oct 2023 for randomly selected 39 stores out of 535 stores for specific categories of products for randomly selected customers. Didn't provide data dictionary since all the variables are very intutive. Do send mail to your POC for any clarifications.
Note: Ideal relationship between the tables, one customer can have multiple order id's, one orderid can have multiple items.

- Expectation: 
You are expected to perform data auditing, data cleaning (if required) in SQL. List down your observations related data related issues. Process your data based on the assumptions you can make.
Also, create 3 tables (customer level (one record for each customer), order level(one record for each order), store level(one record for each store)) using the above data after cleaning the data (Note: You are required to create tables with maximum possible variables, you can directly leverage these tables in the below analysis wherever needed)

- List of Analysis
1. Perform Detailed exploratory analysis
   - Define & calculate high-level metrics like (The number of orders, Total Discount, Average discount per customer, Average discount per order, Average order value or Average Bill Value, Average Sales per Customer, Average profit per customer, average number of categories per order, average number of items per order, Number of customers, Transactions per Customer, Total Revenue, Total Profit,  Total Cost, Total quantity, Total products, Total categories, Total stores, Total locations, Total Regions, Total channels, Total payment methods, Average number of days between two transactions (if the customer has more than one transaction), percentage of profit, percentage of discount, Repeat purchase rate, Repeat customer percentage, One time buyers percentage etc…)
   - Understanding how many new customers acquired every month (who made transaction first time in the data)
   - Understand the retention of customers on month on month basis
   - How the revenues from existing/new customers on monthly basis
   - Understand the trends/seasonality of sales, quantity by category, region, store, channel, payment method etc…
   - Popular categories/Popular Products by store, state, region.
   - List the top 10 most expensive products sorted by price and their contribution to sales
   - Which products appeared in the transactions?
   - Top 10-performing & worst 10 performance stores in terms of sales

2. Customer Behaviour
   - Segment the customers (divide the customers into groups) based on the revenue
   - Divide the customers into groups based on Recency, Frequency, and Monetary (RFM Segmentation) -  Divide the customers into Premium, Gold, Silver, Standard customers and understand the behaviour of each segment of customers
   - Find out the number of customers who purchased in all the channels and find the key metrics.
   - Understand the behavior of one time buyers and repeat buyers
   - Understand the behavior of discount seekers & non discount seekers
   - Understand preferences of customers (preferred channel, Preferred payment method, preferred store, discount preference, preferred categories etc.)
   - Understand the behavior of customers who purchased one category and purchased multiple categories

3. Cross-Selling (Which products are selling together)
   - Hint: We need to find which of the top 10 combinations of products are selling together in each transaction.  (combination of 2 or 3 buying together)

4. Understand the Category Behavior
   - Total Sales & Percentage of sales by category (Perform Pareto Analysis)
   - Most profitable category and its contribution
   - Category Penetration Analysis by month on month (Category Penetration = number of orders containing the category/number of orders)
   - Most popular category during first purchase of customer

5. Customer satisfaction towards category & product
   - Which categories (top 10) are maximum rated & minimum rated and average rating score?
   - Average rating by location, store, product, category, month, etc.

6. Perform cohort analysis (customer retention for month on month and retention for fixed month)
   - Customers who started in each month and understand their behavior in the respective months 
(Example: If 100 new customers started in Jan -2023, how is the 100 new customer behavior (in terms of purchases, revenue, etc..) in Feb-2023, Mar-2023, Apr-2023, etc...)
Which Month cohort has maximum retention?

7. Perform analysis related to Sales Trends, patterns, and seasonality.
   - Which months have had the highest sales, what is the sales amount and contribution in percentage?
   - Which months have had the least sales, what is the sales amount and contribution in percentage?
   - Sales trend by month
   - Is there any seasonality in the sales (weekdays vs. weekends, months, days of week, weeks etc.)?
   - Total Sales by Week of the Day, Week, Month, Quarter, Weekdays vs. weekends etc.
