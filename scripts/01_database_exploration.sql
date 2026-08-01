/*
========================================
Database Exploration
========================================
Purpose:
	- To explore the structure of the database, including the list of tables and their schema
	- To inspect the columns and metadata for specific tables.
*/
-- Retrive a list of all tables in the database
select * from information_schema.tables;

-- Retrive a list all columns for a specific table (dim_products)
select * from information_schema.columns
where table_name ='dim_products';

-- Retrive a list all columns for a specific table (dim_customers)
select * from information_schema.columns
where table_name ='dim_customers';

-- Retrive a list all columns for a specific table (dim_employees)
select * from information_schema.columns
where table_name ='dim_employees';

-- Retrive a list all columns for a specific table (fact_sales)
select * from information_schema.columns
where table_name ='fact_sales';

