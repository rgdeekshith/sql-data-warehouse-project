CREATE OR ALTER PROCEDURE bronze.load_bronze (@BasePath NVARCHAR(MAX)) AS
BEGIN
	DECLARE @DynamicSQL NVARCHAR(MAX);

	-- FOR bronze.crm_cust_info
	TRUNCATE table bronze.crm_cust_info; 
	SET @DynamicSQL = '
	BULK INSERT bronze.crm_cust_info
	FROM ''' + @BasePath + '\source_crm\cust_info.csv''
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
	EXEC sp_executesql @DynamicSQL;

	-- FOR bronze.crm_prd_info
	TRUNCATE table bronze.crm_prd_info;
	SET @DynamicSQL = '
	BULK INSERT bronze.crm_prd_info
	FROM ''' + @BasePath + '\source_crm\prd_info.csv''
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
	EXEC sp_executesql @DynamicSQL;

	-- For bronze.crm_sales_details
	TRUNCATE table bronze.crm_sales_details;
	SET @DynamicSQL = '
	BULK INSERT bronze.crm_sales_details
	FROM ''' + @BasePath + '\source_crm\sales_details.csv''
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
	EXEC sp_executesql @DynamicSQL;

	-- For bronze.erp_cust_az12
	TRUNCATE table bronze.erp_cust_az12;
	SET @DynamicSQL = '
	BULK INSERT bronze.erp_cust_az12
	FROM ''' + @BasePath + '\source_erp\CUST_AZ12.csv''
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
	EXEC sp_executesql @DynamicSQL;

	-- For bronze.erp_loc_a101
	TRUNCATE table bronze.erp_loc_a101;
	SET @DynamicSQL = '
	BULK INSERT bronze.erp_loc_a101
	FROM ''' + @BasePath + '\source_erp\LOC_A101.csv''
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
	EXEC sp_executesql @DynamicSQL;

	-- For bronze.erp_px_cat_g1v2
	TRUNCATE table bronze.erp_px_cat_g1v2;
	SET @DynamicSQL = '
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM ''' + @BasePath + '\source_erp\PX_CAT_G1V2.csv''
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
	EXEC sp_executesql @DynamicSQL;
END
