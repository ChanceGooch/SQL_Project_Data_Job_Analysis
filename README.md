# Introduction
This project was created based on the tutorials provided by Luke Barousse [here](https://www.youtube.com/watch?v=7mz73uXD9DA&t=14312s&ab_channel=LukeBarousse) as a means of learning SQL. It explores the highest paying data analyst jobs and the skills needed to reach them.

The queries used to complete this project are located here: [Project_SQL folder](/Project_SQL/)

# Background
I decided to take this project on after seeing many job listings with SQL as a requirement and taking a look at Luke's data pertaining to the Data Analysis field. Realizing I didn't have many technical skills, SQL seemed like the perfect place to start learning and building out my own skills and resume.

This project takes a closer look at the data analyst job market to pinpoint the highest paying jobs and the most in-demand skills within the field of data analysis.

### The main questions I wanted to answer through this project were:

1. What are the top paying data analyst jobs?
2. What are the skills required for these top-paying jobs?
3. What are the most in--demand skills for my role?
4. What are the top skills based on salary for my role?
5. What are the most optimal skills to learn? Optimal = high demand AND high paying.

# Tools I used
For this project I used:
- SQL: Used to query the database to reveal insights for my analysis.
- PostgreSQL: Our chosen database management system for handling the job posting data.
- Visual Studio Code: Used for writing and executing SQL queries.
- Git and Github: Used to share my SQL analysis and track the progress of my project.

# The Analysis
Each question and the query I used to approach them is listed below:

### 1. What are the top paying data analyst jobs?
In order to identify the highest paying data analyst roles, I filtered data analyst positions by average yearly salary and location, focusing on remote positions with a listed salary.

I was also curious about data analyst roles within my city so I created a seperate query with job location set to Calgary, Alberta, Canada.

```sql
Select
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
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
LIMIT 10;

/* Queries can easily be combined by adding 'Calgary, Alberta, Canada' as a second job_location, but I wanted to keep them seperate for the sake of the project deliverables.
*/

Select
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
    name AS company_name
From 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Calgary, AB, Canada' AND
    salary_year_avg IS NOT null
    -- Removing IS NOT null reveals many more positions available in Calgary
ORDER BY
    salary_year_avg DESC;
```
### Query Breakdown:
- **Salary Range:** The top 10 highest paying remote data analyst jobs range from $184,000 to $650,000 indicating significant salary potential within the field. 

    Jobs within Calgary appear to show a much lower earnings potential with positions ranging from $63,000 to $99,150 and none within the top 10 when combined with remote positions. However, the query returns less than 10 jobs and removing 'IS NOT null' returns many more positions with no listed salary where the earning potential may be similar to the first query.

- **Employers:** The companies associated with the top 10 highest salaries come from a wide variety of 

### 2. What are the skills required for top-paying data analyst roles?

```sql
WITH top_paying_jobs AS (
    Select
        job_id,
        job_title_short,
        salary_year_avg,
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
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

### 3. What are the most in-demand skills for a data analyst?

```sql
SELECT 
    skills,
    Count(skills_job_dim.job_id) AS Demand_Count
from job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND job_work_from_home = 'True'
GROUP BY
    skills
ORDER BY
    Demand_Count DESC
```
### 4. What are the top skills ordered by salary for data analysts?
```SQL
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
```
### 5. What are the most optimal skills for a data analyst to learn? Optimal = high paying and high demand.
```SQL
Select
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) AS demand_count,
    round(avg(job_postings_fact.salary_year_avg), 0) AS average_salary
From job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = true
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER by
    Average_Salary DESC,
    demand_count DESC
limit 25;
```
# What I learned

# Conclusions