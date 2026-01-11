-- Source: SQLZoo (hand-written)
-- Topic: SELECT (basic → advanced)
-- Table: world(name, continent, area, population, gdp, capital)

--------------------------------------------------
-- BASIC SELECT & WHERE
--------------------------------------------------

-- Q1: Show the population of Germany
SELECT population
FROM world
WHERE name = 'Germany';

-- Q2: Show the name and population of Sweden, Norway, and Denmark
SELECT name, population
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- Q3: Show the name, continent, and population of all countries
SELECT name, continent, population
FROM world;

-- Q4: Show the names of countries with a population of at least 200 million
SELECT name
FROM world
WHERE population >= 200000000;

-- Q5: Show the name and population of France, Germany, and Italy
SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');

-- Q6: Show the names of Cuba and Togo
SELECT name
FROM world
WHERE name IN ('Cuba', 'Togo');

-- Q7: Show the name and population of countries in Europe and Asia
SELECT name, population
FROM world
WHERE continent IN ('Europe', 'Asia');

-- Q8: Show countries in South America with population greater than 40 million
SELECT name
FROM world
WHERE continent = 'South America'
  AND population > 40000000;

--------------------------------------------------
-- FILTERING, IN, BETWEEN & PATTERNS
--------------------------------------------------

-- Q9: Show the names of countries beginning with 'U'
SELECT name
FROM world
WHERE name LIKE 'U%';

-- Q10: Show the population of the United Kingdom
SELECT population
FROM world
WHERE name = 'United Kingdom';

-- Q11: Show countries with area between 200,000 and 250,000 sq km
SELECT name, area
FROM world
WHERE area BETWEEN 200000 AND 250000;

-- Q12: Show countries with population between 1 million and 12.5 million
SELECT name, population
FROM world
WHERE population BETWEEN 1000000 AND 12500000;

-- Q13: Show countries whose name starts with 'Al'
SELECT name, population
FROM world
WHERE name LIKE 'Al%';

-- Q14: Show countries whose name ends with 'a' or 'l'
SELECT name
FROM world
WHERE name LIKE '%a'
   OR name LIKE '%l';

-- Q15: Show European countries with exactly 5-letter names
SELECT name, LENGTH(name)
FROM world
WHERE LENGTH(name) = 5
  AND continent = 'Europe';

-- Q16: Show countries that include the word 'United' in their name
SELECT name
FROM world
WHERE name LIKE '%United%';

--------------------------------------------------
-- STRING FUNCTIONS & COMPARISONS
--------------------------------------------------

-- Q17: Show the name and capital where both have the same number of characters
SELECT name, capital
FROM world
WHERE LENGTH(name) = LENGTH(capital);

-- Q18: Show the name and capital where the first letters match but are not the same word
SELECT name, capital
FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1)
  AND name <> capital;

-- Q19: Find the country name that contains all vowels and has no spaces
SELECT name
FROM world
WHERE name NOT LIKE '% %'
  AND name LIKE '%a%'
  AND name LIKE '%e%'
  AND name LIKE '%i%'
  AND name LIKE '%o%'
  AND name LIKE '%u%';

--------------------------------------------------
-- LOGICAL CONDITIONS (AND / OR / XOR)
--------------------------------------------------

-- Q20: Show countries that are large by area or population
SELECT name, population, area
FROM world
WHERE area > 3000000
   OR population > 250000000;

-- Q21: Show countries that are large by area or population, but not both
SELECT name, population, area
FROM world
WHERE area > 3000000
  XOR population > 250000000;

--------------------------------------------------
-- EXPRESSIONS & CALCULATIONS
--------------------------------------------------

-- Q22: Show country names and double their area where population is 64,000
SELECT name, area * 2
FROM world
WHERE population = 64000;

-- Q23: Show country names and one-tenth of their population for populations below 10,000
SELECT name, population / 10
FROM world
WHERE population < 10000;

-- Q24: Show countries with area greater than 50,000 and population less than 10 million
SELECT name, area, population
FROM world
WHERE area > 50000
  AND population < 10000000;

-- Q25: Show population density of China, Australia, Nigeria, and France
SELECT name, population / area AS population_density
FROM world
WHERE name IN ('China', 'Australia', 'Nigeria', 'France');

-- Q26: Show name and per-capita GDP for countries with population at least 200 million
SELECT name, gdp / population AS per_capita_gdp
FROM world
WHERE population >= 200000000;

-- Q27: Show name and population (in millions) for South American countries
SELECT name, population / 1000000 AS population_millions
FROM world
WHERE continent = 'South America';

-- Q28: Show name, population (millions), and GDP (billions) for South American countries
SELECT name,
       ROUND(population / 1000000, 2) AS population_millions,
       ROUND(gdp / 1000000000, 2) AS gdp_billions
FROM world
WHERE continent = 'South America';

-- Q29: Show name and per-capita GDP (rounded to nearest 1000) for countries with GDP ≥ 1 trillion
SELECT name,
       ROUND(gdp / population, -3) AS per_capita_gdp
FROM world
WHERE gdp >= 1000000000000;
