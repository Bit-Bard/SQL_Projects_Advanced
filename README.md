# SQL_Projects_Advanced
# Advanced Sql Project :  Netflix Movies and TV Shows Data Analysis,  

## Netflix Movies and TV Shows Data Analysis 6

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

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## Author - Dhruv Devaliya-->Bit-Bard

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
Thank you for your support, and I look forward to connecting with you!













