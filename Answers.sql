USE Ecommerce_db;
SELECT * FROM customers;

/* Problem statement
For each product category, calculate the unique number of customers purchasing from it.
 */


SELECT COUNT(DISTINCT o.customer_id) as unique_customers, category
FROM orders o
JOIN orderdetails od ON o.order_id=od.order_id 
JOIN products p ON od.product_id=p.product_id
Group BY category
ORDER BY unique_customers DESC
;

/*
Problem statement
Analyze the month-on-month percentage change in total sales to identify growth trends.
*/

SELECT Month, total_revenue, 
LAG(total_revenue) OVER(ORDER BY Month) as Previous_month_rev, 
((total_revenue - (LAG(total_revenue) OVER(ORDER BY Month)))*100 /  ( LAG(total_revenue) OVER(ORDER BY Month) )   ) as Percentage_change
FROM(
SELECT  date_format(order_date, '%Y-%m') as Month, SUM(total_amount) as total_revenue
FROM orders
GROUP BY date_format(order_date, '%Y-%m')
) as subq
ORDER BY Month;


/*
Problem statement
Examine how the average order value changes month-on-month. 
Insights can guide pricing and promotional strategies to enhance order value.

Query Description:
Use the “Orders” Table.
Return the result table which will help you get the month (YYYY-MM), Average order value and Change in the average order value (Present month value- Previous month value).
The resulting change in average order value should be rounded to 2 decimal places and should be ordered in descending order.
*/

SELECT Month, AvgOrderValue, LAG(AvgOrderValue) OVER( ORDER BY Month) as PreviousAvg, 
((AvgOrderValue - LAG(AvgOrderValue) OVER( ORDER BY Month))) as ChangeInValue
FROM (
SELECT date_format(order_date, '%Y-%m') as Month, AVG(total_amount) as AvgOrderValue
FROM orders
GROUP BY date_format(order_date, '%Y-%m')
) as subq
;


/* 
Problem statement
List products purchased by less than 40% of the customer base, 
indicating potential mismatches between inventory and customer interest.

Query Description:
Use the “Products”, “Orders”, “OrderDetails” and “Customers” table.
Return the result table which will help you get the product names along with the count of unique customers 
who belong to the lower 40% of the customer pool.
*/

SELECT sub.product_id, p.name, sub.UniqueCustomer
FROM 
(SELECT od.product_id, COUNT( DISTINCT customer_id) as UniqueCustomer
FROM orderdetails od
JOIN orders o ON od.order_id = o.order_id
GROUP BY od.product_id
)as sub JOIN products p ON sub.product_id = p.product_id
WHERE sub.UniqueCustomer < 0.4*(SELECT COUNT(customer_id) FROM customers)
;


/* 
Problem statement
Evaluate the month-on-month growth rate in the customer base to understand the effectiveness of marketing campaigns 
and market expansion efforts.

Query Description:
Use the “Orders” table.
Return the result table which will help you get the count of the number of customers who made the first purchase on monthly basis.
The resulting table should be ascendingly ordered according to the month.
*/

SELECT FirstPurchaseMonth, COUNT(customer_id) as newCustomersCount
FROM 
(SELECT MIN(date_format(order_date, '%Y-%m')) as FirstPurchaseMonth, customer_id 
FROM orders
GROUP BY customer_id
ORDER BY customer_id
) as sub
GROUP BY FirstPurchaseMonth
ORDER BY FirstPurchaseMonth;

/*
Problem statement
Identify the months with the highest sales volume, aiding in planning for stock levels, 
marketing efforts, and staffing in anticipation of peak demand periods.

Query Description:
Use the “Orders” table.
Return the result table which will help you get the month (YYYY-MM) and the Total sales made by the company limiting to top 3 months.
The resulting table should be in descending order suggesting the highest sales month.
*/

SELECT date_format(order_date,'%Y-%m') as Month, SUM(total_amount) as totalSales
FROM orders
GROUP BY date_format(order_date,'%Y-%m')
ORDER BY totalSales DESC;

