---Netflix Project
DROP TABLE if exists netflix;
Create Table netflix
(show_id Varchar(6),
type	Varchar(10),
title	Varchar(150),
director Varchar(208),
casts	Varchar(1000),
country	Varchar(150),
date_added	Varchar(50),
release_year INT,	
rating	Varchar(10),
duration	Varchar(15),
listed_in	Varchar(100),
description Varchar(250)
);

Select * from netflix;

Select 
 Count(*) as total_content
from netflix;


Select 
 Distinct type
from netflix;

--15 business problems
---1. Count the number of Movies vs TV Shows

Select * from netflix;

Select
type,
count (*) as total_content
from netflix
group by type


---2. Find the most common rating for movies and TV shows


SELECT 
type,
rating
from
 
(
Select 
type,
rating,
Count(*),
RANK()Over(PARTITION BY type ORDER BY Count(*)DESC) as ranking
from netflix
group by 1,2
) as t1
where 
ranking = 1

---3. List all movies released in a specific year (e.g., 2020) 

---filter 2020
---movies
Select * from netflix
where 
type = 'Movie' 
and 
release_year = 2020


---4. Find the top 5 countries with the most content on Netflix
--groupbycountries

Select
UNNest(String_to_array(country,',')) as new_country,
Count(show_id) as total_content
from netflix
Group by 1 
Order by 2 DESC
LIMIT 5


---5. Identify the longest movie or TV show duration

Select * from netflix
where 
type = 'Movie'
and
duration = (Select max(duration)from netflix)


---6. Find content added in the last 5 years

SELECT
*
from netflix
where
TO_DATE(date_added,'month DD,YYYY') >= current_date - interval '5 years'





---7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
where director LIKE '%Rajiv Chilaka%'

---8. List all TV shows with more than 5 seasons

Select 
*
from netflix
where 
type = 'TV Show'
and
SPLIT_PART(duration,' ',1)::numeric > 5



---9. Count the number of content items in each genre

Select * from netflix

Select
UNNest(String_to_array(listed_in,',')) as genre,
Count(show_id)
from netflix
Group by 1

---10. Find each year and the average numbers of content release by India on netflix 
--return top 5 year with highest avg content release

---total content/972

Select 
EXTRACT (Year FROM TO_DATE(date_added,'Month,DD,YYYY')) as year,
Count (*) as yearly_content,
Round(
Count(*)::numeric /(Select count(*) from netflix where country = 'India')* 100,2)
as avg_content_per_year
from netflix
where country ='India'
Group by 1


---11. List all movies that are documentaries
Select * from netflix
WHERE
listed_in ILIKE '%documentaries%'



---12. Find all content without a director
Select * from netflix
where 
director IS NULL


---13.Find how many movies actor 'Salman Khan' appeared in läst 10 years

Select * from netflix
WHERE 
casts ILIKE '%Salman Khan%'
and release_year > EXTRACT(Year from CURRENT_DATE)-10 



---14.Find the top actors who have appeared in the highest number of movies produced in india


SELECT 
UNNEST(String_to_array(casts,',')) as actors,
Count(*) as total_content
from netflix
where country ILIKE '%India%'
GROUP by 1
ORDER by 2 DESC
LIMIT 10

---15.Categorize the content based on the presence of the keywords 'kill' and 'violence'
--in the description field. Label content containing these keywords as 'Bad' 
--and all other content as 'Good'. Count how many items fall into each category.

WITH new_table 
as
(
Select 
*,
CASE
WHEN  description ILIKE '%Kill%' 
OR
description ILIKE  '%violence%' Then 'Bad_Content'
else 'Good_Content'
END category
from netflix
)
Select category,
COUNT (*) as total_content
FROM new_table
group by 1












