-- Source: SQLZoo (hand-written)
-- Topic: JOINs (Beginner → Advanced)

-- Table structures:
-- game(id, mdate, stadium, team1, team2)
-- goal(matchid, teamid, player, gtime)
-- eteam(id, teamname, coach)

--------------------------------------------------
-- LEVEL 1: BASIC JOIN (2 TABLES)
--------------------------------------------------

-- Q1: Show the stadium where Dimitris Salpingidis scored
SELECT stadium
FROM game
JOIN goal ON id = matchid
WHERE player = 'Dimitris Salpingidis';

-- Q2: Show the matchid and player name for all goals scored by Germany
SELECT matchid, player
FROM goal
WHERE teamid = 'GER';

-- Q3: Show id, stadium, team1, team2 for game 1012
SELECT id, stadium, team1, team2
FROM game
WHERE id = 1012;

-- Q4: Show the player, teamid, stadium, and match date for every German goal
SELECT g2.player, g2.teamid, g1.stadium, g1.mdate
FROM game g1
JOIN goal g2 ON g1.id = g2.matchid
WHERE g2.teamid = 'GER';

--------------------------------------------------
-- LEVEL 2: JOIN WITH FILTERING CONDITIONS
--------------------------------------------------

-- Q5: Show players and their teams who scored against Greece (GRE),
--     along with the number of goals scored
SELECT player, teamid, COUNT(*)
FROM game
JOIN goal ON matchid = id
WHERE (team1 = 'GRE' OR team2 = 'GRE')
  AND teamid != 'GRE'
GROUP BY player, teamid;

-- Q6: Show players and their teams who scored against Poland (POL)
--     in National Stadium, Warsaw
SELECT DISTINCT player, teamid
FROM game
JOIN goal ON matchid = id
WHERE stadium = 'National Stadium, Warsaw'
  AND (team1 = 'POL' OR team2 = 'POL')
  AND teamid != 'POL';

-- Q7: Show the player, teamid, and goal time for goals scored
--     in Stadion Miejski (Wroclaw) but not against Italy (ITA)
SELECT DISTINCT player, teamid, gtime
FROM game
JOIN goal ON matchid = id
WHERE stadium = 'Stadion Miejski (Wroclaw)'
  AND (
       (teamid = team2 AND team1 != 'ITA')
    OR (teamid = team1 AND team2 != 'ITA')
  );

--------------------------------------------------
-- LEVEL 3: DISTINCT, DATE & STRING FILTERING
--------------------------------------------------

-- Q8: Show the teams and match dates for goals scored on 9 June 2012
SELECT DISTINCT teamid, mdate
FROM goal
JOIN game ON matchid = id
WHERE mdate = '9 June 2012';

-- Q9: Show team1, team2, and player for goals scored by players
--     whose name starts with 'Mario'
SELECT g1.team1, g1.team2, g2.player
FROM game g1
JOIN goal g2 ON g1.id = g2.matchid
WHERE g2.player LIKE 'Mario%';

-- Q10: Show the player name for every goal scored
--      in National Stadium, Warsaw
SELECT g1.player
FROM goal g1
JOIN game g2 ON g2.id = g1.matchid
WHERE g2.stadium = 'National Stadium, Warsaw';

--------------------------------------------------
-- LEVEL 4: JOIN WITH TEAM DETAILS (3 TABLES)
--------------------------------------------------

-- Q11: Show player, teamid, coach, and goal time
--      for all goals scored in the first 10 minutes
SELECT g.player, g.teamid, e.coach, g.gtime
FROM goal g
JOIN eteam e ON g.teamid = e.id
WHERE g.gtime <= 10;

-- Q12: List the dates of matches and team names
--      where Fernando Santos was the team1 coach
SELECT g.mdate, e.teamname
FROM game g
JOIN eteam e ON g.team1 = e.id
WHERE e.coach = 'Fernando Santos';

--------------------------------------------------
-- LEVEL 5: JOIN + AGGREGATION
--------------------------------------------------

-- Q13: Show team names and the total number of goals scored by each team
SELECT e.teamname, COUNT(g.gtime) AS total_goals
FROM eteam e
JOIN goal g ON e.id = g.teamid
GROUP BY e.teamname;

-- Q14: Show stadiums and the number of goals scored in each stadium
SELECT g1.stadium, COUNT(g2.gtime) AS goal_count
FROM game g1
JOIN goal g2 ON g1.id = g2.matchid
GROUP BY g1.stadium;

-- Q15: Show matchid, date, and number of goals
--      for every match involving Poland (POL)
SELECT goal.matchid, game.mdate, COUNT(goal.gtime)
FROM game
JOIN goal ON goal.matchid = game.id
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY goal.matchid, game.mdate;

-- Q16: For every match where Germany scored,
--      show matchid, date, and number of goals scored by Germany
SELECT goal.matchid, game.mdate, COUNT(goal.gtime) AS germany_goals
FROM game
JOIN goal ON game.id = goal.matchid
WHERE (game.team1 = 'GER' OR game.team2 = 'GER')
  AND goal.teamid = 'GER'
GROUP BY goal.matchid, game.mdate;

--------------------------------------------------
-- LEVEL 6: CONDITIONAL AGGREGATION (ADVANCED)
--------------------------------------------------

-- Q17: Show every match with goals scored by each team
--      ordered by date, matchid, team1, and team2
SELECT mdate,
       team1,
       SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2,
       SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2
FROM game
LEFT JOIN goal ON matchid = id
GROUP BY mdate, matchid, team1, team2
ORDER BY mdate, matchid, team1, team2;

--------------------------------------------------
-- LEVEL 7: HAVING WITH JOIN
--------------------------------------------------

-- Q18: Show teams that scored fewer than 3 goals in total
SELECT teamname, COUNT(*)
FROM eteam
JOIN goal ON teamid = id
GROUP BY teamname
HAVING COUNT(*) < 3;
