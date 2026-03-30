/* 
Developing SQL load scripts using BULK INSERT. It's a process of loading massive amounts of data very quickly from files like CSV/text
directly into a database.

Load the data from CSV file into the bronze tables which we created

*/

-- FOR bronze.crm_cust_info

TRUNCATE table bronze.crm_cust_info; -- Quickly delete all the rows resetting into an empty state using TRUNCATE to perfrom full load

BULK INSERT bronze.crm_cust_info
-- give the file location
FROM 'C:\Users\rgdee\OneDrive\Desktop\SQL Project\SQL Data Warehouse Project - Data with Baraa\datasets\source_crm\cust_info.csv'
-- Tell the SQL server how to handle the file using WITH clause
WITH (
-- the data starts from the second row of the CSV, we are telling SQL to skip the first row as they contain headers
	FIRSTROW = 2,
-- specify the delimiter to read the CSV file
	FIELDTERMINATOR = ',',
/*
Add an option 'TABLOCK' to improve the performance where you are locking the entire table during loading, so as SQL is loading the data
to this table, it's going to lock the whole table
*/
	TABLOCK
);

-- Test the quality of the bronze table, check if the data has not shifted and is in correct columns
SELECT * FROM bronze.crm_cust_info;
SELECT COUNT(*) FROM bronze.crm_cust_info;

-----------------

-- FOR bronze.crm_prd_info
TRUNCATE table bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\rgdee\OneDrive\Desktop\SQL Project\SQL Data Warehouse Project - Data with Baraa\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.crm_prd_info;
SELECT COUNT(*) FROM bronze.crm_prd_info;

-----------------

-- For bronze.crm_sales_details
TRUNCATE table bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\rgdee\OneDrive\Desktop\SQL Project\SQL Data Warehouse Project - Data with Baraa\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.crm_sales_details;
SELECT COUNT(*) FROM bronze.crm_sales_details;

-----------------

-- For bronze.erp_cust_az12
TRUNCATE table bronze.erp_cust_az12;

BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\rgdee\OneDrive\Desktop\SQL Project\SQL Data Warehouse Project - Data with Baraa\datasets\source_erp\CUST_AZ12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.erp_cust_az12;
SELECT COUNT(*) FROM bronze.erp_cust_az12;

-----------------

-- For bronze.erp_loc_a101
TRUNCATE table bronze.erp_loc_a101;

BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\rgdee\OneDrive\Desktop\SQL Project\SQL Data Warehouse Project - Data with Baraa\datasets\source_erp\LOC_A101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.erp_loc_a101;
SELECT COUNT(*) FROM bronze.erp_loc_a101;

-----------------

-- For bronze.erp_px_cat_g1v2
TRUNCATE table bronze.erp_px_cat_g1v2;

BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\rgdee\OneDrive\Desktop\SQL Project\SQL Data Warehouse Project - Data with Baraa\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.erp_px_cat_g1v2;
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
