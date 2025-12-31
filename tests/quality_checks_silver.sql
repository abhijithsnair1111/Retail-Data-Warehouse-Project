/*
---------------------------------------------------------------------
Quality Checks
---------------------------------------------------------------------
Script Purpose:

	This script checks different types of data quality issues inside
	of the tables in silver schema.

	-- Duplicates and NULL values
	-- Unwanted spaces
	-- Standardization and Normalization
	-- Invalid Dates
	-- Data Consistency

Usage:
	
	Run each script with all columns to ensure data quality issues
	Each script should be run afer loading the silver tables and the 
	results should match the expected outcome of each script
---------------------------------------------------------------------
*/


---------------------------------------------------------------------
-- Ckecks for CRM Tables
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Checks for crm_cust_info table
---------------------------------------------------------------------
-- Check of NULL value or Duplicate values in the Primary Key (ID)
-- Expected Outcome: No Result
SELECT
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL
;

-- Check for Unwanted Spaces in character columns (eg: Key)
-- Expectated Outcome: No Result
SELECT
	cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key)
;

-- Check Data Standardization and Normalization (eg: Gender)
-- Expected Outcome: Predefined Values
SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info
;

---------------------------------------------------------------------
-- Checks for crm_prd_info table
---------------------------------------------------------------------
-- Check of NULL value or Duplicate values in the Primary Key (ID)
-- Expected Outcome: No Result
SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL
;

-- Check for Unwanted Spaces in character columns (eg: Name)
-- Expectated Outcome: No Result
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)
;

-- Check for NULL value or Negative values (eg: Cost)
-- Expected Outcome: No Result
SELECT
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL
;

-- Check Data Standardization and Normalization (eg: Line)
-- Expected Outcome: Predefined Values
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info
;

-- Check for Invalid Date Orders (eg: Start Date is after End Date)
-- Expected Outcome: No Result
SELECT
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt
;

---------------------------------------------------------------------
-- Checks for crm_sales_details table
---------------------------------------------------------------------
-- Check for Invalid Dates (eg: Order Date)
-- Expected Outcome: No Result
SELECT
	sls_due_dt
FROM silver.crm_sales_details
WHERE
	sls_due_dt > '2050-01-01'  -- Order date from distant future
OR  sls_due_dt < '1900-01-01'  -- Order date from distant past
;


-- Check for Invalid Date Orders (eg: Order Date is afte Ship Date or Due Date)
-- Expected Outcome: No Result
SELECT
    sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
;

-- Check Data Consitency (eg: Sales = Quantity * Price)
-- Expected Outcome: No Result
SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales = 0
   OR sls_quantity = 0
   OR sls_price = 0
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
;


---------------------------------------------------------------------
-- Checks for ERP tables
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Checks for erp_cust_az12 table
---------------------------------------------------------------------
-- Check for Out of Range Date (eg : Birthdate)
-- Expected Outcome: No Result
SELECT
	bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE()    -- Birthdate in future
   OR bdate < '1900-01-01' -- Birthdate in the distant future
;

-- Check Data Standardization and Normalization (eg: Gender)
-- Expected Outcome: Predefined Values
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12
;

---------------------------------------------------------------------
-- Checks for erp_loc_a101 table
---------------------------------------------------------------------
-- Check Data Standardization and Normalization (eg: Country)
-- Expected Outcome: Predefined Format
SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101
;

---------------------------------------------------------------------
-- Checks for erp_px_cat_g1v2 table
---------------------------------------------------------------------
-- Check for Unwanted Spaces in character columns(eg: Category, Subcategory, Maintenance)
-- Expectated Outcome: No Result
SELECT
	cat,
	subcat,
	maintenance
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance)
;

-- Check Data Standardization and Normalization (eg: Country)
-- Expected Outcome: Predefined Values
SELECT DISTINCT
	maintenance
FROM silver.erp_px_cat_g1v2
;
