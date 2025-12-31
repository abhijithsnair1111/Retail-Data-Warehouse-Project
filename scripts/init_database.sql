/*
---------------------------------------------------------------------
Create a Database and necessay Schemas
---------------------------------------------------------------------
Script Details :
		This scripts creates a new database called 'Data Warehouse' after checking the
		existance of a database with the same name. If a database with the exact name
		is found, this script would drop the entire database and recreate a new one with
		the same name. Additionaly this script also create three schemas within the database
		namely 'bronze', 'silver' and 'gold'.

WARNING :
		This script upon execution will completely drop any database named 'Data Warehouse'
		and all its contents if it exists. In order to prevent any data loss, ensure the a
		proper backup of any database with this name.
*/

USE master ;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'RetailDB')
BEGIN
	ALTER DATABASE RetailDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE ;
	DROP DATABASE RetailDB ;
END ;
GO

-- Create the 'RetailDB' database
CREATE DATABASE RetailDB ;
GO

USE RetailDB ;
GO

-- Create the Schemas
CREATE SCHEMA bronze ;
GO

CREATE SCHEMA silver ;
GO

CREATE SCHEMA gold ;
GO
