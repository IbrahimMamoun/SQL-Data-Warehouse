/*
===============================================================================
DDL Script: Create Gold Views for gold.dim_products
===============================================================================
Script Purpose:
    This script checks the quality of the data in the silver layer, then creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/


-- this table contains a historical information and as well the current information
--depend on the requirment we will use only the current info, the current info is the data with no end date (NULL)
select 
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pn.prd_end_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
from [silver].[crm_prd_info] pn
left join [bronze].[erp_px_cat_g1v2] pc
on pn.cat_id = pc.id
where prd_end_dt is null --filter out all historical data, after apply this you don't need the end_date

--check the quality of the data
-- check if the prd_key is unqiue and the second table didn't casue any duplicates on the table
select prd_key, count(*) from (select 
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
from [silver].[crm_prd_info] pn
left join [bronze].[erp_px_cat_g1v2] pc
on pn.cat_id = pc.id
where prd_end_dt is null) t
group by prd_key
having count(*) >1
--perfect you don't have any duplicates



-- here we rearrange the columns and rename them

create view gold.dim_products as 
select  
    row_number() over (order by pn.prd_start_dt, pn.prd_key) as prodcut_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from [silver].[crm_prd_info] pn
left join [bronze].[erp_px_cat_g1v2] pc
on pn.cat_id = pc.id
where prd_end_dt is null
-- each row is describing one object and one product and there are no transactions, so this is a DIM table

--check the tables

select * from gold.dim_products
