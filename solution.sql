-- Netflix Project

CREATE TABLE netflix 
(
	show_id VARCHAR (6),
	type VARCHAR (10),
	title VARCHAR (150),
	director VARCHAR (208),
	casts VARCHAR (1000),
	country VARCHAR (150),
	date_added VARCHAR (50),
	release_year INT,
	rating VARCHAR (10),
	duration VARCHAR (15),
	listed_in VARCHAR (100),
	description	VARCHAR (250)
)

SELECT * FROM netflix

SELECT 
	COUNT(*) AS Total_content
FROM netflix;

SELECT
	DISTINCT type
FROM netflix;


SELECT * FROM netflix

-- 15 Business Problems


-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*) AS total_content
FROM netflix
GROUP BY type

-- 2. Find the most common rating for movies and TV shows


SELECT type, rating
FROM (
    SELECT
        type,
        rating,
        -- COUNT(*) AS cnt,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
) t1
WHERE ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

-- filter 2020
-- movies


SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix

SELECT
	UNNEST(String_to_Array(country , ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY COUNTRY
ORDER BY total_content DESC -- hamm ider 2 bhi likh skt
LIMIT 5


-- 5. Identify the longest movie?

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration	) FROM netflix)


-- 6. Find content added in the last 5 years
SELECT 
	*
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD , YYYY') >= CURRENT_DATE - INTERVAL '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'


-- 8. List all TV shows with more than 5 seasons

SELECT
	*
FROM netflix
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1) :: numeric > 5

-- SELECT
-- 	SPLIT_PART('Apple Banana Mango ', ' ', 1 )

-- 9. Count the number of content items in each genre

SELECT
	-- STRING_TO_ARRAY(listed_in , ',')
	UNNEST(STRING_TO_ARRAY(listed_in , ',')) AS genre,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY genre -- 1 bhi likh skte h 


-- 10. Find each year and average number of content released in India on netflix.
-- return top 5 year with highest avg content rating !

-- total_content = 333/ 972


SELECT
	-- TO_DATE(date_added , 'Month DD, YYYY'),
	EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*):: numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India'):: numeric * 100,2)
	AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY year -- 1 bhi likh skte h 




-- 11. List all movies that are documentaries

SELECT * FROM netflix
WHERE 
	listed_in LIKE '%Documentaries%'
	-- listed_in ILIKE '%documentaries%' -- ager hamen copital ki jagha small use ker diya ho to I likh do

-- 12. Find all content without a director

SELECT * FROM netflix
WHERE 
	director IS NULL

	
-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT( YEAR FROM CURRENT_DATE) - 10



14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	-- show_id,
	-- casts,
	-- STRING_TO_ARRAY(casts , ',')
	UNNEST(STRING_TO_ARRAY(casts , ',')) AS actors,
	COUNT(*) AS total_content
	FROM netflix
	WHERE country ILIKE '%India%'
	GROUP BY actors
	ORDER BY total_content DESC
	LIMIT 10


15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in
the description field. Label content containing these keywords as 'Bad' and all other
content as 'Good'. Count how many items fall into each category.


WITH new_table
AS
(
SELECT 
	*,
	CASE
	WHEN 
		description ILIKE '%Kill%' OR
		description ILIKE '%Violence%' THEN 'Bad_content'
		ELSE 'Good_content'
	END category
FROM netflix
)

SELECT 
	category,
	COUNT(*) AS Table_content
FROM new_table
GROUP BY category


WHERE
	description ILIKE '%Kill%'
	OR
	description ILIKE '%Violence%'





