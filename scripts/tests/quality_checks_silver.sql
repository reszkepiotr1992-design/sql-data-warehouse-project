/*--======================================================================
----------- QUALITY CHECK------------------------------------------------
--========================================================================
Scrits Purpose:
  This script performs quality check in silver schema.  Check includes:
  - NULL or duplicate primary key
  - Unwanted spaces 
  - Invalid date ranges
  - Data standarization and consistency

>>Run this script after loading data to silver layer

*/

--==================================
-------silver.crm_cust_info---------
--==================================

--Check For Nulls or Duplicates in Primary Key

SELECT
	cst_id,
	COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--Check For Spaces

SELECT 
	*
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
	OR cst_lastname != TRIM(cst_lastname)
	OR cst_key != TRIM(cst_key)

-- Data Standarization & Consistency

SELECT DISTINCT
	cst_marital_status
FROM silver.crm_cust_info

--==================================
-------silver.crm_prd_info----------
--==================================
--Check For Nulls or Duplicates in Primary Key

SELECT
	prd_id,
	COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--Check For Spaces

SELECT 
	*
FROM silver.crm_prd_info
WHERE prd_key != TRIM(prd_key)
--Check For Nulls and negative number

SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standarization & Consistency

SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info

--Check For Invalid Date 

SELECT 
 	*
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt

--==================================
-------silver.crm_sales_detail------
--==================================

--Look For Date Out of Range From company founding date to today

SELECT 
*
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0
	OR LEN(sls_order_dt) != 8 
	OR sls_order_dt > 20260122 
	OR sls_order_dt <19000101 

-- Check For Invalid Order Date Order > Ship/Due

SELECT 
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
	OR sls_ship_dt > sls_due_dt

-- Check Data Consistency Price * Quantity = Sales

SELECT DISTINCT
	sls_price,
	sls_quantity,
	sls_sales
FROM bronze.crm_sales_details
WHERE sls_price * sls_quantity != sls_sales
	OR sls_price IS NULL OR sls_price <= 0
	OR sls_quantity IS NULL OR sls_quantity <= 0
	OR sls_sales IS NULL OR sls_sales <= 0
ORDER BY sls_price,sls_quantity,sls_sales


--==================================
-------silver.erp_cust_az12--------
--==================================

--Look For Date Out Of Range 
SELECT
	*
FROM silver.erp_cust_az12
WHERE BDATE > GETDATE()

-- Data Standarization & Consistency

SELECT DISTINCT
	GEN
FROM silver.erp_cust_az12

--==================================
-------silver.erp_loc_a101---------
--==================================

-- Data Standarization & Consistency

SELECT DISTINCT
	CNTRY
FROM silver.erp_loc_a101
ORDER BY CNTRY

--==================================
-------silver.erp_px_cat_g1v2------
--==================================

--Check For Spaces

SELECT 
	*
FROM silver.erp_px_cat_g1v2
WHERE CAT != TRIM(CAT)
	OR SUBCAT != TRIM(SUBCAT)
	OR MAINTENANCE != TRIM(MAINTENANCE)

-- Data Standarization & Consistency

SELECT DISTINCT
	MAINTENANCE
FROM silver.erp_px_cat_g1v2

