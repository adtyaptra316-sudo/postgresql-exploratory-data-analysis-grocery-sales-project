/*
========================================
Products Report
========================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, and price.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total discount
       - total customers (unique)
    4. Calculates valuable KPIs
       - average sales transaction
*/
create or replace view gold.report_products
as
with base_products as(
/*
-----------------------------------
Base query: retrieves core columns from table
-----------------------------------
 */
select
	fs.sales_id,
	fs.sales_date,
	fs.customer_id,
	fs.quantity,
	fs.discount,
	fs.total_price,
	dp.product_id,
	dp.product_name,
	dp.price,
	dp.category_name,
	dp.class,
	dp.resistant,
	dp.is_alergant,
	dp.vitality_days 
from gold.fact_sales fs
left join gold.dim_products dp 
on fs.product_id=dp.product_id
),
product_aggregation as(
/*
------------------------------
product aggregation: summarizes key metrics at the products level
------------------------------
 */
select
	product_id,
	product_name,
	price,
	category_name,
	class,
	resistant,
	is_alergant,
	vitality_days,
	max(sales_date) as last_transaction_date,
	count(sales_id) as total_transactions,
	sum(total_price) as total_sales,
	sum(quantity) as total_quantity_purchased,
	sum(discount) as total_discount,
	count(distinct customer_id) as total_customers
from base_products 
group by product_id,
	product_name,
	price,
	category_name,
	class,
	resistant,
	is_alergant,
	vitality_days
)
select
	product_id,
	product_name,
	price,
	category_name,
	class,
	resistant,
	is_alergant,
	vitality_days,
	last_transaction_date,
	-- products segmentations
	case 
		when total_sales > 10000000 then 'High-Performer'
		when total_sales between 1000000 and 10000000 then 'Mid-Performer'
		else 'Low-Performer'
	end as product_segment,
	total_transactions,
	total_sales,
	-- compute average transaction sales
	total_sales / total_transactions as average_per_transaction,
	total_quantity_purchased,
	total_discount,
	total_customers
from product_aggregation;
	
