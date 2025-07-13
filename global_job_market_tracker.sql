SELECT*FROM  ai_job_dataset1;
CREATE TABLE  ai_job_dataset2
LIKE ai_job_dataset1;

INSERT INTO ai_job_dataset2
SELECT *
FROM  ai_job_dataset1;

SELECT*FROM  ai_job_dataset2;

SELECT job_id, COUNT(*) AS count
FROM ai_job_dataset1
GROUP BY job_id
HAVING COUNT(*) > 1;

SELECT posting_date FROM ai_job_dataset2 LIMIT 5;

ALTER TABLE ai_job_dataset2 ADD COLUMN posting_date_clean DATE;
UPDATE ai_job_dataset2
SET posting_date_clean = STR_TO_DATE(posting_date, '%Y-%m-%d');

-- Add a new column
ALTER TABLE ai_job_dataset2 ADD COLUMN job_year INT;

-- Populate it
UPDATE ai_job_dataset2
SET job_year = YEAR(posting_date_clean);

-- Create a new column (optional)
ALTER TABLE ai_job_dataset2 ADD COLUMN experience_level_clean VARCHAR(20);

-- Update with readable values
UPDATE ai_job_dataset2
SET experience_level_clean = CASE experience_level
    WHEN 'EN' THEN 'Entry'
    WHEN 'MI' THEN 'Mid'
    WHEN 'SE' THEN 'Senior'
    WHEN 'EX' THEN 'Executive'
END;

SELECT*FROM  ai_job_dataset2;

DESCRIBE ai_job_dataset2;

ALTER TABLE ai_job_dataset2
DROP COLUMN salary_currency,
DROP COLUMN salary_local,
DROP COLUMN experience_level,
DROP COLUMN company_size,
DROP COLUMN employee_residence,
DROP COLUMN required_skills,
DROP COLUMN education_required,
DROP COLUMN years_experience,
DROP COLUMN industry,
DROP COLUMN posting_date,
DROP COLUMN application_deadline,
DROP COLUMN job_description_length,
DROP COLUMN benefits_score,
DROP COLUMN company_name;


SELECT * FROM ai_job_dataset2;

DESCRIBE ai_job_dataset2;

-- Update cleaned table using values from original
UPDATE ai_job_dataset2 AS cleaned
JOIN ai_job_dataset1 AS original
ON cleaned.job_id = original.job_id
SET cleaned.experience_level_clean = CASE original.experience_level
    WHEN 'EN' THEN 'Entry'
    WHEN 'MI' THEN 'Mid'
    WHEN 'SE' THEN 'Senior'
    WHEN 'EX' THEN 'Executive'
    ELSE 'Unknown'
END;
SELECT COUNT(*) 
FROM ai_job_dataset2
WHERE experience_level_clean IS NULL;

UPDATE ai_job_dataset2
SET employment_type = CASE employment_type
    WHEN 'FT' THEN 'Full-time'
    WHEN 'PT' THEN 'Part-time'
    WHEN 'CT' THEN 'Contract'
    WHEN 'FL' THEN 'Freelance'
    ELSE 'Unknown'
END;

-- Most In-Demand Job Roles by Year-- 
SELECT 
  YEAR(posting_date_clean) AS year,
  job_title,
  COUNT(*) AS total_postings
FROM ai_job_dataset2
GROUP BY year, job_title
ORDER BY year, total_postings DESC;

-- Remote vs Onsite Trends
SELECT 
  YEAR(posting_date_clean) AS year,
  remote_type,
  COUNT(*) AS total
FROM ai_job_dataset2
GROUP BY year, remote_type
ORDER BY year, remote_type;

-- Top Countries by Job Demand
SELECT 
  company_location,
  COUNT(*) AS total_jobs
FROM ai_job_dataset2
GROUP BY company_location
ORDER BY total_jobs DESC
LIMIT 10;

--  Experience Level Trends
SELECT 
  YEAR(posting_date_clean) AS year,
  experience_level_clean,
  COUNT(*) AS count
FROM ai_job_dataset2
GROUP BY year, experience_level_clean
ORDER BY year, count DESC;

-- Average Salary by Job Title
SELECT 
  job_title,
  ROUND(AVG(salary_usd)) AS avg_salary
FROM ai_job_dataset2
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 10;

 