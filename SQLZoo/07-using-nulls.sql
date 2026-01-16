-- Source: SQLZoo (hand-written)
-- Topic: NULL handling, OUTER JOIN, COALESCE, CASE
-- Tables:
-- teacher(id, name, dept, phone, mobile)
-- dept(id, name)

--------------------------------------------------
-- LEVEL 1: BASIC NULL CHECKS
--------------------------------------------------

-- Q1: List teachers who have no department assigned
SELECT name
FROM teacher
WHERE dept IS NULL;

--------------------------------------------------
-- LEVEL 2: INNER vs OUTER JOIN
--------------------------------------------------

-- Q2: Show teacher names and department names using an INNER JOIN
--      (teachers without department are excluded)
SELECT teacher.name, dept.name
FROM teacher
INNER JOIN dept
  ON teacher.dept = dept.id;

-- Q3: Show all teachers and their departments (include teachers with no department)
SELECT t.name, d.name
FROM teacher t
LEFT JOIN dept d
  ON t.dept = d.id;

-- Q4: Show all departments and their teachers (include departments with no teachers)
SELECT t.name, d.name
FROM teacher t
RIGHT JOIN dept d
  ON t.dept = d.id;

-- Q5: Select code that correctly uses an OUTER JOIN
SELECT teacher.name, dept.name
FROM teacher
LEFT OUTER JOIN dept
  ON teacher.dept = dept.id;

--------------------------------------------------
-- LEVEL 3: JOIN + AGGREGATION
--------------------------------------------------

-- Q6: Show all departments and the number of employed teachers
SELECT dept.name, COUNT(teacher.name)
FROM teacher
RIGHT JOIN dept
  ON dept.id = teacher.dept
GROUP BY dept.name;

-- Q7: Show each department and the number of staff
--     Ensure departments with zero teachers are listed
SELECT d.name, COUNT(t.name)
FROM teacher t
RIGHT JOIN dept d
  ON t.dept = d.id
GROUP BY d.name;

--------------------------------------------------
-- LEVEL 4: COALESCE (HANDLING NULL VALUES)
--------------------------------------------------

-- Q8: Show teacher name and department name
--     Use 'None' where there is no department
SELECT t.name,
       COALESCE(d.name, 'None') AS department_name
FROM teacher t
LEFT JOIN dept d
  ON t.dept = d.id;

-- Q9: Show teacher name and mobile number
--     Use '07986 444 2266' if no mobile number is given
SELECT name,
       COALESCE(mobile, '07986 444 2266')
FROM teacher;

-- Q10: Explain result of using COALESCE on dept column
--      Displays 0 for teachers without a department
SELECT name, dept, COALESCE(dept, 0) AS result
FROM teacher;

--------------------------------------------------
-- LEVEL 5: COUNT WITH NULL VALUES
--------------------------------------------------

-- Q11: Show the total number of teachers and the number of mobile phones
SELECT COUNT(name), COUNT(mobile)
FROM teacher;

--------------------------------------------------
-- LEVEL 6: CASE EXPRESSIONS
--------------------------------------------------

-- Q12: Show teacher name and label department as 'Computing' or 'Other'
SELECT name,
       CASE
         WHEN dept IN (1) THEN 'Computing'
         ELSE 'Other'
       END
FROM teacher;

-- Q13: Show teacher name and label department as 'Sci' or 'Art'
SELECT name,
       CASE
         WHEN dept = 1 THEN 'Sci'
         WHEN dept = 2 THEN 'Sci'
         ELSE 'Art'
       END AS dept
FROM teacher;

-- Q14: Show teacher name and label department as:
--      'Sci' for dept 1 or 2,
--      'Art' for dept 3,
--      'None' otherwise
SELECT name,
       CASE
         WHEN dept = 1 THEN 'Sci'
         WHEN dept = 2 THEN 'Sci'
         WHEN dept = 3 THEN 'Art'
         ELSE 'None'
       END AS dept
FROM teacher;

--------------------------------------------------
-- LEVEL 7: CASE WITH VALUE MAPPING
--------------------------------------------------

-- Q15: Map phone numbers to words using CASE
--      (example: phone 2754 maps to 'four')
SELECT name,
       CASE
         WHEN phone = 2752 THEN 'two'
         WHEN phone = 2753 THEN 'three'
         WHEN phone = 2754 THEN 'four'
       END AS digit
FROM teacher;

--------------------------------------------------
-- LEVEL 8: SIMPLE JOIN FILTERING
--------------------------------------------------

-- Q16: Show the name of the department that employs 'Cutflower'
SELECT dept.name
FROM teacher
JOIN dept
  ON dept.id = teacher.dept
WHERE teacher.name = 'Cutflower';
