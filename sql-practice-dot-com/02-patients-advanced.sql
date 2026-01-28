-- Source: sql-practice.com (hand-written)
-- Topic: Advanced SQL (logic-heavy, interview-level)
-- Tables:
-- patients(patient_id, first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
-- admissions(admission_id, patient_id, admission_date, discharge_date, diagnosis, attending_doctor_id)
-- doctors(doctor_id, first_name, last_name, specialty)
-- province_names(province_id, province_name)

--------------------------------------------------
-- ADVANCED QUERIES
--------------------------------------------------

-- Q1: Show patient_id, attending_doctor_id, and diagnosis for admissions that match:
--     1) patient_id is odd AND doctor_id IN (1,5,19)
--     2) doctor_id contains '2' AND patient_id length is 3
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE
  (patient_id % 2 = 1 AND attending_doctor_id IN (1,5,19))
   OR
  (CAST(attending_doctor_id AS TEXT) LIKE '%2%'
   AND LENGTH(patient_id) = 3);

-- Q2: Show first name, last name, and total admissions attended by each doctor
SELECT
  d.first_name,
  d.last_name,
  COUNT(a.admission_id) AS total_admissions
FROM doctors d
JOIN admissions a
  ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id;

-- Q3: For each doctor, show id, full name, first and last admission date attended
SELECT
  d.doctor_id,
  d.first_name || ' ' || d.last_name AS doctor_name,
  MIN(a.admission_date) AS first_admission,
  MAX(a.admission_date) AS last_admission
FROM doctors d
JOIN admissions a
  ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id;

-- Q4: Display total number of patients per province (descending)
SELECT
  pr.province_name,
  COUNT(p.patient_id) AS total_patients
FROM patients p
JOIN province_names pr
  ON p.province_id = pr.province_id
GROUP BY pr.province_name
ORDER BY total_patients DESC;

-- Q5: For every admission, show patient full name, diagnosis, and doctor full name
SELECT
  p.first_name || ' ' || p.last_name AS patient_name,
  a.diagnosis,
  d.first_name || ' ' || d.last_name AS doctor_name
FROM admissions a
JOIN patients p
  ON a.patient_id = p.patient_id
JOIN doctors d
  ON a.attending_doctor_id = d.doctor_id;

-- Q6: Show duplicate patients based on first_name + last_name
SELECT
  first_name,
  last_name,
  COUNT(*) AS duplicate_count
FROM patients
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;

-- Q7: Show patient full name, height in feet (1 decimal),
--     weight in pounds (0 decimals), birth_date, full gender
SELECT
  first_name || ' ' || last_name AS full_name,
  ROUND(height / 30.48, 1) AS height_feet,
  ROUND(weight * 2.205, 0) AS weight_pounds,
  birth_date,
  CASE
    WHEN gender = 'M' THEN 'Male'
    ELSE 'Female'
  END AS gender
FROM patients;

-- Q8: Show patients who have no admissions
SELECT patient_id, first_name, last_name
FROM patients
WHERE patient_id NOT IN (
  SELECT DISTINCT patient_id FROM admissions
);

-- Q9: Show max, min, and average admissions per day
SELECT
  MAX(daily_count) AS max_visits,
  MIN(daily_count) AS min_visits,
  ROUND(AVG(daily_count), 2) AS average_visits
FROM (
  SELECT admission_date, COUNT(*) AS daily_count
  FROM admissions
  GROUP BY admission_date
);

--------------------------------------------------
-- VERY ADVANCED / PORTFOLIO-LEVEL
--------------------------------------------------

-- Q10: Show each patient with at least one admission and their most recent admission,
--      including patient and doctor names
SELECT
  p.first_name || ' ' || p.last_name AS patient_name,
  a.admission_date,
  a.diagnosis,
  d.first_name || ' ' || d.last_name AS doctor_name
FROM admissions a
JOIN patients p
  ON a.patient_id = p.patient_id
JOIN doctors d
  ON a.attending_doctor_id = d.doctor_id
WHERE a.admission_date = (
  SELECT MAX(admission_date)
  FROM admissions
  WHERE patient_id = a.patient_id
);

-- Q11: Group patients into weight buckets (100–109 → 100 group)
SELECT
  (weight / 10) * 10 AS weight_group,
  COUNT(*) AS total_patients
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

-- Q12: Show patient_id, weight, height, and obesity flag (BMI ≥ 30)
SELECT
  patient_id,
  weight,
  height,
  CASE
    WHEN weight / POWER(height / 100.0, 2) >= 30 THEN 1
    ELSE 0
  END AS isObese
FROM patients;

-- Q13: Show patients diagnosed with Dementia whose doctor's first name is 'Lisa'
SELECT
  p.patient_id,
  p.first_name,
  p.last_name,
  d.specialty
FROM patients p
JOIN admissions a
  ON p.patient_id = a.patient_id
JOIN doctors d
  ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Dementia'
  AND d.first_name = 'Lisa';

-- Q14: Generate temporary password after first admission
--      Format: patient_id + length(last_name) + birth year
SELECT DISTINCT
  p.patient_id,
  p.patient_id || LENGTH(p.last_name) || YEAR(p.birth_date) AS temp_password
FROM patients p
JOIN admissions a
  ON p.patient_id = a.patient_id;

-- Q15: Insurance status and total admission cost per group
--      Even patient_id → insured ($10), Odd → uninsured ($50)
SELECT
  CASE
    WHEN patient_id % 2 = 0 THEN 'Yes'
    ELSE 'No'
  END AS has_insurance,
  SUM(
    CASE
      WHEN patient_id % 2 = 0 THEN 10
      ELSE 50
    END
  ) AS total_cost
FROM admissions
GROUP BY has_insurance;

-- Q16: Show provinces with more male patients than female patients
SELECT pr.province_name
FROM patients p
JOIN province_names pr
  ON p.province_id = pr.province_id
GROUP BY pr.province_name
HAVING
  SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) >
  SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END);

-- Q17: Find a patient matching complex criteria
SELECT *
FROM patients
WHERE
  first_name LIKE '__%r%'
  AND gender = 'F'
  AND MONTH(birth_date) IN (2,5,12)
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 = 1
  AND city = 'Kingston';

-- Q18: Show percent of male patients (rounded, percent format)
SELECT
  ROUND(
    (SUM(CASE WHEN gender='M' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
    2
  ) || '%' AS male_percentage
FROM patients;

-- Q19: For each day show total admissions and change from previous day
SELECT
  admission_date,
  COUNT(*) AS total_admissions,
  COUNT(*) -
    LAG(COUNT(*)) OVER (ORDER BY admission_date) AS change_from_previous_day
FROM admissions
GROUP BY admission_date;

-- Q20: Sort provinces alphabetically but keep Ontario on top
SELECT province_name
FROM province_names
ORDER BY
  CASE WHEN province_name = 'Ontario' THEN 0 ELSE 1 END,
  province_name;

-- Q21: Yearly admissions per doctor
SELECT
  d.doctor_id,
  d.first_name || ' ' || d.last_name AS doctor_name,
  d.specialty,
  YEAR(a.admission_date) AS year,
  COUNT(*) AS total_admissions
FROM doctors d
JOIN admissions a
  ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id, year;
