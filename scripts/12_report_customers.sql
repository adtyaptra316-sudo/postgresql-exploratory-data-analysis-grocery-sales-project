/*
========================================
Customer Report
========================================
Purpose:
	This report consolidates key customers metrics and behavior

	Highlights:
	1. Gathers essential fields such as names, city, and transaction details.
	2. Segments customers into categories (VVIP, VIP, Regular,Basic).
	3. Aggregates customer-level metrics:
	- total transactions
	- total sales
	- total quantity purchased
	- total products
	4. Calculates valuable KPIs:
	- average order value
	- average monthly spend
*/

create or replace view gold.report_customers
as
with base_customers as (
/*
-----------------------------------
Base query: retrieves core columns from table
-----------------------------------
 */
select
	fs.sales_id,
	fs.sales_date,
	fs.product_id,
	fs.quantity,
	fs.total_price,
	dc.customer_id,
	dc.customer_name,
	dc.country_name,
	dc.city_name,
	dc.addres
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_id=dc.customer_id
),
customers_aggregation as (
/*
-----------------------------------
Customer aggregation: summarizes key metrics at the customers level
-----------------------------------
 */
select
	customer_id,
	customer_name,
	country_name,
	city_name,
	addres,
	count(sales_id) as total_transactions,
	sum(total_price) as total_sales,
	sum(quantity) as total_quantity_purchased,
	count(distinct product_id) as total_products,
	max(sales_date) as last_transaction_date
from base_customers 
group by customer_id, customer_name, country_name, city_name, addres
)
select 
	customer_id,
	customer_name,
	-- customers segmentations
	case
		when total_sales > 100000 then 'VVIP'
		when total_sales between 80000 and 100000 then 'VIP'
		when total_sales between 10000 and 80000 then 'Regular'
		else 'Basic'
	end as customer_category,
	country_name,
	city_name,
	addres,
	total_transactions,
	total_sales,
	-- compute average sales value 
	total_sales / total_transactions as avg_per_transaction,
	total_quantity_purchased,
	total_products,
	last_transaction_date
from customers_aggregation;
