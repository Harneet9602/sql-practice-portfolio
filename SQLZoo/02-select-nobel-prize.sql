-- Source: SQLZoo (hand-written)
-- Topic: SELECT (basic → advanced)
-- Table: nobel(yr, subject, winner)

-- BASIC SELECT & WHERE

-- Q1: Show Nobel prizes awarded in 1950
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1950;

-- Q2: Show the winner of the 1962 Literature prize
SELECT winner
FROM nobel
WHERE yr = 1962
  AND subject = 'literature';

-- Q3: Show the year and subject of Albert Einstein's Nobel Prize
SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein';

-- Q4: Show Peace Prize winners since the year 2000 (inclusive)
SELECT winner
FROM nobel
WHERE subject = 'peace'
  AND yr >= 2000;

-- Q5: Show Literature prize winners from 1980 to 1989 (inclusive)
SELECT yr, subject, winner
FROM nobel
WHERE subject = 'literature'
  AND yr BETWEEN 1980 AND 1989;

-- IN, NOT IN & MULTI-VALUE FILTERING

-- Q6: Show Nobel Prize details for selected presidents
SELECT yr, subject, winner
FROM nobel
WHERE winner IN (
  'Theodore Roosevelt',
  'Thomas Woodrow Wilson',
  'Jimmy Carter',
  'Barack Obama'
);

-- Q7: Show winners whose first name is John
SELECT winner
FROM nobel
WHERE winner LIKE 'John%';

-- Q8: Show 1980 Physics winners and 1984 Chemistry winners
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1980 AND subject = 'physics'
UNION
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1984 AND subject = 'chemistry';

-- Q9: Show 1980 winners excluding Chemistry and Medicine
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1980
  AND subject NOT IN ('chemistry', 'medicine');

--------------------------------------------------
-- UNION & COMBINED CONDITIONS
--------------------------------------------------

-- Q10: Show early Medicine winners (before 1910)
--       together with late Literature winners (from 2004 onwards)
SELECT yr, subject, winner
FROM nobel
WHERE subject = 'Medicine'
  AND yr < 1910
UNION
SELECT yr, subject, winner
FROM nobel
WHERE subject = 'Literature'
  AND yr >= 2004;

--------------------------------------------------
-- STRING MATCHING & SPECIAL CHARACTERS
--------------------------------------------------

-- Q11: Show details of the prize won by Peter Grünberg
SELECT yr, subject, winner
FROM nobel
WHERE winner = 'PETER GRÜNBERG';

-- Q12: Show details of the prize won by Eugene O'Neill
SELECT yr, subject, winner
FROM nobel
WHERE winner = "EUGENE O'NEILL";

-- Q13: Show winners whose names begin with 'C' and end with 'n'
SELECT winner
FROM nobel
WHERE winner LIKE 'C%'
  AND winner LIKE '%n';

--------------------------------------------------
-- ORDERING & SORTING
--------------------------------------------------

-- Q14: Show winners whose names start with 'Sir',
--       ordered by most recent year first, then by name
SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner;

-- Q15: Show 1984 winners, listing Chemistry and Physics last
SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY subject IN ('physics', 'chemistry'), subject, winner;

--------------------------------------------------
-- AGGREGATION & COUNT
--------------------------------------------------

-- Q16: Count the number of Chemistry awards between 1950 and 1960
SELECT COUNT(subject) AS chemistry_awards
FROM nobel
WHERE subject = 'Chemistry'
  AND yr BETWEEN 1950 AND 1960;

-- Q17: Count the number of years in which no Medicine award was given
SELECT COUNT(DISTINCT yr) AS years_without_medicine
FROM nobel
WHERE yr NOT IN (
  SELECT DISTINCT yr
  FROM nobel
  WHERE subject = 'Medicine'
);

--------------------------------------------------
-- SUBQUERIES & SET EXCLUSIONS
--------------------------------------------------

-- Q18: Show years when neither a Physics nor Chemistry prize was awarded
SELECT yr
FROM nobel
WHERE yr NOT IN (
  SELECT yr
  FROM nobel
  WHERE subject IN ('Chemistry', 'Physics')
);

-- Q19: Show years when Medicine was awarded,
--       but neither Peace nor Literature was awarded
SELECT DISTINCT yr
FROM nobel
WHERE subject = 'Medicine'
  AND yr NOT IN (
    SELECT yr FROM nobel WHERE subject = 'Peace'
  )
  AND yr NOT IN (
    SELECT yr FROM nobel WHERE subject = 'Literature'
  );

--------------------------------------------------
-- GROUP BY & SUMMARY
--------------------------------------------------

-- Q20: Show the number of Nobel Prizes awarded per subject in 1960
SELECT subject, COUNT(subject) AS prize_count
FROM nobel
WHERE yr = 1960
GROUP BY subject;
