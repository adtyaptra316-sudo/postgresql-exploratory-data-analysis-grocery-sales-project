/*
========================================
Data Segmentation
========================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.
*/
/*segmentation product into price range
and count how many product fall into each segments*/ 

with product_segment as(
select
	product_name,
	price,
	case 
		when price <10 then 'Bellow 10'
		when price between 10 and 30 then '10-30'
		when price between 30 and 50 then '30-50'
		else 'Above 50'
	end as price_range
from gold.dim_products
)
select
	price_range,
	count(product_name) as total_products
from product_segment
group by price_range
order by total_products desc;

/* group customers into four segments based on their spending behavior
 - VVIP: Customer with spending more than 100,000
 - VIP: Customer with spending between 80,000 and 100,000
 - Regular: Customer with spending between 10,000 and 80,000
 - Basic: Customer with spending less than 10,000
 
And find the total number of customers by each group*/
with customer_segmentation as (
	select
		dc.customer_name,
		sum(fs.total_price) as total_sales,
		case
			when sum(fs.total_price) > 100000 then 'VVIP'
			when sum(fs.total_price) between 80000 and 100000 then 'VIP'
			when sum(fs.total_price) between 10000 and 80000 then 'Regular'
			else 'Basic'
		end as customer_category
	from gold.fact_sales fs
	left join gold.dim_customers dc 
	on fs.customer_id =dc.customer_id
	group by customer_name
)
select
	customer_category,
	count(customer_name) as total_customers
from customer_segmentation
group by customer_category
order by total_customers desc;
	
