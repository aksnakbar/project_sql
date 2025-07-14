SELECT * FROM job_postings_fact
LIMIT 100;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date:: DATE AS date
FROM 
    job_postings_fact;    

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM 
    job_postings_fact
    
LIMIT 5    ;     

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST',
    EXTRACT (MONTH FROM job_posted_date) AS date_month
FROM 
    job_postings_fact
    
LIMIT 5 ;

SELECT 
        job_schedule_type,
        AVG(salary_year_avg) AS yearly_average_salary,
        AVG(salary_hour_avg) AS hourly_avg_salary
       
FROM job_postings_fact        
WHERE 
      job_posted_date :: DATE > '2023-05-31'  
GROUP BY 
      job_schedule_type;       

SELECT 
        COUNT(job_title) AS number_of_jobs,
        
        EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS month_posted
FROM job_postings_fact
GROUP BY  month_posted
ORDER BY  month_posted ; 

SELECT 
    c.name AS company_name, 
    j.job_title AS job,
    TO_CHAR(j.job_posted_date, 'Month') AS month
FROM job_postings_fact AS j 
INNER JOIN company_dim  AS c
ON j.company_id = c.company_id  
WHERE 
    j.job_health_insurance = true AND
    EXTRACT(MONTH FROM j.job_posted_date) BETWEEN 4 AND 6
ORDER BY month    ;


CREATE TABLE january_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE febraury_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;    

CREATE TABLE march_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;   

SELECT 
    job_title,
    job_location,
CASE     
    WHEN salary_year_avg >100000 THEN 2 
    WHEN salary_year_avg BETWEEN 100000 AND 50000 THEN 1
    ELSE 0
END AS salary_level,
CASE     
    WHEN salary_year_avg >100000 THEN 'High' 
    WHEN salary_year_avg BETWEEN 100000 AND 50000 THEN 'Standard'
    ELSE 'Low'
END AS salary_category
FROM job_postings_fact
WHERE job_title ='Data Analyst'
ORDER BY salary_level DESC;

SELECT 
    job_location,
SUM( CASE 
        WHEN salary_year_avg >= 100000 THEN 1
        ELSE 0
        END) AS high_paying,
SUM( CASE 
        WHEN salary_year_avg BETWEEN 60000 AND 99999 THEN 1
        ELSE 0
        END) AS standard_paying,
SUM( CASE
        WHEN salary_year_avg < 60000 THEN 1
        ELSE 0
        END) AS low_salary             
FROM job_postings_fact
WHERE LOWER(job_title) LIKE '%data analyst%' AND salary_year_avg IS NOT NULL
GROUP BY job_location
ORDER BY high_paying DESC, standard_paying DESC , low_salary DESC;


SELECT COUNT(*) FROM job_postings_fact
WHERE LOWER(job_title) LIKE '%data analyst%' AND salary_year_avg BETWEEN 60000 AND 99999;

SELECT * FROM skills_dim;


SELECT s.skills, skills.demand FROM skills_dim AS s
INNER JOIN (SELECT skill_id , COUNT(skill_id) AS demand
FROM skills_job_dim
GROUP BY skill_id
ORDER BY demand DESC
LIMIT 5) AS skills 
ON s.skill_id = skills.skill_id;


WITH jobs_per_company AS (SELECT c.name AS name , job_count.jobs AS jobcount FROM company_dim AS c
INNER JOIN (SELECT company_id , COUNT(job_id) AS jobs
FROM job_postings_fact
GROUP BY company_id) AS job_count 
ON c.company_id = job_count.company_id)

SELECT jobs_per_company.name,
CASE
    WHEN jobcount < 10 THEN 'small'
    WHEN jobcount BETWEEN 10 AND 50 THEN 'medium'
    WHEN jobcount > 50 THEN 'large'
 END AS size_category
FROM jobs_per_company;

SELECT  
    skillset.skillid AS skillids, skillset.skill_name AS skills_indemand, COUNT(*) AS remote_posts FROM job_postings_fact AS j
INNER JOIN 
    (SELECT sj.job_id AS jobid, sj.skill_id AS skillid, s.skills AS skill_name
FROM skills_job_dim AS sj
INNER JOIN skills_dim AS s 
ON sj.skill_id = s.skill_id) AS skillset
ON j.job_id = skillset.jobid
WHERE j.job_work_from_home = true AND j.job_title_short = 'Data Analyst'
GROUP BY skillids, skills_indemand
ORDER BY remote_posts DESC
LIMIT 5;



SELECT * FROM job_postings_fact
WHERE 
(EXTRACT(MONTH from job_posted_date) BETWEEN 1 AND 3 ) AND 
EXTRACT(YEAR FROM job_posted_date)=2023 AND
salary_year_avg >70000 AND
job_title_short = 'Data Analyst';



