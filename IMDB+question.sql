USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*)
FROM director_mapping #No. of rows: 3876
UNION ALL
SELECT COUNT(*)
FROM genre   #No. of rows: 14662
UNION ALL
SELECT COUNT(*)
FROM movie   #No. of rows: 7997
UNION ALL
SELECT COUNT(*)
FROM names   #No. of rows: 25735
UNION ALL
SELECT COUNT(*)
FROM ratings   #No. of rows: 7997
UNION ALL
SELECT COUNT(*)
FROM role_mapping;  #No. of rows: 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
sum(CASE WHEN id IS NULL THEN 1 END) id_null,
sum(CASE WHEN title IS NULL THEN 1 END) title_null,
sum(CASE WHEN year IS NULL THEN 1 END) year_null,
sum(CASE WHEN date_published IS NULL THEN 1 END) date_published_null,
sum(CASE WHEN duration IS NULL THEN 1 END) duration_null,
sum(CASE WHEN country IS NULL THEN 1 END) country_null,
sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 END) worlwide_gross_income_null,
sum(CASE WHEN languages IS NULL THEN 1 END) languages_null,
sum(CASE WHEN production_company IS NULL THEN 1 END) production_company_null
from movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT year AS Year, COUNT(id) AS number_of_movies
FROM movie
GROUP BY year;

