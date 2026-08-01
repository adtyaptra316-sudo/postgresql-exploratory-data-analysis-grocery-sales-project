/*
========================================
Ranking Analysis
========================================
Purpose:
	- To rank items (e.g., products, customers) based on performance or other metrics.
	- To identify top performers or laggards.
*/
-- Top 5 employees by total transactions
select *
from (select
	de.employee_name,
	count(fs.sales_id) as total_transactions,
	dense_rank()over (order by count(fs.sales_id) desc) as rank_employee
from gold.fact_sales fs
left join gold.dim_employees de 
on fs.employee_id=de.employee_id 
group by de.employee_name
	) as ranked_employee
where rank_employee <=5;

-- Find the top 10 customers who have generated the highest revenue
select dc.customer_name, sum(fs.total_price) as total_sales
from gold.fact_sales fs
left join gold.dim_customers dc 
on fs.customer_id =dc.customer_id 
group by customer_name 
order by total_sales desc
limit 10;

-- Which 5 products Generating the Highest Revenue?
select dp.product_name, sum(fs.total_price) as total_sales
from gold.fact_sales fs
left join gold.dim_products dp 
on fs.product_id=dp.product_id 
group by dp.product_name 
order by total_sales desc
limit 5;

-- Find the top 3 cities with highest revenue
select dc.city_name, sum(fs.total_price) as total_sales
from gold.fact_sales fs
left join gold.dim_customers dc 
on fs.customer_id =dc.customer_id 
group by dc.city_name 
order by total_sales desc
limit 3;
