/*
 ==============================================================================
 							Create dabase and schema                
 ==============================================================================
 Script Purpose:
	First script check if database exist. If exist drop it and create new one.
	Additionaly script create 3 type of schema: bronze, silver and gold.
................................................................................
 Warning:
	Running this script will drop the entire database.
	All data will be permanently deleted.
.................................................................................
*/


-- Check if databases exist and replace it

	IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
		BEGIN
			DROP DATABASE DataWarehouse
		END
		GO
-- Create Database DataWarehouse

	 USE master;
	 GO
	 CREATE DATABASE DataWarehouse;
	 GO
	 USE DataWarehouse;
	 GO
-- Create schema

	 CREATE SCHEMA bronze;
	 GO
	 CREATE SCHEMA silver;
	 GO
	 CREATE SCHEMA gold;