SELECT month(date_published) AS month_num, count(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT country AS country, count(id) AS number_of_movies
FROM movie
WHERE year = '2019' AND country IN ('USA','India')
GROUP BY country; 


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre 
FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

SELECT genre, count(id)
FROM genre g 
JOIN movie m
ON g.movie_id = m.id
WHERE m.year = '2019'
GROUP BY g.genre
ORDER BY count(id) DESC
LIMIT 1;   #Highest number of movies produced in year 2019 was in genre 'drama'

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, count(movie_id) AS movie_cnt
FROM genre
GROUP BY genre
ORDER BY movie_cnt DESC
LIMIT 1;

# 'Drama' Genre was the most preffered to produce movies overall


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT count(movie_id)
FROM (
SELECT movie_id, count(genre) AS genre_cnt
FROM genre
GROUP BY movie_id
HAVING genre_cnt = 1) AS one_genre;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre AS genre, AVG(m.duration) AS avg_duration
FROM genre g 
JOIN movie m
ON g.movie_id = m.id
GROUP BY genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre, count(movie_id) AS movie_count, 
RANK() OVER (ORDER BY count(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre;

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) AS min_avg_rating, MAX(avg_rating) AS max_avg_rating, MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes, MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating
FROM ratings;
    
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT m.title, r.avg_rating, 
RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie m
JOIN ratings r
ON m.id = r.movie_id
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, count(id) AS movie_count, 
DENSE_RANK() OVER (ORDER BY count(id) DESC) AS prod_company_rank
FROM movie m
JOIN ratings r
ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, count(r.movie_id) AS movie_count
FROM movie m
JOIN ratings r
ON m.id = r.movie_id
JOIN genre g
USING (movie_id)
WHERE MONTH(m.date_published) = 3 AND m.year = '2017' AND r.total_votes > 1000 AND m.country = 'USA'
GROUP BY g.genre
ORDER BY movie_count DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title, r.avg_rating, g.genre
FROM movie m
JOIN ratings r
ON m.id = r.movie_id
JOIN genre g
USING (movie_id) 
WHERE m.title REGEXP '^The' AND r.avg_rating > 8;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
SELECT m.title, r.median_rating, g.genre
FROM movie m
JOIN ratings r
ON m.id = r.movie_id
JOIN genre g
USING (movie_id) 
WHERE m.title REGEXP '^The' AND r.median_rating > 8;

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT title
FROM
(SELECT m.title, r.median_rating
FROM movie m
JOIN ratings r 
ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01') AS date_summ
WHERE median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH German AS (
SELECT sum(r.total_votes) AS german_votes
FROM movie m 
JOIN ratings r
ON m.id = r.movie_id
WHERE country = 'Germany'),
Italian AS (
SELECT sum(r.total_votes) AS italian_votes
FROM movie m
JOIN ratings r
ON m.id = r.movie_id
WHERE country = 'Italy')
SELECT 'Are german_votes more than Italian_votes' AS statement, 
CASE 
   WHEN german_votes > italian_votes THEN 'Yes'
   ELSE 'No'
END AS Result
FROM German, Italian;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
sum(CASE WHEN name IS NULL THEN 1 END) name_nulls,
sum(CASE WHEN height IS NULL THEN 1 END) height_nulls,
sum(CASE WHEN date_of_birth IS NULL THEN 1 END) date_of_birth_nulls,
sum(CASE WHEN known_for_movies IS NULL THEN 1 END) known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



SELECT n.name director_name, count(g.movie_id) movie_count 
FROM names n
JOIN director_mapping d
ON n.id = d.name_id
JOIN genre g
USING (movie_id)
JOIN ratings r 
USING (movie_id)
WHERE genre IN (
SELECT genre FROM (
SELECT g.genre, count(movie_id)
FROM genre g
JOIN ratings r
USING (movie_id)
WHERE r.avg_rating > 8
GROUP BY g.genre
ORDER BY count(movie_id) DESC
LIMIT 3) AS top3_gen)
AND r.avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;                      

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT n.name actor_name, count(r.movie_id) movie_count
FROM names n
JOIN role_mapping p
ON n.id = p.name_id
JOIN ratings r 
USING (movie_id)
WHERE r.median_rating >= 8 AND p.category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, sum(r.total_votes) vote_count, 
RANK() OVER(ORDER BY sum(r.total_votes) DESC) prod_comp_rank
FROM movie m
JOIN ratings r
ON m.id = r.movie_id
GROUP BY production_company;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name actor_name, r.total_votes total_votes, count(r.movie_id) movie_count, ROUND(sum(r.avg_rating*total_votes)/sum(total_votes),2)
actor_avg_rating, RANK() OVER(ORDER BY ROUND(sum(r.avg_rating*total_votes)/sum(total_votes),2) DESC, total_votes DESC) actor_rank
FROM names n
JOIN role_mapping p
ON n.id = p.name_id
JOIN ratings r
USING(movie_id)
JOIN movie m
ON r.movie_id = m.id
WHERE name IN (
SELECT name FROM (
SELECT n.name, count(m.id)
FROM names n
JOIN role_mapping p
ON n.id = p.name_id
JOIN movie m
ON m.id = p.movie_id
WHERE m.country = 'India' AND p.category = 'actor'
GROUP BY name
HAVING count(m.id) >= 5) actor_5ind)
AND m.country = 'India'
GROUP BY actor_name;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name actress_name, sum(r.total_votes) total_votes, count(r.movie_id) movie_count, 
ROUND(sum(r.avg_rating*total_votes)/sum(total_votes),2) actress_avg_rating, 
RANK() OVER(ORDER BY ROUND(sum(r.avg_rating*total_votes)/sum(total_votes),2) DESC, total_votes DESC) actress_rank
FROM names n 
JOIN role_mapping p
ON n.id = p.name_id
JOIN ratings r
USING(movie_id)
JOIN movie m
ON m.id = r.movie_id
WHERE p.category = 'actress' AND m.country = 'India' AND m.languages = 'Hindi'
GROUP BY actress_name
HAVING movie_count >= 3
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

# Method to classify movies
SELECT m.title, 
CASE 
    WHEN r.avg_rating >8 THEN 'Superhit movies'
    WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
    WHEN r.avg_rating BETWEEN 5 and 7 THEN 'One-time-watch movies'
    ELSE 'Flop movies'
END AS Category
FROM ratings r 
JOIN genre g 
USING (movie_id)
JOIN movie m
ON m.id = g.movie_id
WHERE g.genre = 'Thriller';

# Method to calculate numbers in every category
SELECT category, count(title) FROM (
SELECT m.title, 
CASE 
    WHEN r.avg_rating >8 THEN 'Superhit movies'
    WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
    WHEN r.avg_rating BETWEEN 5 and 7 THEN 'One-time-watch movies'
    ELSE 'Flop movies'
END AS Category
FROM ratings r 
JOIN genre g 
USING (movie_id)
JOIN movie m
ON m.id = g.movie_id
WHERE g.genre = 'Thriller') categ_tit
GROUP BY category;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

# Method1: Using Partition By for genre
SELECT g.genre, avg(m.duration) OVER (PARTITION BY genre) avg_duration, 
sum(m.duration) OVER (PARTITION BY genre) running_total_duration, 
avg(m.duration) OVER(PARTITION BY genre ORDER BY m.date_published ROWS UNBOUNDED PRECEDING) moving_avg_duration
FROM genre g
JOIN movie m
ON g.movie_id = m.id;

# Method2: Using group by for genre 
SELECT g.genre, ROUND(avg(m.duration),2) avg_duration, sum(m.duration) running_total_duration, 
avg(m.duration) OVER(ORDER BY m.date_published ROWS UNBOUNDED PRECEDING) moving_avg_duration
FROM genre g
JOIN movie m
ON g.movie_id = m.id
GROUP BY g.genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre AS (
SELECT genre, count(movie_id)
FROM genre
GROUP BY genre
ORDER BY count(movie_id) DESC
LIMIT 3),
sel_rank AS (
SELECT genre, m.year, m.title movie_name, m.worlwide_gross_income worldwide_gross_income,
RANK() OVER(PARTITION BY m.year ORDER BY m.worlwide_gross_income DESC) movie_rank
FROM genre g 
JOIN movie m 
ON g.movie_id = m.id 
WHERE genre IN (SELECT genre FROM top3_genre))
SELECT *
FROM sel_rank
WHERE movie_rank <=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT m.production_company, count(r.movie_id) movie_count, 
RANK() OVER(ORDER BY count(r.movie_id) DESC) prod_comp_rank
FROM movie m
JOIN ratings r
ON m.id = r.movie_id
WHERE r.median_rating >= 8 AND m.languages REGEXP "," AND m.production_company IS NOT NULL
GROUP BY production_company
LIMIT 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT n.name actress_name, r.total_votes, count(r.movie_id) movie_count, r.avg_rating actress_avg_rating, 
DENSE_RANK() OVER(ORDER BY count(r.movie_id) DESC) actress_rank
FROM names n 
JOIN role_mapping p 
ON n.id = p.name_id 
JOIN ratings r
USING(movie_id) 
JOIN genre g 
USING(movie_id)
WHERE p.category = 'actress' AND r.avg_rating > 8 AND g.genre = 'Drama' 
GROUP BY actress_name
LIMIT 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date AS
(
SELECT d.name_id, n.name, d.movie_id, m.date_published,
LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_mv_date
FROM names n 
JOIN director_mapping d
ON n.id = d.name_id
JOIN movie m 
ON m.id = d.movie_id 
),
diff_date AS (
SELECT *, DATEDIFF(next_mv_date, date_published) AS difference
FROM next_date),
avg_inter_duration AS (
SELECT name_id, avg(difference) AS avg_inter_movie_days
FROM diff_date
GROUP BY name_id)
SELECT d.name_id director_id, n.name director_name, count(d.movie_id) number_of_movies, ROUND(avg_inter_movie_days) avg_inter_movie_days,
ROUND(avg(r.avg_rating),2) avg_rating, sum(r.total_votes) total_votes, min(r.avg_rating) min_rating, max(r.avg_rating) max_rating, 
sum(m.duration) total_duration
FROM names n
JOIN director_mapping d
ON n.id = d.name_id
JOIN ratings r
USING(movie_id) 
JOIN movie m  
ON m.id = r.movie_id 
JOIN avg_inter_duration a 
ON a.name_id = d.name_id
GROUP BY director_id
ORDER BY number_of_movies DESC
LIMIT 9;




