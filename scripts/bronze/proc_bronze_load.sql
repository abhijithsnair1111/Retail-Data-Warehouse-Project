/*
---------------------------------------------------------------------
Stored Procedure : Load Bronze Tables (Source -> Tables)
---------------------------------------------------------------------
Script Purpose :
	This script loads data from csv files into the tables of bronze schema
	It executes the following actions
		- Truncate tables in the bronze schema before inseting data
		- BULK INSERT data into the truncated tables from csv files

Paremeters :
	This Procedure doesnot accepts any parameters

Returns :
	This Procedure doesnot return any values

Use Case :
	EXECUTE bronze.load_bronze
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '--------------------------------------------------------------';
		PRINT 'Lading Bronze Layer';
		PRINT '--------------------------------------------------------------';

		PRINT '--------------------------------------------------------------';
		PRINT 'Loading crm Tables';
		PRINT '--------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>>>> Insertng Data Into Table : bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\data_projects\retail_data_warehouse_project\dataset\source_crm\cust_info.csv'
		WITH(
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>>>> Insert Data Into Table : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\data_projects\retail_data_warehouse_project\dataset\source_crm\prd_info.csv'
		WITH(
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>>>> Inserting Data Into Table : bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\data_projects\retail_data_warehouse_project\dataset\source_crm\sales_details.csv'
		WITH(
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		PRINT '-------------------------------------------------------------';
		PRINT 'Loading erp Tables';
		PRINT '-------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>>>> Inserting Data Into Table : bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\data_projects\retail_data_warehouse_project\dataset\source_erp\CUST_AZ12.csv.'
		WITH(
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Trucating Table : bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>>>> Inserting Data Into Table : bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\data_projects\retail_data_warehouse_project\dataset\source_erp\LOC_A101.csv.'
		WITH(
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table : bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>>>> Inserting Data Into Table : bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\data_projects\retail_data_warehouse_project\dataset\source_erp\PX_CAT_G1V2.csv.'
		WITH(
			FIRST_ROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT 'Loading Bronze Layer Completed';
		PRINT 'Total Load Time : ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';
	END TRY

	BEGIN CATCH
		PRINT '------------------------------------------------------------';
		PRINT 'Error Occured During Bronze Layer Loading';
		PRINT 'Error Message : ' + ERROR_MESSAGE();
		PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '------------------------------------------------------------'
	END CATCH
END;
