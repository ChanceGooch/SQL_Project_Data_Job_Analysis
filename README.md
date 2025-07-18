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

- **Employers:** There are a wide variety of companies offering these salaries across many different industries indicating a broad interest in data analysis.

### 2. What are the skills required for top-paying data analyst roles?
Now that we have the top paying roles I wanted to next find the skills required for each of these roles. I did this by joining the job postings table with the skills table to find exactly what skills each of the highest paying employers were looking for.
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
### Query Breakdown:

Top 5 Highest Paying Data Analyst Jobs
| Company                | Salary      | Notable Skills                                                             |
| ---------------------- | ----------- | -------------------------------------------------------------------------- |
| **AT\&T**              | \$255,829.5 | pyspark, databricks, power bi, jupyter, pandas, aws, azure                 |
| **Pinterest**          | \$232,423   | hadoop, r, tableau, sql, python                                            |
| **Uclahealthcareers**  | \$217,000   | crystal, oracle, flow, tableau                                             |
| **SmartAsset (Job 1)** | \$205,000   | snowflake, numpy, go, pandas, tableau, gitlab                              |
| **Inclusively**        | \$189,309   | snowflake, power bi, sap, azure, bitbucket, confluence, atlassian, jenkins |

🧠 AT&T’s role is an outlier with a very high salary — possibly senior-level or specialist with strong data engineering & cloud stack.

Top Companies by Skill Coverage
| Company         | Unique Skills Used                                         |
| --------------- | ---------------------------------------------------------- |
| **AT\&T**       | 12 (widest spread — strong across analytics & engineering) |
| **Inclusively** | 13 (cloud + analytics + collaboration tools)               |
| **SmartAsset**  | 9 (appears in two roles — both high paying)                |
| **Motional**    | 8 (focuses on core tools and project management stack)     |

Most Common Skills Across All High PPaying Jobs.
| Skill         | Appearances | Sample Companies                          |
| ------------- | ----------- | ----------------------------------------- |
| **SQL**       | 9           | AT\&T, Pinterest, SmartAsset, Inclusively |
| **Python**    | 9           | Same as above                             |
| **Tableau**   | 7           | Pinterest, AT\&T, SmartAsset              |
| **Excel**     | 4           | AT\&T, SmartAsset                         |
| **R**         | 4           | AT\&T, Pinterest, Motional                |
| **Snowflake** | 3           | SmartAsset, Inclusively                   |
| **Power BI**  | 3           | AT\&T, Inclusively                        |

These are essential core skills for high-paying data analyst roles. Most jobs list SQL + Python + BI tool as a baseline.

| Role Style                   | Common Stack                                                 | Example Job           |
| ---------------------------- | ------------------------------------------------------------ | --------------------- |
| **Data Engineering-Heavy**   | `pyspark`, `databricks`, `aws`, `azure`, `jupyter`, `gitlab` | AT\&T                 |
| **Traditional BI Analyst**   | `sql`, `power bi`, `tableau`, `excel`, `r`                   | Ucla, Pinterest       |
| **Cloud/Data Platform**      | `snowflake`, `go`, `numpy`, `pandas`                         | SmartAsset            |
| **Team Collaboration Focus** | `jira`, `confluence`, `bitbucket`, `atlassian`, `jenkins`    | Inclusively, Motional |

- SQL, Python, Tableau, Excel, Power BI are core universal tools.

- Top-paying roles lean heavily into cloud platforms, data engineering (PySpark, Databricks), and modern collaboration (Jira, Gitlab).

C- ompanies like AT&T, SmartAsset, Inclusively are pushing the high-end of salary expectations — especially where engineering and BI intersect.

