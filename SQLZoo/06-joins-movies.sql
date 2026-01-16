-- Source: SQLZoo (hand-written)
-- Topic: JOINs on Movies (Beginner → Advanced)

-- Table structures:
-- movie(id, title, yr, budget, gross, director)
-- actor(id, name)
-- casting(movieid, actorid, ord)

--------------------------------------------------
-- LEVEL 1: BASIC SELECT (SINGLE TABLE)
--------------------------------------------------

-- Q1: Show the year of the movie 'Citizen Kane'
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- Q2: Show the id of the 1942 film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca'
  AND yr = 1942;

-- Q3: Show the id number of the actor 'Glenn Close'
SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- Q4: List all Star Trek movies (id, title, year), ordered by year
SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr;

--------------------------------------------------
-- LEVEL 2: BASIC JOIN (2 TABLES)
--------------------------------------------------

-- Q5: List directors of movies that made a financial loss (gross < budget)
SELECT name
FROM actor
INNER JOIN movie ON actor.id = director
WHERE gross < budget;

-- Q6: Show the cast list for the 1942 film 'Casablanca'
SELECT name
FROM casting
JOIN actor ON id = actorid
WHERE movieid = (
    SELECT id
    FROM movie
    WHERE title = 'Casablanca'
      AND yr = 1942
);

-- Q7: Show the cast list for the film 'Alien'
SELECT name
FROM casting
JOIN actor ON id = actorid
WHERE movieid = (
    SELECT id
    FROM movie
    WHERE title = 'Alien'
);

-- Q8: List the films in which Harrison Ford has appeared
SELECT title
FROM movie
JOIN casting ON id = movieid
WHERE actorid = 81328;

--------------------------------------------------
-- LEVEL 3: JOIN + FILTERING
--------------------------------------------------

-- Q9: List films where Harrison Ford appeared but not in the starring role
SELECT title
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford'
  AND casting.ord != 1;

-- Q10: Show films from 1962 with a budget over 2,000,000
SELECT id, title
FROM movie
WHERE yr = 1962
  AND budget > 2000000;

-- Q11: Show the leading actor for all films released in 1962
SELECT m.title, a.name
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor a ON c.actorid = a.id
WHERE m.yr = 1962
  AND c.ord = 1;

--------------------------------------------------
-- LEVEL 4: JOINING THREE TABLES
--------------------------------------------------

-- Q12: Show a correct example of joining actor, casting, and movie
SELECT *
FROM actor
JOIN casting ON actor.id = actorid
JOIN movie ON movie.id = movieid;

-- Q13: Show actors named 'John' ordered by the number of movies they acted in
SELECT name, COUNT(movieid)
FROM casting
JOIN actor ON actorid = actor.id
WHERE name LIKE 'John %'
GROUP BY name
ORDER BY 2 DESC;

-- Q14: Show the film title and year where Robert De Niro was the third billed actor
SELECT title, yr
FROM movie, casting, actor
WHERE name = 'Robert De Niro'
  AND movieid = movie.id
  AND actorid = actor.id
  AND ord = 3;

--------------------------------------------------
-- LEVEL 5: DIRECTORS, STARRING ROLES & SUBQUERIES
--------------------------------------------------

-- Q15: List all actors who starred in movies directed by Ridley Scott (id = 351)
SELECT name
FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actor.id = actorid
WHERE ord = 1
  AND director = 351;

-- Q16: Show the title of films starring Paul Hogan
SELECT title
FROM movie
JOIN casting ON movieid = movie.id
JOIN actor ON actorid = actor.id
WHERE name = 'Paul Hogan'
  AND ord = 1;

-- Q17: List the film title and leading actor for all films Julie Andrews played in
SELECT m.title, a.name
FROM movie m
JOIN casting c ON m.id = c.movieid AND c.ord = 1
JOIN actor a ON a.id = c.actorid
WHERE c.movieid IN (
    SELECT movieid
    FROM casting
    WHERE actorid IN (
        SELECT id
        FROM actor
        WHERE name = 'Julie Andrews'
    )
);

--------------------------------------------------
-- LEVEL 6: GROUP BY, HAVING & ADVANCED QUERIES
--------------------------------------------------

-- Q18: Show the busiest years for Rock Hudson
--      (years where he made more than 2 movies)
SELECT yr, COUNT(title)
FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- Q19: List actors who have had at least 15 starring roles
SELECT a.name
FROM actor a
JOIN casting c ON a.id = c.actorid AND c.ord = 1
GROUP BY name
HAVING COUNT(name) >= 15
ORDER BY name;

-- Q20: List films released in 1978 ordered by number of actors, then by title
SELECT title, COUNT(actorid)
FROM movie
JOIN casting ON movieid = id
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title;

--------------------------------------------------
-- LEVEL 7: SELF-REFERENCING & CO-ACTOR QUERIES
--------------------------------------------------

-- Q21: List all people who have worked with Art Garfunkel
SELECT DISTINCT a.name
FROM actor a
JOIN casting c ON a.id = c.actorid
WHERE a.name != 'Art Garfunkel'
  AND movieid IN (
      SELECT movieid
      FROM casting
      WHERE actorid IN (
          SELECT id
          FROM actor
          WHERE name = 'Art Garfunkel'
      )
  );
