/*
 ====================================================
|				      Create dabase and schema                |
 ====================================================
 Script Purpose:
	Script check if database exist, depend on result database is droped or create.
	Additionaly script create 3 type of schema: bronze, silver and gold


 Warning:
	Running this script will drop the entire database.
	All data will be permanently deleted.
*/


-- Check if databases exist and replace it

	IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
		BEGIN
			DROP DATABASE DataWarehouse
		END
 
-- Create Database DataWarehouse

	 USE master;

	 CREATE DATABASE DataWarehouse;

	 USE DataWarehouse;

-- Create schema

	 CREATE SCHEMA bronze;
 
	 CREATE SCHEMA silver;
 
	 CREATE SCHEMA gold;
