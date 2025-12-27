/*
---------------------------------------------------------------------
DDL Scipts : Create Silver Tables
---------------------------------------------------------------------
Script Purpose:
		This script creates table in the silver schema. First it checks for any
		existing tables in the same name and creates the necessary tables in the schema
		for data insertion in the next step

		This script redefines the structure of the bronze layer adding neccessary columns
		created during the data cleansing stage
*/

-- Drop the silver.crm_cust_info table
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
GO

-- Create the silver.crm_cust_info table
CREATE TABLE silver.crm_cust_info(
	cst_id                INT,
	cst_key               VARCHAR(50),
	cst_firstname         VARCHAR(50),
	cst_lastname          VARCHAR(50),
	cst_marital_status    VARCHAR(50),
	cst_gndr              VARCHAR(50),
	cst_create_date       DATE,
	dwh_create_date       DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop the silver.crm_prd_info table
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
GO

-- Create the silver.crm_prd_info table
CREATE TABLE silver.crm_prd_info(
	prd_id                INT,
	cat_id                VARCHAR(50), -- Derived Column from Data Cleansing
	prd_key               VARCHAR(50),
	prd_nm                VARCHAR(50),
	prd_cost              INT,
	prd_line              VARCHAR(50),
	prd_start_dt          DATE, -- Changed Data type from DATETIME to DATE after data cleansing
	prd_end_dt            DATE, -- Changed Data type from DATETIME to DATE after data cleansing
	dwh_create_date       DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop the silver.crm_sales_details table
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
GO

-- Create the silver.crm_sales_details table
CREATE TABLE silver.crm_sales_details(
	sls_ord_num         VARCHAR(50),
	sls_prd_key         VARCHAR(50),
	sls_cust_id         INT,
	sls_order_dt        DATE, -- Changed Data type from INT to DATE after data cleansing
	sls_ship_dt         DATE, -- Changed Data type from INT to DATE after data cleansing
	sls_due_dt          DATE, -- Changed Data type from INT to DATE after data cleansing
	sls_sales           INT,
	sls_quantity        INT,
	sls_price           INT,
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop the silver.erp_loc_a101 table
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
GO

-- Create the silver.erp_loc_a101 table
CREATE TABLE silver.erp_loc_a101(
	cid                 NVARCHAR(50),
	cntry               NVARCHAR(50),
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop the silver.erp_cust_az12 table
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
	DROp TABLE silver.erp_cust_az12;
GO

-- Create the silver.erp_cust_az12 table
CREATE TABLE silver.erp_cust_az12(
	cid                 NVARCHAR(50),
	bdate               DATE,
	gen                 NVARCHAR(50),
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO

-- Drop the silver.erp_px_cat_g1v2 table
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
GO

-- Create the silver.erp_px_cat_g1v2 table
CREATE TABLE silver.erp_px_cat_g1v2(
	id                  NVARCHAR(50),
	cat                 NVARCHAR(50),
	subcat              NVARCHAR(50),
	maintenance         NVARCHAR(50),
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO
