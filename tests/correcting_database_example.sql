-- 1. Point to the correct database!
USE DataWarehouse; 
GO

-- 2. Drop the table if it exists
IF OBJECT_ID('silver.erp_px_cat_g1v2' , 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
GO

-- 3. Create the table
CREATE TABLE silver.erp_px_cat_g1v2 (
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- 4. Immediately check if the column was created successfully
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'silver' AND TABLE_NAME = 'erp_px_cat_g1v2';

-- This query is only for reference purpose without any dependency on other scripts
