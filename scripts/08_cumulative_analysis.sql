/*
========================================
Cumulative Analysis
========================================
	- To aggregate the data proggresively over time
*/
-- Calculate total sales by month
-- and the running total of sales over time

select *,
	sum(total_sales) over(order by month) as running_total_sales,
	avg(total_sales) over(order by month) as moving_average
from (select
	date_trunc('month', sales_date) as month,
	sum(total_price) as total_sales
from gold.fact_sales
group by date_trunc('month', sales_date))
order by month;
