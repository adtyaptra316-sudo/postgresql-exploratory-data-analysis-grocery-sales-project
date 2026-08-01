/*
========================================
Measuere Exploration
========================================
Purpose:
	- To calculate aggregated metrics (e.g., sum, avg)
	- To identify overall trends or spot anomalies
*/
-- find the total sales
select sum(total_price) as total_sales  from gold.fact_sales;

-- find the average selling price
select avg(total_price) as average_price from gold.fact_sales;

-- find how much quantity sold
select sum(quantity) as total_quantity from gold.fact_sales;

-- find the total transaction
select count(sales_id) as total_transaction from gold.fact_sales;

-- find total unique products sold
select count(distinct product_id) as  total_product from gold.fact_sales;

-- find total unique customers with transaction
select count(distinct customer_id) as total_customer from gold.fact_sales;


-- Generate a Report that shows all key metrics of the business
select 'Total Sales' as measure_name,sum(total_price) as measure_value  from gold.fact_sales
union all
select 'Average Price' ,avg(total_price) from gold.fact_sales
union all
select 'Total Quantity' ,sum(quantity) from gold.fact_sales
union all
select 'Total Transaction', count(sales_id) from gold.fact_sales
union all
select 'Total Products', count(distinct product_id) from gold.fact_sales
union all
select 'Total Customers', count(distinct customer_id) from gold.fact_sales;