### 3. What are the most in-demand skills for data analysts?
This query helps to identify the most frequently requested skills in data analyst job postings and sorts by those most requested.

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
### Query Breakdown:
- SQL and Excel top the list and are followed closely by Python. It is clear that a data analyst needs strong foundational skills related to data processing and manipulation, as well as some programming skills.
- Tableau and PowerBI in 4th and 5th show support for a strong base in data visualization and storytelling to support decisions.
- Removing the work from home clause from the WHERE statement reveals a similar proportion with in-person and work from home job requiring similar skills.
### 4. What are the top skills ordered by salary for data analysts?
This query looks expands on the last one by checking which skills are the highest paying in the field of data analysis.

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
### Query Breakdown:
- Top Earning Skills (Above $150K): Highly specialized or in-demand technologies dominate the top (e.g., pyspark, bitbucket, watson, datarobot, swift, pandas, jupyter, gitlab). Many of these are used in big data, AI/ML, or DevOps workflows.

- Languages vs. Tools: Programming languages like pyspark, swift, and golang score high. Tools/platforms like bitbucket, gitlab, and databricks also fetch high salaries—showing the value of modern DevOps and MLOps tools.

- Legacy vs. Modern: Tools like excel, powerpoint, and ms access are at the bottom end of the salary scale. Legacy programming languages (e.g., vb.net, pascal) also command lower pay.

- Data Skills Trends: Skills related to cloud (gcp, aws, azure), data engineering (airflow, databricks, hadoop, spark), and ML/data science (pandas, numpy, scikit-learn, jupyter) are generally well paid.

Skill            | Average Salary ($)
-----------------|---------------------
pyspark          | ██████████████████ $208,172
bitbucket        | ████████████████   $189,155
couchbase        | ██████████████     $160,515
watson           | ██████████████     $160,515
datarobot        | █████████████      $155,486
gitlab           | █████████████      $154,500
swift            | █████████████      $153,750
jupyter          | █████████████      $152,777
pandas           | █████████████      $151,821
elasticsearch    | ████████████       $145,000

*Table of the average salary for the top 10 highest paying skills for data analysts.*

Suggestions
- Want higher pay? Focus on PySpark, Bitbucket, and AI/ML tools like Datarobot, Watson, or Jupyter.

- Stack building tip: Combine high-paying skills like pyspark or pandas with platforms/tools like airflow or gitlab.

### 5. What are the most optimal skills for a data analyst to learn? Optimal = high paying and high demand.
Finally, I combined all of the insights from the previous queries to figure out which skills were the highest paying and most in demand.

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

### Query Breakdown:
- High Salary, Low Demand (Niche & Specialized):
These skills have high salaries but relatively low demand, suggesting niche expertise or limited availability:

| Skill          | Salary    | Demand Count |
| -------------- | --------- | ------------ |
| **Go**         | \$115,320 | 27           |
| **Confluence** | \$114,210 | 11           |
| **BigQuery**   | \$109,654 | 13           |
| **SSIS**       | \$106,683 | 12           |

These are valuable if you're already specialized, but may not offer as many opportunities.

- High Demand, Mid Salary:
These are bread-and-butter data/tech skills — widely used with solid salaries:

| Skill        | Salary    | Demand Count |
| ------------ | --------- | ------------ |
| **SQL**      | \$97,237  | **398**      |
| **Excel**    | \$87,288  | 256          |
| **Python**   | \$101,397 | 236          |
| **Tableau**  | \$99,288  | 230          |
| **Power BI** | \$97,431  | 110          |
| **R**        | \$100,499 | 148          |


These are safe bets — high volume of jobs, often used in enterprise and data analysis workflows.

- Balanced (Good Pay + Moderate Demand):
These skills offer solid salaries and decent demand, making them smart additions to a resume:

| Skill          | Salary    | Demand Count |
| -------------- | --------- | ------------ |
| **Azure**      | \$111,225 | 34           |
| **Snowflake**  | \$112,948 | 37           |
| **AWS**        | \$108,317 | 32           |
| **SQL Server** | \$97,786  | 35           |
| **SAS**        | \$98,902  | 63           |

These are valuable if you want cloud/data engineering roles without being in an overly saturated space.

- Beginner to Intermediate: Start with SQL, Excel, Tableau, and Python.

- Mid-Career Data Analysts: Add Power BI, AWS, Snowflake, R, Azure.

- Advanced/Niche: Explore Go, SSIS, Confluence, or BigQuery for higher-paying specialist roles.
# What I learned

# Conclusions