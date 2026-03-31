-- Check for nulls or duplicates in Primary Key
-- For crm_cust_info
SELECT cst_id, COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING count(*) > 1 or cst_id IS NULL;
/*
Output:

cst_id	(No column name)
29449	2
29473	2
29433	2
NULL	3
29483	2
29466	3

We have duplicates and nulls
*/

SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last -- ROW_NUMBER() Assigns a unique number to each row in a result set, based on defined order
FROM bronze.crm_cust_info
) AS t 
WHERE flag_last != 1;

/*
Output:

cst_id	cst_key		cst_firstname	cst_lastname	cst_material_status		cst_gndr	cst_create_date		flag_last
NULL	SF566		NULL			NULL			NULL					NULL		NULL				2
NULL	13451235	NULL			NULL			NULL					NULL		NULL				3
29433	AW00029433	NULL			NULL			M						M			2026-01-25			2
29449	AW00029449	NULL			Chen			S						NULL		2026-01-25			2
29466	AW00029466	Lance			Jimenez			M						NULL		2026-01-26			2
29466	AW00029466	NULL			NULL			NULL					NULL		2026-01-25			3
29473	AW00029473	Carmen			NULL			NULL					NULL		2026-01-25			2
29483	AW00029483	NULL			Navarro			NULL					NULL		2026-01-25			2

These are the duplicate values
*/

SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
) AS t 
WHERE flag_last = 1 and cst_id = 29466;

/*
Output:

cst_id	cst_key		cst_firstname	cst_lastname	cst_material_status		cst_gndr	cst_create_date		flag_last
29466	AW00029466	Lance			Jimenez			M						M			2026-01-27			1

only one value for 29466
*/

SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL -- There was one null value for cst_id and we ignored it.
) AS t 
WHERE flag_last = 1; 

/*
Output:

cst_id	cst_key		cst_firstname	cst_lastname	cst_material_status		cst_gndr	cst_create_date		flag_last

11000	AW00011000	Jon				Yang 			M						M			2025-10-06			1
11001	AW00011001	Eugene			Huang  			S						M			2025-10-06			1
11002	AW00011002	Ruben	 		Torres			M						M			2025-10-06			1
11003	AW00011003	Christy	  		Zhu				S						F			2025-10-06			1
11004	AW00011004	Elizabeth		Johnson			S						F			2025-10-06			1

This gives us columns without duplicates. Note that the output is limited to only few rows
*/

-- Now we have lot of string values and we have to check unwanted spaces in string values
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);
--This query is going to check if the original value is not equal to the same value after trimming and it means there are spaces.

/*
Output:

cst_firstname
 Jon
 Elizabeth
  Lauren
 Ian 
  Chloe
 Destiny
 Angela  
 Caleb
 Willie 
 Ruben 
 Javier 
 Nicole
 Maria 
 Allison 
 Adrian 
 
There are duplicates
*/

-- Removing the unwanted spaces using the below query
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
) AS t 
WHERE flag_last = 1;

-- This query will remove the unwanted spaces for cst_firstname, cst_lastname

/*
Output:

cst_id	cst_key		cst_firstname	cst_lastname	cst_marital_status		cst_gndr	cst_create_date
11000	AW00011000	Jon				Yang			M						M			2025-10-06
11001	AW00011001	Eugene			Huang			S						M			2025-10-06
11002	AW00011002	Ruben			Torres			M						M			2025-10-06
11003	AW00011003	Christy			Zhu				S						F			2025-10-06

now the spaces are removed and output is copied only for few rows for understanding
*/

-- Check the consistency of the values in low cardinality columns which are cst_marital_status & cst_gndr, so we have to check data standardization and consistency for those two

SELECT DISTINCT(cst_gndr)
FROM bronze.crm_cust_info;

/*
Output:

cst_gndr
NULL
F
M

In our data warehouse, we aim to store clear and meaningful values rather than using abbreviated values
So for 'F' we give 'Female' & for 'M' we give 'Male'; Also we give 'N/A' for missing values
*/

-- Query to remove replace missing values and abbreviations
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' -- Applying UPPER() incase of any mixed values appear and TRIM() to remove unwanted spaces
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date,
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
) AS t 
WHERE flag_last = 1;

