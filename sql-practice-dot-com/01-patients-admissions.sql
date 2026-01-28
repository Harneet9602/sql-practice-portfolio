-- Source: sql-practice.com (hand-written)
-- Topic: Patients, Admissions, Doctors
-- Difficulty: Easy → Medium → Hard

-- Tables:
-- patients(patient_id, first_name, last_name, gender, birth_date, city, province_id, allergies, height, weight)
-- admissions(admission_id, patient_id, admission_date, discharge_date, diagnosis, attending_doctor_id)
-- doctors(doctor_id, first_name, last_name, specialty)
-- province_names(province_id, province_name)

--------------------------------------------------
-- EASY
--------------------------------------------------

-- Q1: Show first name, last name, and gender of male patients
SELECT first_name, last_name, gender
FROM patients
WHERE gender = 'M';

-- Q2: Show patients who do not have allergies
SELECT first_name, last_name
FROM patients
WHERE allergies IS NULL;

-- Q3: Show first names starting with 'C'
SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';

-- Q4: Show patients weighing between 100 and 120
SELECT first_name, last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;

-- Q5: Replace NULL allergies with 'NKA'
UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;

-- Q6: Show full name in a single column
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;

-- Q7: Show patient name and full province name
SELECT p.first_name, p.last_name, pr.province_name
FROM patients p
JOIN province_names pr
  ON p.province_id = pr.province_id;

-- Q8: Count patients born in 2010
SELECT COUNT(*)
FROM patients
WHERE YEAR(birth_date) = 2010;

-- Q9: Show tallest patient
SELECT first_name, last_name, MAX(height)
FROM patients;

-- Q10: Show patients with specific patient_ids
SELECT *
FROM patients
WHERE patient_id IN (1,45,534,879,1000);

-- Q11: Show total number of admissions
SELECT COUNT(*)
FROM admissions;

-- Q12: Admissions where admission and discharge date are the same
SELECT *
FROM admissions
WHERE admission_date = discharge_date;

-- Q13: Total admissions for patient_id 579
SELECT patient_id, COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;

-- Q14: Unique cities in province 'NS'
SELECT DISTINCT city
FROM patients
WHERE province_id = 'NS';

-- Q15: Patients with height > 160 and weight > 70
SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160
  AND weight > 70;

--------------------------------------------------
-- MEDIUM
--------------------------------------------------

-- Q16: Patients from Hamilton with non-null allergies
SELECT first_name, last_name, allergies
FROM patients
WHERE allergies IS NOT NULL
  AND city = 'Hamilton';

-- Q17: Unique birth years (ascending)
SELECT DISTINCT YEAR(birth_date)
FROM patients
ORDER BY YEAR(birth_date);

-- Q18: First names that occur only once
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;

-- Q19: Names starting and ending with 's' and length ≥ 6
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%s'
  AND LENGTH(first_name) >= 6;

-- Q20: Patients diagnosed with Dementia
SELECT p.patient_id, first_name, last_name
FROM patients p
JOIN admissions a
  ON p.patient_id = a.patient_id
WHERE diagnosis = 'Dementia';

-- Q21: Order first names by length, then alphabetically
SELECT first_name
FROM patients
ORDER BY LENGTH(first_name), first_name;

-- Q22: Male vs female count in one row
SELECT
  (SELECT COUNT(*) FROM patients WHERE gender='M') AS male_count,
  (SELECT COUNT(*) FROM patients WHERE gender='F') AS female_count;

-- Q23: Patients allergic to Penicillin or Morphine
SELECT first_name, last_name, allergies
FROM patients
WHERE allergies IN ('Penicillin','Morphine')
ORDER BY allergies, first_name, last_name;

-- Q24: Patients admitted multiple times for same diagnosis
SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

-- Q25: City-wise patient count
SELECT city, COUNT(patient_id) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC, city;

-- Q26: List patients and doctors together
SELECT first_name, last_name, 'Patient' AS role
FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role
FROM doctors;

-- Q27: Allergies ordered by popularity (exclude NKA & NULL)
SELECT allergies, COUNT(*) AS count_allergy
FROM patients
WHERE allergies IS NOT NULL
  AND allergies <> 'NKA'
GROUP BY allergies
ORDER BY count_allergy DESC;

-- Q28: Patients born in the 1970s
SELECT first_name, last_name, birth_date
FROM patients
WHERE birth_date BETWEEN '1970-01-01' AND '1979-12-31'
ORDER BY birth_date;

-- Q29: Full name as LASTNAME,firstname
SELECT
  UPPER(last_name) || ',' || LOWER(first_name) AS full_name
FROM patients
ORDER BY first_name DESC;

--------------------------------------------------
-- HARD 
--------------------------------------------------

-- Q30: Province where total height ≥ 7000
SELECT province_id, SUM(height) AS total_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;

-- Q31: Weight difference for last name 'Maroni'
SELECT MAX(weight) - MIN(weight) AS weight_difference
FROM patients
WHERE last_name = 'Maroni';

-- Q32: Admissions per day of month
SELECT
  DAY(admission_date) AS day_of_month,
  COUNT(*) AS total_admissions
FROM admissions
GROUP BY day_of_month
ORDER BY total_admissions DESC;

-- Q33: Most recent admission for patient 542
SELECT *
FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
LIMIT 1;

-- Q34: Patients with no admissions
SELECT patient_id, first_name, last_name
FROM patients
WHERE patient_id NOT IN (
  SELECT DISTINCT patient_id FROM admissions
);

-- Q35: Most recent admission per patient with doctor
SELECT
  p.first_name || ' ' || p.last_name AS patient_name,
  a.admission_date,
  a.diagnosis,
  d.first_name || ' ' || d.last_name AS doctor_name
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
WHERE a.admission_date = (
  SELECT MAX(admission_date)
  FROM admissions
  WHERE patient_id = a.patient_id
);
