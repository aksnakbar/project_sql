/*Top skills based on salary
-Look at the average salary assosiated with each skill
-Focuses on roles with specified salaries

find all the jobs associated with a skil
filter only data analyst jobs
find the average salary of all the jobs with a perticular skill

*/



WITH skills AS (SELECT 
    sj.job_id AS jobid,
    s.skills AS skills_demand
FROM   skills_job_dim AS sj
LEFT JOIN skills_dim AS s 
ON sj.skill_id = s.skill_id)

SELECT 
    skills.skills_demand,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS average_salary_per_skill
FROM skills 
INNER JOIN job_postings_fact
ON skills.jobid = job_postings_fact.job_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills.skills_demand 
ORDER BY average_salary_per_skill DESC








