/*
===============================================================================
DDL Script: Create Gold Views for gold.fact_sales
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



--by looking at the data we can see transactions and events and we have alot of id's and  dates and measures like sales, quantity, and price
-- so this is the Fact table
-- use the dimension's surrogate keys insted of IDs to easily connect facts with dimensions, so we need to join 2 dimensions in order to get surrogate key. this process called data lookup 
-- to rearrange the columns sort them to logical groups to improve readability
-- but the dimension keys first, then the dates and lastly but the measures
create view gold.fact_sales as
select 
sd.sls_ord_num as order_number, 
pr.prodcut_key, --dimension key and will help us to connect the data model 
cu.customer_key, --dimension key
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shpping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity, 
sd.sls_price as price
from [silver].[crm_sales_details] sd
left join [gold].[dim_products] pr 
on sd.sls_prd_key = pr.product_number
left join [gold].[dim_customers] cu
on sd.sls_cust_id = cu.customer_id

-- check the table and check if all dim tables can successfully join to the fact table
select * from gold.fact_sales

select * 
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
left join gold.dim_products p
on p.prodcut_key = f.prodcut_key
where c.customer_key is null or p.prodcut_key is null --to check if everything works perfectly
