/*
==============================================================================
 							Stored Procedure: Load Bronze Layer           
 ==============================================================================
 Script Purpose:
	This stored procedure loada data into 'bronze' schema from csv files.
  It performs following action:
    - trancates the bronze tables before loading data
    - Uses the 'Bulk Insert' to load data from csv files to bronze tables.

 Parameters:
  This storen procedure does not accept any parameters or return any values

 Usage example:
  EXEC bronze.load_bronze

................................................................................
 Warning:
	Running this script will drop the all tables in database.
	All data will be permanently deleted.
.................................................................................
*/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @start_procedure DATETIME, @end_procedure DATETIME
	BEGIN TRY 

	SET @start_procedure = GETDATE();

		PRINT '========================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '-=======================================================';

		PRINT '--------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------------------------';

-- table: bronze.crm_cust_info

		SET @start_time = GETDATE();
		PRINT'>>Truncating table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
	
		Print'>>Insertind Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Dysk do użytku\data warehouse\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR)+' sec';
		PRINT'------------------';

-- table:bronze.crm_prd_info

		SET @start_time = GETDATE();
		PRINT'>>Truncating table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		Print'>>Insertind Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Dysk do użytku\data warehouse\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR)+' sec';
		PRINT'------------------';

-- table:bronze.crm_sales_details

		SET @start_time = GETDATE();
		PRINT'>>Truncating table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		Print'>>Insertind Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Dysk do użytku\data warehouse\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR)+' sec';
		PRINT'------------------';

		PRINT '--------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------------------------';

-- table: bronze.erp_cust_az12

		SET @start_time = GETDATE();
		PRINT'>>Truncating table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		Print'>>Insertind Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Dysk do użytku\data warehouse\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR)+' sec';
		PRINT'------------------';

-- table: bronze.erp_loc_a101	

		SET @start_time = GETDATE();
		PRINT'>>Truncating table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		Print'>>Insertind Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Dysk do użytku\data warehouse\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR)+' sec';
		PRINT'------------------';

-- table: bronze.erp_loc_a101

		SET @start_time = GETDATE();
		PRINT'>>Truncating table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		Print'>>Insertind Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Dysk do użytku\data warehouse\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR)+' sec';
	
	SET @end_procedure = GETDATE();
	PRINT'=====================================';
	PRINT'Loading bronze layer is completed';
	PRINT'>> Total duration ' + CAST(DATEDIFF(SECOND,@start_procedure,@end_procedure) as NVARCHAR)+' sec';
	PRINT'=====================================';

	END TRY
	BEGIN CATCH
		PRINT'==================================================';
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT'Error Message' + ERROR_MESSAGE();
		PRINT'Error Message' + CAST(ERROR_NUMBER() as NVARCHAR);
		PRINT'Error Message' + CAST(ERROR_LINE() as NVARCHAR);
		PRINT'==================================================';

	END CATCH
END

