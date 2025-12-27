/*
---------------------------------------------------------------------
Stored Procedure : Load Silver Tables (Bronze -> Silver)
---------------------------------------------------------------------
Script Purpose :
	This script loads data from bronze layer into the tables of silver schema
	It executes the following actions
		- Truncate tables in the silver schema before inserting data
		- Clean, Standardize, Normalize and Organize data from the bronze schema for storage

Parameters :
	This Procedure doesnot accept any parameters

Returns :
	This Procedure doesnot return any values

Use Case :
	EXEC silver.load_silver
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '------------------------------------------------------------';
		PRINT 'Loading Silver Layer';
		PRINT '------------------------------------------------------------';

		PRINT '------------------------------------------------------------';
		PRINT 'Loading crm Tables';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;

		PRINT '>>>> Inserting Data Into Table : silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
			)
		SELECT
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE
			 WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			 ELSE 'N/A'
		END AS cst_marital_status, -- Normalize marital_status to readable values
		CASE
			 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			 ELSE 'N/A'
		END AS cst_gndr, -- Normalize gndr to readable values
		cst_create_date
		FROM
		(
			-- Sub Query to filter out the recent value of in the Primary Key with duplicates
			SELECT
			*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_rank
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL -- Filter NULL in Primary Key
		)t
		WHERE flag_rank = 1 -- Filter out the duplicates in the Primary Key
		;
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;

		PRINT '>>>> Inserting Data Into Table : silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
			)
		SELECT
			prd_id,
			SUBSTRING(prd_key, 1, 5) AS cat_id, -- Extracted from prd_key to join category table
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- Extracted from prd_key after removing cat_id
			prd_nm,
			COALESCE(prd_cost, 0) AS prd_cost, -- Handling NULL value
			CASE UPPER(TRIM(prd_line))
				 WHEN 'M' THEN 'Mountain'
				 WHEN 'R' THEN 'Road'
				 WHEN 'S' THEN 'Other Sales'
				 WHEN 'T' THEN 'Touring'
				 ELSE 'N/A'
			END AS prd_line, -- Normalize prd_line to readable values
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt ASC)
				- 1 AS DATE) AS prd_end_dt -- Calculate prd_end_dt as one day before the next prd_start_dt
		FROM bronze.crm_prd_info
		;
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;

		PRINT '>>>> Inserting Data Into Table : silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
			)
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE
				 WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END sls_order_dt, -- Changed Data type from INT to DATE after filtering invalid date
			CASE
				 WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END sls_ship_dt, -- Changed Data type from INT to DATE after filtering invalid date
			CASE
				 WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END sls_due_dt, -- Changed Data type from INT to DATE after filtering invalid date
			CASE
				 WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
					THEN sls_quantity * ABS(sls_price)
				 ELSE sls_sales
			END sls_sales, -- Calculated sales from quantity and price for invalid sales
			sls_quantity,
			CASE
				 WHEN sls_price IS NULL OR sls_price <= 0
					THEN sls_sales / NULLIF(sls_quantity, 0)
				 ELSE sls_price
			END sls_price -- Calculated price from sales and quantity for invalid prices
		FROM bronze.crm_sales_details
		;
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		PRINT '------------------------------------------------------------';
		PRINT 'Loading erp Tables';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;

		PRINT '>>>> Inserting Data Into Table : silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen
		)
		SELECT
			CASE
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
				ELSE cid
			END cid, -- Extracted from cid to join customer information table
			CASE
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END bdate, -- Corected invalid dates
			CASE 
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'N/A'
			END gen -- Normalized gender into readabl values
		FROM bronze.erp_cust_az12
		;
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;

		PRINT '>>>> Inserting Data Into Table : silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101(
			cid,
			cntry
		)
		SELECT
			REPLACE(cid, '-', '') AS cid, -- Extract customer id to join with customers table
			CASE
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
				ELSE TRIM(cntry)
			END cntry -- Normalize country names into readable values
		FROM bronze.erp_loc_a101
		;
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;

		PRINT '>>>> Inserting Data Into Table : silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT
			REPLACE(id, '_', '-') AS id, -- Extracted from id to join with customer table
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2
		;
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT 'Loading Silver Layer Complete';
		PRINT 'Total Load Time : ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';
	END TRY

	BEGIN CATCH
		PRINT '------------------------------------------------------------';
		PRINT 'Error Occured During Silver Layer Loading';
		PRINT 'Error Message : ' + ERROR_MESSAGE();
		PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '------------------------------------------------------------';
	END CATCH
END;
