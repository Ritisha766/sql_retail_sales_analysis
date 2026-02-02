#PROJECT 1: SQL PRETAIL ANALYSIS
DROP DATABASE IF EXISTS SQLPROJECTP1;
CREATE DATABASE SQLPROJECTP1;

USE SQLPROJECTP1;
DROP TABLE IF EXISTS retail_sales;
#CREATE TABLE
CREATE TABLE retail_sales(
transactions_id INT PRIMARY KEY,	
sale_date DATE,	
sale_time TIME,	
customer_id INT,	
gender VARCHAR(15),	
age INT,	
category VARCHAR(15),	
quantiy INT,	
price_per_unit FLOAT,
cogs FLOAT,	
total_sale FLOAT
);
 SELECT * FROM retail_sales; 


SELECT *
FROM retail_sales
WHERE transactions_id IS NULL OR
sale_date IS NULL OR	
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR 	
age IS NULL OR	
category IS NULL OR 
quantiy=0 OR	
price_per_unit=0 OR
cogs=0 OR
total_sale=0;

#DELETING THE NULL ROWS(DATA CLEANING)
DELETE FROM retail_sales
WHERE transactions_id IS NULL OR
sale_date IS NULL OR	
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR 	
age IS NULL OR	
category IS NULL OR 
quantiy=0 OR	
price_per_unit=0 OR
cogs=0 OR
total_sale=0;

 SELECT COUNT(*) FROM retail_sales;
 
#DATA EXPLORATION

#HOW MANY SALES DO WE HAVE?
SELECT COUNT(*) AS TOTAL_SALES
FROM retail_sales; 

#HOW MANY UNIQUE CUSTOMERS DO WE HAVE?
SELECT COUNT(DISTINCT customer_id) AS TOTAL_CUSTOMERS
FROM retail_sales; 
 
 #HOW MANY CATEGORIES DO WE HAVE?
SELECT DISTINCT category AS TOTAL_CATEGORIES
FROM retail_sales; 
 
#WHAT IS THE AVG TOTAL_SALE
SELECT ROUND(AVG(total_sale),2) AS AVG_TOTAL_SALE
FROM retail_sales;


#Data Analysis & Findings
#Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';

#Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT retail_sales.*
FROM retail_sales
WHERE category='Clothing' AND quantiy>=4 AND 
DATE_FORMAT(sale_date,'%Y-%m')='2022-11';

#Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT Category,SUM(total_sale) AS total_sale_each_category
FROM retail_sales
GROUP BY Category;

#Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT CAST(AVG(age) AS SIGNED) AS AVG_AGE
FROM retail_sales
WHERE category='Beauty';
#Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale>1000;

#Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category,gender,COUNT(transactions_id)
FROM retail_sales
GROUP BY category,gender
ORDER BY category, gender;

#Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT SALE_YEAR,BESTSELLING_MONTH,avg_total_sale
FROM(SELECT YEAR(sale_date) AS SALE_YEAR,MONTH(sale_date) AS BESTSELLING_MONTH,
ROUND(AVG(total_sale),2) avg_total_sale,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS SALES_RANK
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY YEAR(sale_date), MONTH(sale_date))t1
WHERE SALES_RANK=1;

#**Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale)
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

#Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
##Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(SELECT sale_time,
 CASE
	WHEN HOUR(sale_time)<12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS SHIFT
FROM retail_sales)
SELECT SHIFT,COUNT(*) AS TOTAL_ORDERS FROM hourly_sale
GROUP BY SHIFT ;

#end of project

