/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

create or alter procedure bronze.load_bronze as
begin

	declare @start_time DATETIME, @end_time DATETIME, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
		print'==============================================';
		print'Loading Bronze Layer';
		print'==============================================';

		print '---------------------------------------------';
		print 'Loading CRM Tables';
		print '---------------------------------------------';

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE Table [bronze].[crm_cust_info]; -- our method is truncate then load the data, so wo need to make sure that the table is empty then load the data
	
		print '>> Inserting Data into: bronze.crm_cust_info';
		Bulk insert [bronze].[crm_cust_info]  --SQL here understand that you are doing a bulk insert not a noraml insert
		from 'C:\Users\user\OneDrive\Desktop\Data Analysis\SQL\Baraa\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' --we specify the file name in the last
		with (
			FIRSTROW = 2, --cuz in the file the first row is a header, so the data starts from the second row
			FIELDTERMINATOR = ',',
			TABLOCK --OPTIONAL ORDER TO IMPROVE PERFORMANCE, SO SQL WILL LOCK THE ENTIRE TABE DURING LOADING IT
		);
		set @end_time = getdate();
		print'>> Load Duration: ' + cast (datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'>>----------------------------------------------------------------------------------------';
		-- we need to test the quality of the table
		--select * from [bronze].[crm_cust_info]
		--select count(*) from [bronze].[crm_cust_info] --correct number of rows, in the file there are 18494 but we agnore the first column
		-- check that the data is in each column, and the data is in the correct column
		-- if you run the bulk insert again you will get the data duplicates, so we need to make sure that the table is empty first 
		-- by using truncate you are refreshing the table, so of there is any changes to the file it will loaded to the table here


		set @start_time = getdate();
		print '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE Table [bronze].[crm_prd_info]; 
	
		print '>> Inserting Data into: bronze.crm_prd_info';
		Bulk insert   [bronze].[crm_prd_info]
		from 'C:\Users\user\OneDrive\Desktop\Data Analysis\SQL\Baraa\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' 
		with (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		set @end_time = getdate();
		print'>> Load Duration: ' + cast (datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'>>----------------------------------------------------------------------------------------';

		--test
		--select * from [bronze].[crm_prd_info]
		--select count(*) from  [bronze].[crm_prd_info] --397

		set @start_time = getdate();
		print '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE Table [bronze].[crm_sales_details]; 

		print '>> Inserting Data into: bronze.crm_sales_details';
		Bulk insert   [bronze].[crm_sales_details]
		from 'C:\Users\user\OneDrive\Desktop\Data Analysis\SQL\Baraa\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' 
		with (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		set @end_time= getdate();
		print'>> Load Duration: ' + cast (datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'>>----------------------------------------------------------------------------------------';
		--test
		--select * from [bronze].[crm_sales_details]
		--select count(*) from  [bronze].[crm_sales_details]




		print '---------------------------------------------';
		print 'Loading ERP Tables';
		print '---------------------------------------------';

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE Table [bronze].[erp_cust_az12]; 

		print '>> Inserting Data into: bronze.erp_cust_az12';
		Bulk insert  [bronze].[erp_cust_az12] 
		from 'C:\Users\user\OneDrive\Desktop\Data Analysis\SQL\Baraa\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv' 
		with (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		set @end_time=GETDATE();
		print'>> Load Duration: ' + cast (datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'>>----------------------------------------------------------------------------------------';

		--test
		--select * from [bronze].[erp_cust_az12]
		--select count(*) from  [bronze].[erp_cust_az12][bronze]


		set @start_time =GETDATE();
		print '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE Table [bronze].[erp_loc_a101]; 

		print '>> Inserting Data into: bronze.erp_loc_a101';
		Bulk insert [bronze].[erp_loc_a101] 
		from 'C:\Users\user\OneDrive\Desktop\Data Analysis\SQL\Baraa\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv' 
		with (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		set @end_time = getdate();
		print'>> Load Duration: ' + cast (datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'>>----------------------------------------------------------------------------------------';
		--test
		--select * from [bronze].[erp_loc_a101]
		--select count(*) from [bronze].[erp_loc_a101] --18484


		set @start_time = getdate();
		print '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE Table [bronze].[erp_px_cat_g1v2]; 

		print '>> Inserting Data into: bronze.erp_px_cat_g1v2';
		Bulk insert [bronze].[erp_px_cat_g1v2] 
		from 'C:\Users\user\OneDrive\Desktop\Data Analysis\SQL\Baraa\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv' 
		with (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		set @end_time = getdate();
		print'>> Load Duration: ' + cast (datediff(second,@start_time,@end_time) as nvarchar) + 'seconds';
		print'>>----------------------------------------------------------------------------------------';

		set @batch_end_time = getdate();
		print'============================================================================================';
		print'Loading Bronze Layer is Completed';
		print'Total Load Duration: '+cast(datediff(second,@batch_start_time, @batch_end_time) as nvarchar) +' seconds';
	end try
	begin catch --sql runs try block, and if it fails it runs the catch block to handle the error
		print '=============================================';
		print'ERROR OCCURED DURING LOADING BRONZE LAYER';
		print'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT'ERROR MESSAGE'+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR MESSAGE'+ CAST(ERROR_STATE() AS NVARCHAR);
		print '=============================================';

	end catch
	--test
	--select * from [bronze].[erp_px_cat_g1v2]
	--select count(*) from [bronze].[erp_px_cat_g1v2] --18484

end

-- this is a really nice script in order to load the data bronze layer, so we will use the script frequently to det the data to the DWH, so we will create a stored procedure to save it.
-- to identify bottlenecks, optimize performance, monitor trends, detect issues you need to track ETL duration








