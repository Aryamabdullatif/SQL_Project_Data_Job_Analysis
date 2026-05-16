

WITH skills_demanded AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        --AND job_location = 'Saudi Arabia'
        AND salary_year_avg IS NOT NULL

    GROUP BY 
        skills_dim.skill_id
   
),


AVG_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary

    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        -- job_location = 'Saudi Arabia'
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_job_dim.skill_id
)

SELECT 
    skills_demanded.skill_id,
    skills_demanded.skills,
    demand_count,
    avg_salary
FROM 
    skills_demanded
INNER JOIN AVG_salary ON skills_demanded.skill_id = AVG_salary.skill_id
ORDER BY 
    demand_count DESC
LIMIT 25
