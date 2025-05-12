--SQl Retail Sales Analysis -P1
CREATE DATABASE sql_project_p1;


--Create TABLE
CREATE TABLE retail_sales
		(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category VARCHAR(15),	
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
		);
		
--Data Cleaning
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
		OR sale_date IS NULL
		OR sale_time IS NULL
		OR customer_id IS NULL
		OR gender IS NULL
		OR age IS NULL
		OR category IS NULL
		OR quantiy IS NULL
		OR price_per_unit IS NULL
		OR cogs IS NULL
		OR total_sale IS NULL;
--
DELETE FROM retail_sales
WHERE transactions_id IS NULL
		OR sale_date IS NULL
		OR sale_time IS NULL
		OR customer_id IS NULL
		OR gender IS NULL
		OR age IS NULL
		OR category IS NULL
		OR quantiy IS NULL
		OR price_per_unit IS NULL
		OR cogs IS NULL
		OR total_sale IS NULL;

--Data Exploration

--How many sales do we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

--How many customers do we have?
SELECT COUNT(DISTINCT(customer_id)) as total_customers FROM retail_sales;
--
SELECT DISTINCT category FROM retail_sales;

--Data analysis and Business key problems

--Q1. Write a query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales 
WHERE sale_date='2022-11-05'

--Q2. Write a query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy > 3
  AND EXTRACT(YEAR FROM sale_date) = 2022
  AND EXTRACT(MONTH FROM sale_date) = 11;

--Q3. Write a query to calculate the total sales for each category.

SELECT category,SUM(total_sale) as net_sale
FROM retail_sales
GROUP BY category;

--Q4. Write a query to find the average age of customers who purchased items from the 'Beauty' category.

 SELECT * FROM retail_sales

 SELECT category,AVG(age) as avg_age FROM retail_sales
 GROUP BY category;


--Q5. Write a query to find all transactions where total_sales is greater than 1000.

SELECT * FROM retail_sales 
WHERE total_sale>1000

--Q6. Write query to find total number of transactions made by each gender in each category.

SELECT category,gender,COUNT(*) FROM retail_sales 
GROUP BY category,gender
ORDER BY category;

--Q7. Write a query to calculate the average sale for each month. Find out the best selling month in each year.
SELECT year,month,avg_sale FROM
(
SELECT EXTRACT( YEAR FROM sale_date) as year,EXTRACT( MONTH FROM sale_date)as month,AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year,month) as t1
WHERE rank=1;

--Q8. Write query to find the top 3 customers based on the highest total sales.

SELECT * FROM retail_sales;

SELECT customer_id,SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

--Q9. Write a query to find the number of unique customers who purchased items from each category.

SELECT COUNT(DISTINCT(customer_id)) as unique_customers,category FROM retail_sales
GROUP BY category

--Q10. Write a query to create each shift and number of orders (Example Morning <= 12, Afternoon between 12&17, Evening >17 ).
WITH hourly_sale
AS(
SELECT *,
CASE 
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END as shift
FROM retail_sales)
SELECT shift,COUNT(*) FROM hourly_sale
GROUP BY shift 
	
--Q11. What is the average basket size (items per transaction)?

SELECT AVG(quantiy) AS average_basket_size
FROM retail_sales;

--Q12. What is the gross margin per product category?

SELECT category,
       SUM(total_sale - cogs * quantiy) AS gross_margin
FROM retail_sales
GROUP BY category
ORDER BY gross_margin DESC;

--Q13. Which age group spends the most?

SELECT 
  CASE
    WHEN age < 20 THEN 'Teen'
    WHEN age BETWEEN 20 AND 29 THEN '20s'
    WHEN age BETWEEN 30 AND 39 THEN '30s'
    WHEN age BETWEEN 40 AND 49 THEN '40s'
    ELSE '50+'
  END AS age_group,
  SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY age_group
ORDER BY total_spent DESC;

--Q14. What is the average number of items purchased per customer?

SELECT AVG(total_items) FROM (
  SELECT customer_id, SUM(quantiy) AS total_items
  FROM retail_sales
  GROUP BY customer_id
) AS sub;

--Q15. Which gender spends more on average?

SELECT gender, AVG(total_sale) AS avg_spend
FROM retail_sales
GROUP BY gender;

--Q16. What is the busiest hour of the day (most sales)?

SELECT EXTRACT(HOUR FROM sale_time::TIME) AS hour,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY hour
ORDER BY total_sales DESC;






 
