CREATE DATABASE GenZ_Project;
use genz_project;
CREATE TABLE GenZ
(
Timestamp timestamp,
Country TEXT,
Zipcode VARCHAR(20),
Gender CHAR(5),
`Influencing Factors` VARCHAR(50),
`Higher Education Aspiration` VARCHAR(20),
`3 Year Tenurity` VARCHAR(20),
`Would you work for a company with an unclear mission?` TINYINT(1),
`Likeliness to work if mission and actions are misaligned` TINYINT(1),
`Likeliness to work for low impact company` TINYINT,
`Preferred working environment` VARCHAR(50),
`Preferred Employer` VARCHAR(30),
`Preferred learning environment` VARCHAR(30),
`Closest aspirational career` VARCHAR(30),
`Preferred Manager Type` VARCHAR(30),
`Preferred Work Setup` VARCHAR(30),
`Would you work for a company with recent layoffs?` ENUM('Yes', 'No') NULL,
`Likelihood of 7+ years with one employer?` ENUM('Yes', 'No', 'Depends on the company') NULL,
`Email address` VARCHAR(255) NULL,
`Minimum expected monthly salary (0-3) years` VARCHAR(20) NULL,
`Minimum expected monthly salary after 5 years` VARCHAR(20) NULL,
`Would you work for a company with no remote policy?` TINYINT NULL,
`Minimum Salary expectations from first company` VARCHAR(20) NULL,
`What Kind of company would you like to work` VARCHAR(50) NULL,
`Would you work under an abusive manager?` ENUM('Yes', 'No') NULL,
`Preferred Working Hours` VARCHAR(30) NULL,
`How often do you need a full week off for work-life balance?` VARCHAR(50) NULL,
`What would make you happier and productive at work` VARCHAR(50) NULL,
`What would frustrate you at work ?` VARCHAR(30) NULL
);

/*
We chose the LOAD DATA INFILE method for importing data because 
it allows for efficient bulk loading of large datasets (here we have 78,739 rows) into MySQL. 
This method significantly reduces import time compared to traditional row-by-row insertion methods, 
making it ideal for handling large volumes of data quickly and effectively.
*/
SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/GenZCleaned.csv'
INTO TABLE GenZ
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from genz;

-- 1. What is the gender distribution of respondents from India?
select Gender,count(gender) as Count_of_respondents,round(count(gender)*100/(select count(*) from genz where country='india'),2) as percentage_distribution from genz
where country ='India'
group by gender;

-- 2. What percentage of respondents from India are interested in education abroad and sponsorship?
select * from genz;
select `higher education aspiration`,count(`higher education aspiration`) as Count_of_indian_respondents,
Round(count(`higher education aspiration`)*100/(select count(*) from genz 
where country = 'India' And `higher education aspiration` in ('yes','Needs a sponsor','no')),2) as percentage_distribution
from genz
where country = 'India' And `higher education aspiration` in ('yes','Needs a sponsor','no') 
group by `higher education aspiration`;

/* the above query is the percentage calculation for only two categories of respondents
   that is those who are interested in stuying abroad and respondents are interested
   but if someone could sponsor them. 
*/

select `higher education aspiration`,count(*) AS No_of_Interested_respondents,
round((count(*) * 100.0 / (select count(*) from genz where country = 'India')),2) AS Percentage_Distribution
from genz
where country = 'India'
group by `higher education aspiration`; -- this query gives all distribution of interested candidates from india.

-- 3. What are the 6 top influences on career aspirations for respondents in India?
select `influencing factors`, count(`influencing factors`) as Count_of_influencing_factors from genz
where country='india'
group by `influencing factors`
order by Count_of_influencing_factors desc
limit 6;

 -- 4. How do career aspiration influences vary by gender in India?
select `influencing factors` as Career_Influencing_Factors,
       sum(case when gender = 'F' then 1 else 0 end) as F,
       sum(case when gender = 'M' then 1 else 0 end) as M,
       sum(case when gender = 'Other' then 1 ELSE 0 end) as Other
from genz
where country = 'India'
group by `influencing factors`;

-- 5. What percentage of respondents are willing to work for a company for at least 3 years?

select* from genz;
select `3 year tenurity`,count(`3 year tenurity`) as count_of_respondents,
round((count(*) * 100.0 / (select count(*) from genz where country = 'India')),2) as Percentage_Distribution
from genz
group by `3 year tenurity`;


-- 6. How many respondents prefer to work for socially impactful companies?
select 
case
when `Likeliness to work for low impact company` between 1 and 3 then 'High Preference'
when `Likeliness to work for low impact company` between 4 and 6 then 'Neutral'
when `Likeliness to work for low impact company` between 7 and 10 then 'Less preference for socially impactful companies'
end as Preference_Group,
count(*) as Count_of_respondents
from genz
where country = 'India'
group by Preference_Group;