/*
Output:

cst_id	cst_key		cst_firstname	cst_lastname	cst_marital_status		cst_gndr	cst_create_date
11000	AW00011000	Jon				Yang			M						Male		2025-10-06
11001	AW00011001	Eugene			Huang			S						Male		2025-10-06
11002	AW00011002	Ruben			Torres			M						Male		2025-10-06
*/

-- Even the same thing to be done for cst_marital_status just like cst_gndr

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,

CASE 
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a'
END AS cst_marital_status,

CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'n/a'
END AS cst_gndr,

cst_create_date
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
) AS t 
WHERE flag_last = 1;

/*
Output:

cst_id	cst_key		cst_firstname	cst_lastname	cst_marital_status		cst_gndr	cst_create_date

11000	AW00011000	Jon				Yang			Married					Male		2025-10-06
11001	AW00011001	Eugene			Huang			Single					Male		2025-10-06
11002	AW00011002	Ruben			Torres			Married					Male		2025-10-06
11003	AW00011003	Christy			Zhu				Single					Female		2025-10-06

*/
==============================================================================
-- For crm_prd_info

-- To check duplicates or nulls for primary key

select prd_id, count(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL;

-- No nulls or duplicates found

-- To check unwanted spaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- No unwanted spaces

-- Partitioning the column prd_key into two columns
-- We need cat_id to connect the other table bronze.erp_px_cat_g1v2
-- We need prd_key to connect with bronze.crm_sales_details
select 
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- extracting a part of the column prd_key and replacing the '-' with '_'
SUBSTRING(prd_key, 7, len(prd_key)) AS prd_key, -- extracting another part of the column prd_key
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info;

-- To check for nulls and negative numbers

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- There are two null values and are to be replaced by 0


-- prd_line to be made meaningfull without abbreviations
select 
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, len(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost, 0) AS prd_cost,
CASE 
	WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line, -- replacing the abbreviated values and null values
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info;

/*
We can use the below query for prd_line

CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line
*/


-- Check invalid date orders for prd_start_dt & prd_end_dt
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- We have issues with the start and end date and need to correct them

/*
We see that the end dates are null which is acceptable but the start dates are null as well
For our convenience, we will make end date of previous column be one day lesser than the start date of the next value
We also have to make sure that there is no date overlap in any of the records(Like start date of next value cannot be in between start and end of previous range)
===================
SELECT *,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS prd_end_dt_tst
FROM bronze.crm_prd_info;
===================
We have to insert this query in to the main select statement

Also changed the format for start and end dates as below

CAST(prd_start_dt AS DATE) AS prd_start_dt
CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt
*/
==============================================================================
-- FOR bronze.crm_sales_details

-- Search for unwanted spaces
SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- No unwanted spaces found

-- Check for invalid dates, and for dates with 0s we make it null
SELECT
NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0;

-- Use the follwing piece of code to make the values null if column has 0s and length of the sls_ord_dt is not exactly 8

CASE
	WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt

-- INTEGER first to be converted to VARCHAR and then to DATE format and apply the same to sls_ship_dt & sls_due_dt columns as well

-- Check if the sales, quantity and price are in correct shape
SELECT DISTINCT sls_sales, sls_quantity, sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- there are null values, 0s and negative values in these columns.
/*
CASE 
	WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE
	WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price

Used the above snippet to transform the data
*/
==============================================================================
-- FOR bronze.erp_loc_a101

SELECT cid, COUNT(*)
FROM bronze.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1; -- No duplicates for cid

SELECT cntry
FROM bronze.erp_loc_a101
WHERE cntry != TRIM(cntry); -- No unwanted spaces
==============================================================================
-- FOR bronze.erp_cust_az12
-- removing the 'NAS' prefix, removing the future dates and renaming the gen column

CASE
	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, len(cid))
	ELSE cid
END AS cid,

CASE 
	WHEN bdate > GETDATE() THEN NULL
	ELSE bdate
END AS bdate,

CASE 
	WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'n/a'
END AS gen
==============================================================================
-- FOR bronze.erp_px_cat_g1v2

SELECT
cat, subcat, maintenance
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance); -- No unwanted spaces
==============================================================================
