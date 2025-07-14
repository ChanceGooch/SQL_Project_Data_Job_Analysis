/* Question: What are the top-paying Data Analyst jobs?
- Identify the top 10 highest paying data-analyst jobs available remotely.
- Focus on job postings with specified salaries (remove nulls).
- Learn what companies offer these roles.
- Why? Highlight the top-paying opportunities for Data Analysts.
*/

select *
FROM job_postings_fact
limit 100


Select
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
From 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT null
ORDER BY
    salary_year_avg DESC
LIMIT 10
