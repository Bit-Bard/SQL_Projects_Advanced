# SQL_Projects_Advanced
# Advanced Sql Project :  Netflix Movies and TV Shows Data Analysis,  Zepta Sales Analysis

## Netflix Movies and TV Shows Data Analysis 5

**Project Title**: Netflix Movies and TV Shows Data Analysis
**Level**: Advanced
**Database**: [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

![Logo](Netflix%20Analysis/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.


## Project Structure
###  Database Setup

- **Database Creation**: Created a database named `sql_p6`.
### Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
Add Data 
```sql
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/dhruv/OneDrive/Documents/Desktop/SQL projects/Netflix Analysis/netflix_titles.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(show_id, type, title, director, casts, country, date_added, release_year, rating, duration, listed_in, description);
```

Conversion of blank spaces into NULL values 
```sql
UPDATE netflix
SET
  show_id      = NULLIF(TRIM(show_id), ''),
  type         = NULLIF(TRIM(type), ''),
  title        = NULLIF(TRIM(title), ''),
  director     = NULLIF(TRIM(director), ''),
  casts        = NULLIF(TRIM(casts), ''),
  country      = NULLIF(TRIM(country), ''),
  date_added   = NULLIF(TRIM(date_added), ''),
  release_year = NULLIF(TRIM(release_year),''),
  rating       = NULLIF(TRIM(rating), ''),
  duration     = NULLIF(TRIM(duration), ''),
  listed_in    = NULLIF(TRIM(listed_in), ''),
  description  = NULLIF(TRIM(description), '');
```
### No Entity-Relationship-Diagram needed

## Business Problems & Solutions

Q1. Count the number of Movies vs TV Shows
```sql
SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY 1;
```

Q2. Find the most common rating for movies and TV shows
```sql
SELECT type, rating
FROM
(
	SELECT
		type,
		rating,
		COUNT(*),
		RANK () OVER (PARTITION BY type ORDER BY COUNT(*) DESC ) AS Ranking
	FROM netflix
	GROUP BY 1,2
) AS t1
WHERE Ranking =1;
```

Q3. List all movies released in a specific year (e.g., 2020)
```sql
SELECT *
FROM netflix
WHERE type='Movie' AND release_year=2020;
```

Q4. Identify the longest movie
```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;
```

Q5. Find content added in the last 5 years
```sql
SELECT * 
FROM netflix
WHERE release_year >2016
ORDER BY release_year DESC;
```

Q6. Find all the movies/TV shows by director 'Rajiv Chilaka'!
```sql
SELECT 
    n.title,
    n.type,
    TRIM(director_split.director_name) AS director_name
FROM netflix n
JOIN JSON_TABLE(
    CONCAT(
        '["',
        REPLACE(
            REPLACE(REPLACE(n.director, '"', ''), '[', ''), ']', ''
        ), 
        '"]'
    ),
    "$[*]" COLUMNS(director_name VARCHAR(255) PATH "$")
) AS director_split
WHERE director_split.director_name = 'Yemi Amodu'AND n.director IS NOT NULL AND n.director != '';
```

Q7. List all TV shows with more than 5 seasons
```sql
SELECT * 
FROM netflix
WHERE type='TV show' AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)> 5;
```

Q8. Count the  number of content items in each genre
```sql
SELECT 
    TRIM(genre_split.genre) AS genre,
    COUNT(*) AS total_content
FROM netflix n
JOIN JSON_TABLE(
    CONCAT('["', REPLACE(n.listed_in, ',', '","'), '"]'),
    "$[*]" COLUMNS(genre VARCHAR(255) PATH "$")
) AS genre_split
GROUP BY genre;
```

Q9. Find each year and the average numbers of content release by India on netflix. return top 5 year with highest avg content release !
```sql
SELECT 
	 country, release_year,
     COUNT(show_id) AS total_release,
     ROUND(COUNT(show_id)*100 / (SELECT  COUNT(show_id )FROM netflix WHERE country ='India'),2)  AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC LIMIT 5;
```

Q10. List all movies that are documentaries
```sql
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

Q11. Find all content without a director
```sql
SELECT * FROM netflix 
WHERE director IS NULL;
```

Q12. Find how many movies actor 'Salman Khan' appeared in last 10 years!
```sql
SELECT * 
FROM netflix
WHERE casts like '%Salman Khan%' AND release_year >2010
```

Q13.  Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%Kill%' OR description LIKE '%Violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
```

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

# Zepto Sales Analysis Project 6

This is a complete, real-world data analyst portfolio project based on an e-commerce inventory dataset scraped from [Zepto](https://www.zeptonow.com/) — one of India’s fastest-growing quick-commerce startups. This project simulates real analyst workflows, from raw data exploration to business-focused data analysis.

![Zepto](Zepto%20Analysis/Zepto_Logo.png)
 
**Project Title**: Zepto Sales  Analysis
**Level**: Advanced 
**Database**: [Click Here to get Dataset](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv)

Data base & Table Creation
```sql
CREATE DATABASE sql_p5;
USE sql_p5;
```

```sql
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
```

## Data Cleaning and exploration
```sql
-- CHECKING NULL values
SELECT * FROM zepto 
WHERE category IS NULL OR name IS NULL OR mrp IS NULL OR discountPercent IS NULL OR availableQuantity IS NULL OR discountedSellingPrice IS NULL OR  weightInGms IS NULL OR
outOfStock IS NULL OR quantity IS NULL;
```

```sql
-- different product category
SELECT DISTINCT(category)
FROM zepto;
```

```sql
-- products in stock vs out of stock
SELECT  COUNT(sku_id), outOfStock
FROM zepto
GROUP BY 2;
```

```sql
-- product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;
```

```sql
-- products with price = 0
SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice =0;
DELETE FROM zepto
WHERE mrp=0 OR discountedSellingPrice =0;
```

```sql
-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0, discountedSellingPrice = discountedSellingPrice/100.0;
```

## Data Analysis --> Understanding Real world Problems

Q1. Find the top 10 best-value products based on the discount percentage.
```sql
SELECT DISTINCT(name), mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10; 
```

Q2.What are the Products with High MRP but Out of Stock
```sql
SELECT DISTINCT name , mrp 
FROM zepto
WHERE outOfStock = 'TRUE' AND mrp>250
ORDER BY mrp DESC;
```

Q3.Calculate Estimated Revenue for each category
```sql
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC ;
```

Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
```sql
SELECT *
FROM zepto
WHERE mrp > 500 AND discountPercent < 10.00
ORDER BY mrp DESC, discountPercent DESC;
```

Q5. Identify the top 5 categories offering the highest average discount percentage.
```sql
SELECT
	category,
    ROUND(AVG(discountPercent),2) AS AVG_DISCOUNT
FROM ZEPTO
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
```

Q6. Find the price per gram for products above 100g and sort by best value
```sql
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;
```

Q7.Group the products into categories like Low, Medium, Bulk.
```sql
SELECT DISTINCT name, weightInGms,
CASE
	WHEN weightInGms < 1000 THEN 'LOW'
    WHEN weightInGms < 5000 THEN 'MEDIUM'
    ELSE 'BULK'
END AS weight_Category
FROM zepto;
```

Q8.What is the Total Inventory Weight Per Category 
```sql
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
```
## Conclusions
The goal is to simulate how actual data analysts in the e-commerce or retail industries work behind the scenes to use SQL to:
1. Set up a messy, real-world e-commerce inventory **database**
2. Perform **Exploratory Data Analysis (EDA)** to explore product categories, availability, and pricing inconsistencies
3. Implement **Data Cleaning** to handle null values, remove invalid entries, and convert pricing from paise to rupees
4. Write **business-driven SQL queries** to derive insights around **pricing, inventory, stock availability, revenue** and more

## Technology Stack
- **Database**: `MySQL`
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions

## How to Run the Project
1. Install `MySQL`.
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

## Author - Dhruv Devaliya-->Bit-Bard

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
Thank you for your support, and I look forward to connecting with you!
