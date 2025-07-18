/*
What are the top skills based on salary?
- Look at the average salary associated with each skill for data analyst positions.
- Focus on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for data analysts
    and helps identify the most financially rewarding.
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS Average_Salary
from job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_work_from_home = 'True' AND 
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    Average_Salary DESC