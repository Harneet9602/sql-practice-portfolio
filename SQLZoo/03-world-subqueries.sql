-- Source: SQLZoo (hand-written)
-- Topic: Subqueries (Beginner → Advanced)
-- Tables: world, bbc

--------------------------------------------------
-- LEVEL 1: SIMPLE SUBQUERIES (SINGLE VALUE)
--------------------------------------------------

-- Q1: List each country where the population is larger than that of Russia
SELECT name
FROM world
WHERE population >
      (SELECT population
       FROM world
       WHERE name = 'Russia');

-- Q2: Show countries with population smaller than Russia but larger than Denmark
SELECT name
FROM bbc
WHERE population <
      (SELECT population FROM bbc WHERE name = 'Russia')
  AND population >
      (SELECT population FROM bbc WHERE name = 'Denmark');

-- Q3: Which country has a population more than the United Kingdom
--     but less than Germany?
SELECT name, population
FROM world
WHERE population >
      (SELECT population FROM world WHERE name = 'United Kingdom')
  AND population <
      (SELECT population FROM world WHERE name = 'Germany');

--------------------------------------------------
-- LEVEL 2: SUBQUERIES WITH CONDITIONS & FILTERS
--------------------------------------------------

-- Q4: Show countries in the same region as the United Kingdom
--     with a population greater than the United Kingdom
SELECT name
FROM bbc
WHERE population >
      (SELECT population
       FROM bbc
       WHERE name = 'United Kingdom')
  AND region IN (
      SELECT region
      FROM bbc
      WHERE name = 'United Kingdom'
  );

-- Q5: Show European countries with per-capita GDP greater than the United Kingdom
SELECT name
FROM world
WHERE continent = 'Europe'
  AND gdp / population >
      (SELECT gdp / population
       FROM world
       WHERE name = 'United Kingdom');

-- Q6: Show the name and continent of countries in continents
--     containing either Argentina or Australia
SELECT name, continent
FROM world
WHERE continent IN (
      SELECT continent
      FROM world
      WHERE name IN ('Argentina', 'Australia')
)
ORDER BY name;

--------------------------------------------------
-- LEVEL 3: CALCULATIONS WITH SUBQUERIES
--------------------------------------------------

-- Q7: Show European countries and their population
--     as a percentage of Germany's population
SELECT name,
       CONCAT(
           ROUND(
               population * 100 /
               (SELECT population FROM world WHERE name = 'Germany')
           ),
           '%'
       ) AS percentage
FROM world
WHERE continent = 'Europe';

-- Q8: Show countries with GDP greater than any country in Africa
SELECT name
FROM bbc
WHERE gdp >
      (SELECT MAX(gdp)
       FROM bbc
       WHERE region = 'Africa');

--------------------------------------------------
-- LEVEL 4: ALL / MAX SUBQUERIES
--------------------------------------------------

-- Q9: Show South Asian countries whose population
--     is greater than every European country
SELECT name
FROM bbc
WHERE population > ALL (
      SELECT MAX(population)
      FROM bbc
      WHERE region = 'Europe'
)
AND region = 'South Asia';

-- Q10: Show countries with GDP greater than every country in Europe
SELECT name
FROM world
WHERE gdp > ALL (
      SELECT gdp
      FROM world
      WHERE gdp > 0
        AND continent = 'Europe'
);

--------------------------------------------------
-- LEVEL 5: CORRELATED SUBQUERIES (PER GROUP)
--------------------------------------------------

-- Q11: Show the smallest country (by population) in each region
SELECT region, name, population
FROM bbc x
WHERE population <= ALL (
    SELECT population
    FROM bbc y
    WHERE y.region = x.region
      AND population > 0
);

-- Q12: Show countries belonging to regions
--      where all countries have population over 50,000
SELECT name, region, population
FROM bbc x
WHERE 50000 < ALL (
    SELECT population
    FROM bbc y
    WHERE y.region = x.region
      AND y.population > 0
);

-- Q13: Show countries with less than one-third of the population
--      of every other country in the same region
SELECT name, region
FROM bbc x
WHERE population < ALL (
    SELECT population / 3
    FROM bbc y
    WHERE y.region = x.region
      AND y.name <> x.name
);

--------------------------------------------------
-- LEVEL 6: EXISTS & ADVANCED SET LOGIC
--------------------------------------------------

-- Q14: Show the largest country (by area) in each continent
SELECT continent, name, area
FROM world x
WHERE area >= ALL (
      SELECT area
      FROM world y
      WHERE y.continent = x.continent
        AND area > 0
);

-- Q15: List each continent and the country
--      that comes first alphabetically
SELECT continent, name
FROM world x
WHERE name <= ALL (
      SELECT name
      FROM world y
      WHERE y.continent = x.continent
);

-- Q16: Find continents where all countries
--      have population ≤ 25 million,
--      and list the countries in those continents
SELECT name, continent, population
FROM world x
WHERE NOT EXISTS (
      SELECT *
      FROM world y
      WHERE y.continent = x.continent
        AND population > 25000000
);

-- Q17: Show countries whose population is more than
--      three times that of every other country
--      in the same continent
SELECT name, continent
FROM world x
WHERE population > ALL (
      SELECT population * 3
      FROM world y
      WHERE y.continent = x.continent
        AND y.name <> x.name
);
