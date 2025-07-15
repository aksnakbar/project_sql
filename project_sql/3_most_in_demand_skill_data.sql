/*Find the most in demand skills for Data Analyst
- First get the skills needed for Data Analyst jobs
- Count the number of times each skill appears in a job posting 
- Display all the skills in DESC order
*/

WITH data_analyst_jobs AS (SELECT 
    job_id,
    job_title,
    salary_year_avg
FROM 
    job_postings_fact AS j
WHERE 
    job_title_short = 'Data Analyst'  AND
    salary_year_avg IS NOT NULL)

SELECT 
    UPPER(s.skills),
    COUNT(s.skills) as top_skills
 FROM 
    data_analyst_jobs AS dj
LEFT JOIN skills_job_dim AS sj ON dj.job_id = sj.job_id
INNER JOIN skills_dim AS s ON s.skill_id = sj.skill_id
GROUP BY s.skills
ORDER BY top_skills DESC

