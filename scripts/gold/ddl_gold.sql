/* 
==============================================================================
 						DDL Scripts: Create Silver Tables            
 ==============================================================================
 Script Purpose:
	This script create views for gold layer in th datawarehouse.
 The gold layer represents the final dimension and fact tables.
................................................................................
*/


--==============================================================================
--					Create Dimension: gold.dim_customer         
--==============================================================================
IF OBJECT_ID('gold.dim_customers','V') IS NOT NULL
	DROP VIEW gold.dim_customers 

GO

CREATE VIEW gold.dim_customers AS

SELECT
	ROW_NUMBER() OVER (ORDER BY CI.cst_id) AS customer_key,
	CI.cst_id AS customer_id,
	CI.cst_key AS customer_number,
	CI.cst_firstname AS first_name,
	CI.cst_lastname AS last_name,
	LA.CNTRY AS country,
	CI.cst_marital_status AS marital_status,
	CASE 
		WHEN CI.cst_gndr != 'n/a' THEN CI.cst_gndr
		ELSE COALESCE(CA.GEN,'n/a')
	END AS gender,
	CA.BDATE AS birthdate,
	CI.cst_create_date AS create_date
FROM silver.crm_cust_info AS CI
LEFT JOIN silver.erp_cust_az12 AS CA
ON CI.cst_key = CA.CID
LEFT JOIN silver.erp_loc_a101 AS LA
ON CI.cst_key = LA.CID;

GO
--==============================================================================
--					Create Dimension: gold.dim_product      
--==============================================================================
IF OBJECT_ID('gold.dim_product','V') IS NOT NULL
	DROP VIEW gold.dim_product

GO

CREATE VIEW gold.dim_product AS
SELECT
	ROW_NUMBER() OVER (ORDER BY PRI.prd_start_dt, PRI.prd_key) AS product_key,
	PRI.prd_id AS produc_id,
	PRI.prd_key AS product_number,
	PRI.prd_nm AS product_name,
	PRI.cat_id AS category_id,
	CAT.CAT AS category,
	CAt.SUBCAT AS subcategory,
	CAT.MAINTENANCE AS maintanance,
	PRI.prd_cost AS cost,
	PRI.prd_line AS product_line,
	PRI.prd_start_dt AS start_date

FROM silver.crm_prd_info PRI
LEFT JOIN silver.erp_px_cat_g1v2 AS CAT
ON PRI.cat_id = CAT.ID
WHERE PRI.prd_end_dt IS NULL;

GO
--==============================================================================
--					Create Dimension: gold.fact_sales   
--==============================================================================
IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales

GO

CREATE VIEW gold.fact_sales AS
SELECT
	SD.sls_ord_num AS order_number,
	DP.product_key,
	DC.customer_key,
	SD.sls_order_dt AS order_date,
	SD.sls_ship_dt AS ship_date,
	SD.sls_due_dt AS due_date,
	SD.sls_price AS price,
	SD.sls_quantity AS quantity,
	SD.sls_sales AS sales_amount
FROM silver.crm_sales_details  SD
LEFT JOIN gold.dim_product  DP
ON SD.sls_prd_key = DP.product_number
LEFT JOIN gold.dim_customers AS DC
ON SD.sls_cust_id = DC.customer_id;
