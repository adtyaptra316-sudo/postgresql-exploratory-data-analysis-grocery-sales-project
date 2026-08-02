/*
=========================================
Part-To-Whole Analysis (Proportional Analysis)
=========================================
Purpose:
	-- To Analyze how an indiviual part is performaning compared to the overall
*/
-- Which the product category has greatest impact to total sales
with ts_per_product as (
	select
		dp.category_name,
		sum(fs.total_price) as total_sales_per_category
	from gold.fact_sales fs
	left join  gold.dim_products dp 
	on fs.product_id =dp.product_id
	group by category_name
	order by category_name)
select category_name,
	total_sales_per_category,
	sum(total_sales_per_category) over() as total_sales,
	concat(round((total_sales_per_category / sum(total_sales_per_category) over()) *100,2),'%') as percentage
from ts_per_product
group by category_name,total_sales_per_category
order by total_sales_per_category desc;
