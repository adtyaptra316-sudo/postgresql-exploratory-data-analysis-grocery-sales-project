/*
========================================
Performance Analysis
========================================
Purpose:
	- To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.
*/

/* Analyze the monthly performance of product by the comparing their sales
to both the average sales performance of the producvt and the previous month's sales
 */

with monthly_sales as
	(select
		date_trunc('month',fs.sales_date) as month,
		dp.product_name,
		sum(fs.total_price) as total_sales
	from gold.fact_sales fs
	left join gold.dim_products dp
	on fs.product_id = dp.product_id 
	group by date_trunc('month',fs.sales_date), dp.product_name
	having date_trunc('month',fs.sales_date) is not null
	)
select
	month,
	product_name,
	total_sales,
	avg(total_sales) over(partition by product_name) as average_sales,
	total_sales - avg(total_sales) over(partition by product_name) as diff_avg,
	case
		when total_sales - avg(total_sales) over(partition by product_name) > 0 then 'Above Average'
		when total_sales - avg(total_sales) over(partition by product_name) < 0 then 'Below average'
		else 'Average'
	end as kkl,
	lag(total_sales)over(partition by product_name order by month) as previous_sales,
	total_sales - lag(total_sales)over(partition by product_name order by month) as diff_previous,
	case
		when total_sales - lag(total_sales)over(partition by product_name order by month) > 0 then 'Increase'
		when total_sales - lag(total_sales)over(partition by product_name order by month) < 0 then 'Decrease'
		else 'No Change'
	end as khj
from monthly_sales
group by product_name, month, total_sales
;
	
