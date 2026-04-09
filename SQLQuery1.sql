create database zepto_project;

use zepto_project;

--data import
-- zepto_project  - tasks - import flat file - load the csv. file 


-- check data 
select * from zepto;

-- Check data types 
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'zepto';

-- add columns 

alter table zepto
add sku_id int identity(1,1) primary key;

-- data exploration

--count of rows
select count(*) from zepto;

--sample data 
select top 10 * from zepto;

--Null value
select * from zepto
where name is null or
category is null or
mrp is null or
discountPercent is null or
discountedSellingPrice is null or
weightInGms is null or
outOFStock is null or
quantity is null;

-- deferent product Category
select distinct category from zepto 
order by Category;

-- Product in Stock and Out of Stock 
select outOfStock , count(sku_id) from zepto 
group by outOfStock;

-- Product Name persent multiple time
select name,count(sku_id) as Number from zepto 
group by name 
having count(sku_id) > 1
order by COUNT(sku_id) DESC;

--DATA CLEANING 

--product with price 0
select * from zepto 
where mrp = 0 or discountedSellingPrice = 0;

delete from zepto
where mrp = 0;

-- covert  mrp into INR
update zepto
set mrp =  mrp/100.0 , discountedSellingPrice = discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto;

-- Q.1 Found top 10 best-value products based on discount percentage
select  distinct top 10 name, mrp , discountPercent from zepto
order by discountPercent DESC;

-- Q.2 Identified high-MRP products that are currently out of stock
select distinct name,mrp from zepto
where outOfStock = 'True' and mrp > 300
order by  mrp Desc;

-- Q.3 Estimated potential revenue for each product category
select Category, sum(discountedSellingPrice*availableQuantity) as Total_revenue from zepto
group by Category
order by Total_revenue;

-- Q.4 Filtered expensive products (MRP > ₹500) with minimal(10%) discount
select name,mrp,discountPercent from zepto
where mrp > 500 and discountPercent < 10
order by mrp DESC, discountPercent DESC;

--Q.5 Ranked top 5 categories offering highest average discounts
select  top 5 Category, round(avg(discountPercent),2) as AVG_Discount from zepto
group by Category
order by AVG_Discount DESC;

-- Q.6 Calculated price per gram for product above 100g to identify value-for-money products
select distinct name, weightInGms,discountedSellingPrice, 
round(discountedSellingPrice/weightInGms,2) as Price_per_gram from zepto
where weightInGms >=100
order by Price_per_gram ASC;

-- Q.7 Grouped products based on weight into Low, Medium, and Bulk categories
select distinct name, weightInGms,
case when weightInGms < 1000 then 'LOW'
	 when weightInGms < 5000 then 'Medium'
	 else 'Bulk'
	 END as Weight_category
from zepto;


--Q.8 Measured total inventory weight per product category
Select Category, sum(weightInGms*availableQuantity) as Total_weight from zepto
group by Category
order by Total_weight;

SELECT 
    category, 
    SUM(CAST(weightInGms AS BIGINT) * availableQuantity) AS Total_weight
FROM zepto
GROUP BY category
ORDER BY Total_weight;


