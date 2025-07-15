-- table of skills that have high demand

WITH skills_in_demand AS(SELECT 
    COUNT(sj.job_id) AS demand,
    sj.skill_id AS skillid,
    s.skills AS skill_name
FROM skills_job_dim  AS sj
INNER JOIN skills_dim AS s
ON sj.skill_id = s.skill_id
GROUP BY s.skills, sj.skill_id
ORDER BY demand DESC),

average_salary_per_skill AS (SELECT 
    s.skill_id AS skillid ,
    ROUND (AVG(salary_year_avg),2) AS average_skill_salary
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS s
    ON j.job_id = s.job_id
    WHERE j.salary_year_avg IS NOT NULL
    GROUP BY skillid
    ORDER BY average_skill_salary DESC
)   

SELECT  
    sin.demand
    sin.skill_name AS in_demand_skills
    avgs.average_skill_salary
FROM     
    skills_in_demand AS sin
INNER JOIN 
    average_salary_per_skill AS avgs
ON     
    sin.skillid = avgs.skillid
    
ORDER BY avgs.average_skill_salary DESC


    
    
    
    
    
    
