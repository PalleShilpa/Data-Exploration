CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    fross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
    
);


-- ------------------------------------------------------------------------------------------
-- --------- Feature Engineering ------------------------------------------------------------
ALTER TABLE sales DROP COLUMN time_of_day;
-- time_of_day
SELECT time, 
(CASE
	WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    else 'Evening'
END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE
	WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    else 'Evening'
END);


ALTER TABLE sales DROP COLUMN product_review;


-- day_name

SELECT date, DAYNAME(date) as day_name FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = DAYNAME(date);

-- Month_name

 SELECT date, MONTHNAME(date) FROM sales; 
 
ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------




-- ----------------------------------------------------------------------------------------------
-- -------------------------- GENERIC ------------------------------------------------------------

-- How many unique cities does the data have??
SELECT COUNT(DISTINCT (city)) AS no_of_unique_cities FROM sales;
SELECT DISTINCT city FROM sales;

-- In which city is each branch??
SELECT DISTINCT branch FROM sales;
SELECT distinct city, branch FROM sales;

 -- ------------------------------------------------------------------------------------------------
 -- -------------------------------- PRODUCT -------------------------------------------------------
 -- How mnay unique product lines does the data have??
 SELECT COUNT(Distinct product_line) FROM sales;
 
 -- What is the most common payment method??
 SELECT payment_method, COUNT(payment_method) AS cnt FROM sales
 GROUP BY payment_method
 ORDER BY cnt DESC;

-- What i the most selling product line??
SELECT product_line, COUNT(product_line) AS cnt FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month??
SELECT month_name AS month, SUM(total) AS total_revenue FROM sales
GROUP BY month
ORDER BY total_revenue;

-- Which month has largest COGS??
SELECT month_name AS month, SUM(cogs) AS cogs FROM sales
GROUP BY month
ORDER BY cogs;

-- What product line had the largest revenue???
SELECT product_line, SUM(total) AS total_revenue FROM sales
GROUP BY product_line
ORDER BY total_revenue;

-- Which city had the largest revenue??
SELECT city, branch, SUM(total) as Total_revenue FROM sales
GROUP BY city, branch
ORDER BY Total_revenue DESC;

-- What product line had the largest VAT??
SELECT product_line, AVG(VAT) AS avg_tax FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which product sold more producs than the average product sold??
SELECT branch, SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender??
SELECT gender, product_line, COUNT(gender) AS total_count FROM sales
GROUP BY gender, product_line
ORDER BY total_count;

-- What is the average rating of each product line??
SELECT ROUND(AVG(rating), 2) AS avg_rating, product_line FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- ------------------------------------------------------------------------------------------
-- ------------------------------  Sales -------------------------------------------------------
-- 
-- Number of sales made in each time of the day per weekday??
SELECT time_of_day, COUNT(*) AS total_sales FROM sales
WHERE day_name = 'Sunday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which type of cutomer types brigs most revenue??
SELECT customer_type, SUM(total) AS Revenue FROM sales
GROUP BY customer_type
ORDER BY Revenue DESC; 

-- Which city has the largest tax percent? VAT(value added tax)
SELECT city, AVG(VAT) AS tax_percent FROM sales
GROUP BY city
ORDER BY tax_percent DESC;

-- Whhich customer type pays the most in VAT?
SELECT customer_type, SUM(VAT) AS total_vat FROM sales
GROUP BY customer_type
ORDER BY total_vat DESC;
-- ---------------------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------------------
-- -------------------- Customer --------------------------------------------------------------------------

-- How many unique customer types does the data have??
SELECT DISTINCT customer_type FROM sales;

-- How many unique payment methods deos the data have?
SELECT DISTINCT payment_method FROM sales;

-- What is the most common customer type??
SELECT customer_type, count(*)  AS Cst_cnt FROM sales
GROUP BY customer_type
ORDER BY Cst_cnt DESC;

-- What is the gender of most of the customers?
SELECT gender, count(*)  AS Cst_cnt FROM sales
GROUP BY gender
ORDER BY Cst_cnt DESC;

-- What is the gender distribution per branch?
SELECT gender, branch, count(*)  AS Cst_cnt FROM sales
GROUP BY gender, branch
ORDER BY Cst_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, branch, AVG(rating) AS avg_rating
FROM sales
-- WHERE branch = 'A'
GROUP BY time_of_day, branch
ORDER BY avg_rating;

-- Which day for the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

--  Which day of the week has the best average ratings per branch??
SELECT day_name, branch, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name, branch
ORDER BY avg_rating DESC;


