/*
---------------------------------------------------------------------
Quality Checks
---------------------------------------------------------------------
Script Purpose:

	This script checks the data quality of the fact and dimension
	tables of the gold schema

	-- Duplicates and NULL values
	-- Joining Capabilities

Usage:
	Each script should be run after loading the gold tables and the
	results should match the expected outcome of each script
---------------------------------------------------------------------
*/


---------------------------------------------------------------------
-- Check for gold.dim_customers table
---------------------------------------------------------------------
-- Check for NULL vales or Duplicate values in the Primary Key
-- Expected Outcome: No Results
SELECT
	customer_key,
	COUNT(*)
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) != 1 OR customer_key IS NULL
;

---------------------------------------------------------------------
-- Check for gold.dim_products table
---------------------------------------------------------------------
-- Check for NULL values or Duplicate values in the Primary Key
-- Expected Outcome: No Results
SELECT
	product_key,
	COUNT(*)
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) != 1 OR product_key IS NULL
;

---------------------------------------------------------------------
-- Check for gold.fact_sales table
---------------------------------------------------------------------
-- Check for Joining capabilities of the dimension tables with fact table
-- Expected Outcome: No Results
SELECT
	*
FROM 
	gold.fact_sales s
LEFT JOIN
	gold.dim_customers c
		ON s.customer_key = c.customer_key
LEFT JOIN
	gold.dim_products p
		ON s.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL
;
