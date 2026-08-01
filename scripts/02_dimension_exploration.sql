/*
========================================
Dimension Exploration
========================================
Purpose:
	- To explore the dimension columns of the table
	- To identify unique value of dimension column
*/
-- retrive a list of unique class, category, and product
select distinct class, category_name, product_name
from gold.dim_products
order by class, category_name, product_name;

-- retriive a list of unique countries and cities from which customers originate 
select distinct country_name, city_name
from gold.dim_customers
order by country_name, city_name;

-- -- retrive a list of unique countries and cities from which employees originate
select distinct country_name, city_name from gold.dim_employees
order by country_name, city_name;




