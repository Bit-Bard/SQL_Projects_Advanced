-- Zepto Analysis

CREATE DATABASE sql_p5;
USE sql_p5;

-- DataBase Setup
DROP TABLE IF EXISTS zepto;
create table zepto (
sku_id SERIAL PRIMARY KEY, -- it will create columns of primary key
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2), -- 8-total int 2-int after decimal 
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock VARCHAR(10),	
quantity INTEGER
);

SELECT COUNT(*) FROM zepto;
SELECT * FROM zepto LIMIT 10;

-- Data Cleaning and exploration

-- CHECKING NULL values
SELECT * FROM zepto 
WHERE category IS NULL OR name IS NULL OR mrp IS NULL OR discountPercent IS NULL OR availableQuantity IS NULL OR discountedSellingPrice IS NULL OR  weightInGms IS NULL OR
outOfStock IS NULL OR quantity IS NULL;

-- different product category
SELECT DISTINCT(category)
FROM zepto;

-- products in stock vs out of stock
SELECT  COUNT(sku_id), outOfStock
FROM zepto
GROUP BY 2;

-- product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

-- products with price = 0
SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice =0;
DELETE FROM zepto
WHERE mrp=0 OR discountedSellingPrice =0;

-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0, discountedSellingPrice = discountedSellingPrice/100.0;

-- Data Analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT(name), mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10; 

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name , mrp 
FROM zepto
WHERE outOfStock = 'TRUE' AND mrp>250
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC ;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT *
FROM zepto
WHERE mrp > 500 AND discountPercent < 10.00
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT
	category,
    ROUND(AVG(discountPercent),2) AS AVG_DISCOUNT
FROM ZEPTO
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE
	WHEN weightInGms < 1000 THEN 'LOW'
    WHEN weightInGms < 5000 THEN 'MEDIUM'
    ELSE 'BULK'
END AS weight_Category
FROM zepto;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


-- End --








