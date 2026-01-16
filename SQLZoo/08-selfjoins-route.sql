-- Source: SQLZoo (hand-written)
-- Topic: SELF JOIN
-- Tables:
-- stops(id, name)
-- route(num, company, pos, stop)

--------------------------------------------------
-- LEVEL 1: BASIC LOOKUPS
--------------------------------------------------

-- Q1: Show how many stops are in the database
SELECT COUNT(*)
FROM stops;

-- Q2: Find the id for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart';

--------------------------------------------------
-- LEVEL 2: BASIC JOIN (STOPS + ROUTE)
--------------------------------------------------

-- Q3: Give the id and name of the stops on the '4' 'LRT' service
SELECT s.id, s.name
FROM stops s
JOIN route r
  ON s.id = r.stop
WHERE r.num = 4
  AND r.company = 'LRT'
ORDER BY r.pos;

--------------------------------------------------
-- LEVEL 3: GROUP BY + HAVING
--------------------------------------------------

-- Q4: Show services that visit both London Road (149) and Craiglockhart (53)
SELECT company, num, COUNT(*)
FROM route
WHERE stop = 149 OR stop = 53
GROUP BY company, num
HAVING COUNT(*) = 2;

--------------------------------------------------
-- LEVEL 4: BASIC SELF JOIN (ROUTE)
--------------------------------------------------

-- Q5: Show services from Craiglockhart to London Road (by stop id)
SELECT a.company, a.num, a.stop, b.stop
FROM route a
JOIN route b
  ON a.company = b.company
 AND a.num = b.num
WHERE a.stop = 53
  AND b.stop = 149;

--------------------------------------------------
-- LEVEL 5: SELF JOIN + STOPS TABLE (USING NAMES)
--------------------------------------------------

-- Q6: Show services between 'Craiglockhart' and 'London Road'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a
JOIN route b
  ON a.company = b.company
 AND a.num = b.num
JOIN stops stopa
  ON a.stop = stopa.id
JOIN stops stopb
  ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart'
  AND stopb.name = 'London Road';

-- Q7: Give a list of services connecting 'Haymarket' and 'Leith'
SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b
  ON a.company = b.company
 AND a.num = b.num
WHERE a.stop = 115
  AND b.stop = 137;

-- Q8: Give a list of services connecting 'Craiglockhart' and 'Tollcross'
SELECT a.company, a.num
FROM route a
JOIN route b
  ON a.company = b.company
 AND a.num = b.num
JOIN stops stopa
  ON a.stop = stopa.id
JOIN stops stopb
  ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart'
  AND stopb.name = 'Tollcross';

--------------------------------------------------
-- LEVEL 6: REACHABILITY (ONE BUS)
--------------------------------------------------

-- Q9: List stops reachable from 'Craiglockhart' using one LRT bus
--     Include stop name, company and bus number
SELECT DISTINCT stops.name, a.company, a.num
FROM route a
JOIN route b
  ON a.company = b.company
 AND a.num = b.num
JOIN stops
  ON b.stop = stops.id
WHERE a.stop = 53
  AND a.company = 'LRT';

-- Q10: Show it is possible to get from 'Craiglockhart' to 'Haymarket'
SELECT DISTINCT a.name, b.name
FROM stops a
JOIN route z
  ON a.id = z.stop
JOIN route y
  ON y.num = z.num
JOIN stops b
  ON y.stop = b.id
WHERE a.name = 'Craiglockhart'
  AND b.name = 'Haymarket';

--------------------------------------------------
-- LEVEL 7: REACHABILITY (SPECIFIC SERVICE)
--------------------------------------------------

-- Q11: Show stops on route '2A' reachable from 'Haymarket'
SELECT S2.id, S2.name, R2.company, R2.num
FROM stops S1, stops S2, route R1, route R2
WHERE S1.name = 'Haymarket'
  AND S1.id = R1.stop
  AND R1.company = R2.company
  AND R1.num = R2.num
  AND R2.stop = S2.id
  AND R2.num = '2A';

--------------------------------------------------
-- LEVEL 8: REACHABILITY (TWO BUSES)
--------------------------------------------------

-- Q12: Find routes involving two buses from 'Craiglockhart' to 'Lochend'
--      Show first bus (num, company),
--      transfer stop,
--      second bus (num, company)
SELECT a.num, a.company, s.name, d.num, d.company
FROM route a
JOIN route b
  ON a.company = b.company
 AND a.num = b.num
JOIN stops s
  ON b.stop = s.id
JOIN route c
  ON b.stop = c.stop
JOIN route d
  ON c.num = d.num
 AND c.company = d.company
WHERE a.stop = (SELECT id FROM stops WHERE name = 'Craiglockhart')
  AND d.stop = (SELECT id FROM stops WHERE name = 'Lochend')
ORDER BY a.num, s.name, d.num;

--------------------------------------------------
-- LEVEL 9: SERVICES FROM A GIVEN STOP
--------------------------------------------------

-- Q13: Show all services available from 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a
JOIN route b
  ON a.company = b.company
 AND a.num = b.num
JOIN stops stopa
  ON a.stop = stopa.id
JOIN stops stopb
  ON b.stop = stopb.id
WHERE stopa.name = 'Tollcross';