-- 7. How does the preference for socially impactful companies vary by gender?
select gender,
sum(case when `likeliness to work for low impact company` between 1 and 3 then 1 else 0 end) as `strongly prefer socially impactful companies`,
sum(case when `likeliness to work for low impact company` between 4 and 6 then 1 else 0 end) as `neutral`,
sum(case when `likeliness to work for low impact company` between 7 and 10 then 1 else 0 end) as `less preference for socially impactful companies`
from genz
where country = 'india'
group by gender;

-- 8. What is the distribution of minimum expected salary in the first three years among respondents?

select `minimum expected monthly salary (0-3) years` as `Monthly Salary`, 
count(*) as `count of respondents`
from genz
where country = 'india'
group by `minimum expected monthly salary (0-3) years`
order by `count of respondents` desc;


-- 9. What is the expected minimum monthly salary in hand?
select `Minimum Salary expectations from first company` as `Minimum Monthly salary`,
count(*) as `count of respondents`
from genz
where `Minimum Salary expectations from first company` != 'N/A'
group by `Minimum Salary expectations from first company`
order by `count of respondents` desc;

-- 10. What percentage of respondents prefer remote working?
select `Preferred working environment`,count(*) as `count of respondents`,
round((count(*) / (select count(*) from genz where country = 'India')) * 100, 2) as `percentage distribution`
from genz
where country = 'India'
group by `Preferred working environment`
order by `count of respondents` desc;

-- 11. What is the preferred number of daily work hours?
select `Preferred Working hours` as `Daily Work Hours`,count(*) as `count of respondents`
from genz
where country = 'India' and `Preferred Working hours` !='N/A'
group by `Preferred Working hours`
order by `count of respondents` desc;

-- 12. What are the common work frustrations among respondents?
select `What would frustrate you at work ?` as `Frustration Factor`,count(*) as `Count of Respondents`
from genz
where country = 'India' and `What would frustrate you at work ?`!='N/A'
group by `What would frustrate you at work ?`
order by `Count of Respondents` desc;

-- 13. How does the need for work-life balance interventions vary by gender?
select `How often do you need a full week off for work-life balance?` as `Break for work-life balance`,
count(*) as `count of respondents`
from genz
where country = 'India' and `How often do you need a full week off for work-life balance?` !='N/A'
group by `How often do you need a full week off for work-life balance?`
order by `count of respondents` desc;

-- 14. How many respondents are willing to work under an abusive manager?
select `Would you work under an abusive manager?` as `Work under abusive manager`,
count(*) as `count of respondents`
from genz
where country = 'India' and `Would you work under an abusive manager?`!= 'N/A'
group by `Would you work under an abusive manager?`
order by `count of respondents` desc;

-- 15. What is the distribution of minimum expected salary after five years?
select `Minimum expected monthly salary after 5 years` as `Mimimum salary after 5 years`,
count(*) as `count of respondents`
from genz
where country = 'India' 
group by `Minimum expected monthly salary after 5 years`
order by `count of respondents` desc;

-- 16. What are the remote working preferences by gender?
select `Preferred working environment` as `Remote working preference by gender`,
sum(case when gender = 'F' then 1 else 0 end) as F,
sum(case when gender = 'M' then 1 else 0 end) as M,
sum(case when gender = 'Other' then 1 ELSE 0 end) as Other,
COUNT(*) AS Grand_Total
from genz
where country = 'India'
group by `Preferred working environment`;


-- 17. What are the top work frustrations for each gender?
select `What would frustrate you at work ?` as `Work Frustations`,
sum(case when gender = 'F' then 1 else 0 end) as F,
sum(case when gender = 'M' then 1 else 0 end) as M,
sum(case when gender = 'Other' then 1 ELSE 0 end) as Other,
COUNT(*) AS Grand_Total
from genz
where country = 'India' and `What would frustrate you at work ?`!='N/A'
group by `What would frustrate you at work ?`;

-- 18. What factors boost work happiness and productivity for respondents?
select `What would make you happier and productive at work` as `Factors boosting productivity`,
count(*) as `count of respondents`
from genz
where country = 'India' and `Preferred Working hours` !='N/A'
group by `What would make you happier and productive at work`
order by `count of respondents` desc;

-- 19. What percentage of respondents need sponsorship for education abroad?
select `higher education aspiration`, count(`higher education aspiration`) as count_of_indian_respondents,
round(count(`higher education aspiration`) * 100 / (select count(*) from genz 
where country = 'India' and `higher education aspiration` in ('yes', 'needs a sponsor', 'no')), 2) as percentage_distribution
from genz
where country = 'India' 
group by `higher education aspiration`;


















































