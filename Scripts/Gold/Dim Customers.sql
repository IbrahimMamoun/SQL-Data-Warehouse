/*
===============================================================================
DDL Script: Create Gold Views for gold.dim_customers
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


select 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_material_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
from [silver].[crm_cust_info] ci
left join silver.erp_cust_az12 ca -- if i use inner join then if the other table doesn't have all the info about the customers tha I will loose some customers, so always start with master table and join the table with other using left join to avoid losing data
on ci.cst_key = ca.cid
left join [silver].[erp_loc_a101] la
on ci.cst_key = la.cid

-- you need to check if there are any duplicates after joining the tables together 

select cst_id, count(*) from (
	select 
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_material_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
	from [silver].[crm_cust_info] ci
	left join silver.erp_cust_az12 ca
	on ci.cst_key = ca.cid
	left join [silver].[erp_loc_a101] la
	on ci.cst_key = la.cid
)t
group by cst_id
having count(*) >1
-- we didn't find and duplicates in the data, and joining the tables didn't cause any issues 


-- we have 2 gender columns lets check them 
select distinct
	ci.cst_gndr,
	ca.gen
from [silver].[crm_cust_info] ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join [silver].[erp_loc_a101] la
on ci.cst_key = la.cid
order by 1,2


--sometimes the two tables are giving different informations, or you have got a data from the one table and get n\a in the another table, if you take a close look you will see a NULL although you deal with it in the silver layer, this NULL doesn't come directly from the tables, it comes from joining the tables when SQL finds no match(there are customers from the main table that doesn't avilable in the erp table and you got NULL)
-- the main issue that when the tables giving you different information, you need to ask the expert which source is the master for those values, the CRM or ERP source
-- in our project the master source of customer data is CRM 
-- the query will be :

select distinct
	ci.cst_gndr,
	ca.gen,
	case when ci.cst_gndr != 'n\a' then ci.cst_gndr --CRM is the master for gender info
		 else coalesce(ca.gen,'n\a')
		end as new_gen
from [silver].[crm_cust_info] ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join [silver].[erp_loc_a101] la
on ci.cst_key = la.cid
order by 1,2


-- we have perfect new column, and that is the data integration, integrate to data source in one



select 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_material_status,
    case when ci.cst_gndr != 'n\a' then ci.cst_gndr --CRM is the master for gender info
		 else coalesce(ca.gen,'n\a')
		end as new_gen,
	ci.cst_create_date,
	ca.bdate,
	la.cntry
from [silver].[crm_cust_info] ci
left join silver.erp_cust_az12 ca -- if i use inner join then if the other table doesn't have all the info about the customers tha I will loose some customers, so always start with master table and join the table with other using left join to avoid losing data
on ci.cst_key = ca.cid
left join [silver].[erp_loc_a101] la
on ci.cst_key = la.cid

--now you need to rename the coulumns by folowing specific roles (snacke case)
-- also maybe you need to rearange the columns 

create view gold.dim_customers as


select 
	row_number() over (order by cst_id) as customer_key, --surrogate key
	ci.cst_id as customer_id,
	ci.cst_key as custoemr_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	la.cntry as country,
	ci.cst_material_status as marital_status,
    case when ci.cst_gndr != 'n\a' then ci.cst_gndr --CRM is the master for gender info
		 else coalesce(ca.gen,'n\a')
		end as gender,
	ca.bdate as birth_date,
	ci.cst_create_date as create_date
	
from [silver].[crm_cust_info] ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join [silver].[erp_loc_a101] la
on ci.cst_key = la.cid
-- in this table holds a descriptive info about customers, and all columns are describing the customer information. also you don't have any transactions here. so it's a DIM table



-- check the quality of the view

select * from gold.dim_customers

select distinct gender from gold.dim_customers
