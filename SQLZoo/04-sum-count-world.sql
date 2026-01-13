-- Source: SQLZoo (hand-written)
-- Topic: SUM, COUNT, AVG, GROUP BY, HAVING
-- Tables: world, bbc

--------------------------------------------------
-- LEVEL 1: BASIC AGGREGATE FUNCTIONS
--------------------------------------------------

-- Q1: Show the total population of the world
SELECT SUM(population)
FROM world;

-- Q2: List all continents (no duplicates)
SELECT DISTINCT continent
FROM world;

-- Q3: Show the total GDP of Africa
SELECT SUM(gdp)
FROM world
WHERE continent = 'Africa';

-- Q4: Show how many countries have an area of at least 1,000,000
SELECT COUNT(name)
FROM world
WHERE area >= 1000000;

-- Q5: Show the total population of Estonia, Latvia, and Lithuania
SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

--------------------------------------------------
-- LEVEL 2: GROUP BY WITH COUNT & SUM
--------------------------------------------------

-- Q6: For each continent, show the continent and number of countries
SELECT continent, COUNT(DISTINCT name) AS country_count
FROM world
GROUP BY continent;

-- Q7: For each continent, show the number of countries
--     with population of at least 10 million
SELECT continent, COUNT(name) AS country_count
FROM world
WHERE population >= 10000000
GROUP BY continent;

-- Q8: List continents with a total population of at least 100 million
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;

--------------------------------------------------
-- LEVEL 3: AGGREGATES ON BBC TABLE
--------------------------------------------------

-- Q9: Show the total population of all countries in Europe
SELECT SUM(population)
FROM bbc
WHERE region = 'Europe';

-- Q10: Show the number of countries with population smaller than 150,000
SELECT COUNT(name)
FROM bbc
WHERE population < 150000;

--------------------------------------------------
-- LEVEL 4: AVG AND DERIVED METRICS
--------------------------------------------------

-- Q11: Show the average population of Poland, Germany, and Denmark
SELECT AVG(population)
FROM bbc
WHERE name IN ('Poland', 'Germany', 'Denmark');

-- Q12: Show the population density of each region
SELECT region,
       SUM(population) / SUM(area) AS density
FROM bbc
GROUP BY region;

-- Q13: Show the country with the largest population
--      and its population density
SELECT name,
       population / area AS density
FROM bbc
WHERE population = (
      SELECT MAX(population)
      FROM bbc
);

--------------------------------------------------
-- LEVEL 5: HAVING vs WHERE (ADVANCED AGGREGATION)
--------------------------------------------------

-- Q14: Show regions where the total area is less than or equal to 20,000,000
SELECT region, SUM(area)
FROM bbc
GROUP BY region
HAVING SUM(area) <= 20000000;

--------------------------------------------------
-- NOTES
--------------------------------------------------

-- Core SQL aggregate functions:
-- AVG(), COUNT(), MAX(), MIN(), SUM()

-- NOTE:
-- Aggregate functions cannot be used in WHERE.
-- Conditions on aggregates must be written using HAVING.
