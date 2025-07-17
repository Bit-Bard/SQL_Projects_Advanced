-- Netflix Data Analysis using SQL

CREATE DATABASE sql_p6;
USE sql_p6;

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);
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

SELECT COUNT( * ) FROM netflix;
SELECT * FROM netflix;

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

SELECT COUNT(*) 
FROM netflix
WHERE 
show_id IS NULL OR type IS NULL OR director IS NULL OR title IS NULL OR director IS NULL OR casts IS NULL OR country IS NULL OR date_added IS NULL OR release_year IS NULL OR
rating IS NULL OR duration IS NULL OR listed_in IS NULL OR description IS NULL ;

SELECT * 
FROM netflix
WHERE 
show_id IS NULL OR type IS NULL OR director IS NULL OR title IS NULL OR director IS NULL OR casts IS NULL OR country IS NULL OR date_added IS NULL OR release_year IS NULL OR
rating IS NULL OR duration IS NULL OR listed_in IS NULL OR description IS NULL ;


-- Solutions of 15 business problems

-- 1. Count the number of Movies vs TV Shows
SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY 1;

-- 2. Find the most common rating for movies and TV shows
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

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix
WHERE type='Movie' AND release_year=2020;

-- 4. Identify the longest movie
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;

-- 5. Find content added in the last 5 years

SELECT * 
FROM netflix
WHERE release_year >2016
ORDER BY release_year DESC;

-- 6. Find all the movies/TV shows by director 'Rajiv Chilaka'!
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

-- 7. List all TV shows with more than 5 seasons
SELECT * 
FROM netflix
WHERE type='TV show' AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)> 5;

-- 8. Count the  number of content items in each genre
SELECT 
    TRIM(genre_split.genre) AS genre,
    COUNT(*) AS total_content
FROM netflix n
JOIN JSON_TABLE(
    CONCAT('["', REPLACE(n.listed_in, ',', '","'), '"]'),
    "$[*]" COLUMNS(genre VARCHAR(255) PATH "$")
) AS genre_split
GROUP BY genre;


-- 9. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
SELECT 
	 country, release_year,
     COUNT(show_id) AS total_release,
     ROUND(COUNT(show_id)*100 / (SELECT  COUNT(show_id )FROM netflix WHERE country ='India'),2)  AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC LIMIT 5;

-- 10. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries';

-- 11. Find all content without a director
SELECT * FROM netflix 
WHERE director IS NULL;

-- 12. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * 
FROM netflix
WHERE casts like '%Salman Khan%' AND release_year >2010;

-- 13. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
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

