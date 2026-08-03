/*
========================================
Employees Report
========================================
Purpose:
    - This report consolidates key employee metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, city, and service details.
    2. Segments employees by tenure years to identify Senior, Mid-Level, Junior, and New
    3. Aggregates product-level metrics:
       - total services
       - total sales
       - total quantity sold
       - total customers (unique)
       - total products (unique)
    4. Calculates valuable KPIs
       - average sales service
*/
create or replace view gold.report_employees
as
with base_employees as(
/*
-----------------------------------
Base query: retrieves core columns from table
-----------------------------------
 */
select
	fs.sales_id,
	fs.sales_date,
	fs.customer_id,
	fs.product_id,
	fs.quantity,
	fs.total_price,
	de.employee_id,
	de.employee_name,
	de.gender,
	de.birth_date,
	-- Employee age during most recent transaction
	extract(year from age(max(fs.sales_date) over(), de.birth_date)) as employee_age,
	de.country_name,
	de.city_name,
	de.hire_date,
	-- tenure employees
	extract(year from age(max(fs.sales_date)over(), de.hire_date)) as tenure_years
from gold.fact_sales fs
left join gold.dim_employees de 
on fs.employee_id =de.employee_id 
),
employees_aggreations as(
/*
------------------------------
employees aggregations: summarizes key metrics at the employees level
------------------------------
 */
select
	employee_id,
	employee_name,
	gender,
	employee_age,
	tenure_years,
	hire_date,
	country_name,
	city_name,
	max(sales_date) as last_service_date,
	count(sales_id) as total_service,
	sum(total_price) as total_sales,
	sum(quantity) as total_quantity_sold,
	count(distinct customer_id) as total_customers,
	count(distinct product_id) as total_products
from base_employees
group by
	employee_id,
	employee_name,
	gender,
	employee_age,
	tenure_years,
	hire_date,
	country_name,
	city_name
)
select
	employee_id,
	employee_name,
	gender,
	employee_age,
	-- employees segmentations
	case 
		when tenure_years > 5 then 'Senior'
		when tenure_years > 3 then 'Mid-Level'
		when tenure_years > 1 then 'Junior'
		else 'New'
	end as employee_level,
	tenure_years,
	hire_date,
	country_name,
	city_name,
	last_service_date,
	total_service,
	total_sales,
	-- compute average service value
	total_sales / total_service as average_service_value,
	total_quantity_sold,
	total_customers,
	total_products
from employees_aggreations;
