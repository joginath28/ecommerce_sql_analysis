-- ================================
-- E-commerce Sales Analysis Project
-- Author: Joginath
-- ================================


Describe sales_analysis.sales;

select *
from sales_analysis.sales
limit 20;

-- 1.Data cleaning
select *
from sales_analysis.sales
where customer_id is null
	or product_id is null
    or order_id is null
    or quantity is null
    or unit_price is null
    or discount is null
    or shipping_cost is null
    or total_sales is null;

select order_id, count(*) -- duplicates
from sales_analysis.sales
group by order_id
having count(*) > 1;

update sales
set total_sales = round(total_sales, 2);

select *
from sales_analysis.sales
limit 20;

alter table sales
drop column product_name; -- this column is filled with random words which is useless for analysis

-- 2.Analysis

select sum(total_sales)
from sales;

-- 2.1 total and average sales by catgory, and highest revenue generated category

select category, round(sum(total_sales), 2) as total_revenue, round(avg(total_sales), 2) as avg_revenue
from sales
group by category
order by total_revenue desc; 

-- 2.2 monthly revenue
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_sales) AS revenue
FROM sales
GROUP BY month
order by revenue;

-- 2.3 total and average sales by catgory, and highest revenue generated sub category
select sub_category, round(sum(total_sales), 2) as total_revenue, round(avg(total_sales), 2) as avg_revenue
from sales
group by sub_category
order by avg_revenue desc; 

-- 2.4 top selling sub categories
select sub_category, sum(quantity) as total_sold
from sales
group by sub_category
order by total_sold desc;


-- 2.5 top coustomers
SELECT customer_name, round(SUM(total_sales), 2) AS total_spending,
    RANK() OVER (ORDER BY SUM(total_sales) DESC) AS customer_rank
FROM sales
GROUP BY customer_name;

-- 2.6 most repeated customers
SELECT customer_name, COUNT(order_id) AS orders
FROM sales
GROUP BY customer_name
HAVING orders > 1 
order by orders desc;

-- 2.7 revenue by states
SELECT state, round(SUM(total_sales), 2) AS revenue,
    DENSE_RANK() OVER (ORDER BY SUM(total_sales) DESC) AS state_rank
FROM sales
GROUP BY state;

-- 2.8 average delivery time
SELECT AVG(DATEDIFF(delivery_date, order_date)) AS avg_days
FROM sales;

-- 2.9 number successful deliveries
select order_status, count( order_status) as count
from sales
group by order_status;

-- 2.10 most used payment methods
SELECT payment_method, COUNT(*) AS usage_,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales), 2) AS usage_percentage
FROM sales
GROUP BY payment_method
ORDER BY usage_ DESC;

-- 2.11 revenue by brand
SELECT brand, avg(total_sales) AS revenue
FROM sales
GROUP BY brand
ORDER BY revenue DESC;

-- 2.12 does discount affect total sales
select discount, round(avg(total_sales), 2) as avg_sales_per_discount,  
	round(avg(quantity*unit_price + shipping_cost), 2) as avg_sales_before_discount,
    round(avg((quantity*unit_price + shipping_cost) - total_sales), 2) as avg_lose_per_discount
from sales
group by discount;

-- 2.13 revenue before discount
select  round(avg(total_sales), 2) as avg_sales_per_discount,  
	round(avg(quantity*unit_price + shipping_cost), 2) as avg_sales_before_discount,
    round(avg((quantity*unit_price + shipping_cost) - total_sales), 2) as avg_lose_per_discount
from sales;


select *
from sales_analysis.sales
limit 20;