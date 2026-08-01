/*
========================================
Date Range Exploration
========================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

*/
-- Determine the first and last date the product was modified
select min(modify_date), max(modify_date) from gold.dim_products;

-- Determine the first and last order date and the total duration in months
select
	min(sales_date),
	max(sales_date),
	(extract(year from max(sales_date)) - extract(year from min(sales_date))) * 12 +
	(extract(month from max(sales_date)) -extract( month from min(sales_date))) as month_difference
from gold.fact_sales ;

-- Find the youngest and oldest employee based on birthdate
select
	min(birth_date) as oldest_brithdate,
	extract(year from current_timestamp) - extract(year from min(birth_date)) as oldest_age,
	max(birth_date) as youngest_birthdate,
	extract(year from current_timestamp) - extract(year from max(birth_date)) as youngest_age
from gold.dim_employees;

-- Find the longest-serving and newest employees based on hire_date
select
	min(hire_date) as longest_employee,
	extract(year from current_timestamp) - extract(year from min(hire_date)) as longest_working_year,
	max(hire_date) as newest_employee,
	extract(year from current_timestamp) - extract(year from max(hire_date)) as newest_working_year
from gold.dim_employees;
