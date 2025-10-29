create database sql_project;
use sql_project;

create table retail_sales (
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(50),
age int,
category varchar(50),
quantiy int,
price_per_unit float ,
cogs float,
total_sale float 
);

-- ================
-- Rename column 
-- ================
ALTER TABLE retail_sales 
RENAME COLUMN quantiy TO quantity;

-- ==============
-- Data Cleaning
-- ===============

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- ==================
-- Data Exploration
-- ==================

-- How many sales we have?
select count(*) from retail_sales;

-- How many  unique customers we have?
select count( distinct customer_id) from retail_sales;

-- How many  unique category we have?
select distinct category from retail_sales;


-- ===================================================
-- Data Analysis and Buisness key Problems and Answers
-- ==================================================

# Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

# Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than and equal to 2 in the month of Nov-2022.
SELECT 
    transactions_id
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantity >= 2
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
 
 # Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY category;

# Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
 SELECT 
    ROUND(AVG(age), 0) AS avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty';
    
# Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.    
SELECT 
    transactions_id
FROM
    retail_sales
WHERE
    total_sale > 1000;

#  Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(*) AS tran_id
FROM
    retail_sales
GROUP BY category , gender
ORDER BY tran_id;

# Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
    year, 
    month, 
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS ranked_data
WHERE rnk = 1;

# Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

# Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS total_customer
FROM
    retail_sales
GROUP BY category
ORDER BY total_customer;

# Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale as
(
select * , 
case
when extract(hour from sale_time) < 12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Night'
end as shift  from retail_sales)
select shift, count(*) as total_orders
from hourly_sale
group by shift;

-- END OF PROJECT --

