/*
=======================================
Change Overtime Analysis
=======================================
Purpose:
	- To track trends, growth, and changes in key metrics over time.
	- For time-series analysis and identifying seasonality.
	- To measure growth or decline over specific periods.
*/

-- analysis sales performance over time
select * from (
	select
		date_trunc('month',sales_date) as month,
		sum(total_price) as total_sales,
		avg(total_price) as average_sales,
		count(sales_id) as total_transactions,
		sum(quantity) as total_quantity,
		count(distinct customer_id) as total_customer
	from gold.fact_sales
	group by date_trunc('month',sales_date))
where month is not null
order by month;
