-- This procedure centralizes the data ingestion for the entire Bronze layer.
-- It accepts @BasePath, which is the folder path where the 'datasets' folder is located.
CREATE OR ALTER PROCEDURE bronze.load_bronze (@BasePath NVARCHAR(MAX)) AS
BEGIN
    -- We use a variable to build our SQL commands as text before executing them.
    DECLARE @DynamicSQL NVARCHAR(MAX);

    ---------------------------------------------------------------------------
    -- 1. Load crm_cust_info
    ---------------------------------------------------------------------------
    -- First, we clear existing data to prevent duplicates (Full Load strategy).
    TRUNCATE TABLE bronze.crm_cust_info; 

    -- We construct the BULK INSERT command by gluing the base path to the file sub-folder.
    -- Note: Triple single quotes (''') are used to put one literal quote around the path.
    SET @DynamicSQL = '
    BULK INSERT bronze.crm_cust_info
    FROM ''' + @BasePath + '\source_crm\cust_info.csv''
    WITH ( 
        FIRSTROW = 2,           -- Skip the header row in the CSV
        FIELDTERMINATOR = '','', -- Use a comma to separate columns
        TABLOCK                 -- Lock the table during load for better speed
    );';
    
    -- This command tells SQL Server to run the text string we just built.
    EXEC sp_executesql @DynamicSQL;

    ---------------------------------------------------------------------------
    -- 2. Load crm_prd_info
    ---------------------------------------------------------------------------
    TRUNCATE TABLE bronze.crm_prd_info;
    SET @DynamicSQL = '
    BULK INSERT bronze.crm_prd_info
    FROM ''' + @BasePath + '\source_crm\prd_info.csv''
    WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
    EXEC sp_executesql @DynamicSQL;

    ---------------------------------------------------------------------------
    -- 3. Load crm_sales_details
    ---------------------------------------------------------------------------
    TRUNCATE TABLE bronze.crm_sales_details;
    SET @DynamicSQL = '
    BULK INSERT bronze.crm_sales_details
    FROM ''' + @BasePath + '\source_crm\sales_details.csv''
    WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
    EXEC sp_executesql @DynamicSQL;

    ---------------------------------------------------------------------------
    -- 4. Load erp_cust_az12
    ---------------------------------------------------------------------------
    TRUNCATE TABLE bronze.erp_cust_az12;
    SET @DynamicSQL = '
    BULK INSERT bronze.erp_cust_az12
    FROM ''' + @BasePath + '\source_erp\CUST_AZ12.csv''
    WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
    EXEC sp_executesql @DynamicSQL;

    ---------------------------------------------------------------------------
    -- 5. Load erp_loc_a101
    ---------------------------------------------------------------------------
    TRUNCATE TABLE bronze.erp_loc_a101;
    SET @DynamicSQL = '
    BULK INSERT bronze.erp_loc_a101
    FROM ''' + @BasePath + '\source_erp\LOC_A101.csv''
    WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
    EXEC sp_executesql @DynamicSQL;

    ---------------------------------------------------------------------------
    -- 6. Load erp_px_cat_g1v2
    ---------------------------------------------------------------------------
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    SET @DynamicSQL = '
    BULK INSERT bronze.erp_px_cat_g1v2
    FROM ''' + @BasePath + '\source_erp\PX_CAT_G1V2.csv''
    WITH ( FIRSTROW = 2, FIELDTERMINATOR = '','', TABLOCK );';
    EXEC sp_executesql @DynamicSQL;

END
