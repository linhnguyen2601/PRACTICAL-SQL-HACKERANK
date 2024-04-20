-- bai tap 1: query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer
select b.continent, floor(avg(a.population))
from city as a
JOIN country as b
on a.countrycode = b.code
group by b.continent
-- bai tap 2: Write a query to find the activation rate. Round the percentage to 2 decimal places.
SELECT 
  ROUND(cast(sum(case when a.signup_action='Confirmed' then 1 else 0 end) AS DECIMAL)/
cast(count(DISTINCT(b.email_id)) as decimal),2)
from texts as a
RIGHT JOIN emails as b 
ON a.email_id=b.email_id
-- bai tap 3: 
SELECT a.age_bucket,
ROUND(SUM(case when b.activity_type ='send' then b.time_spent else 0 end)/
SUM(time_spent)*100,2) as send_percentage,
100- ROUND(SUM(case when b.activity_type ='send' then b.time_spent else 0 end)/
SUM(time_spent)*100,2) as open_percentage
FROM age_breakdown as a
JOIN activities as b 
ON (a.user_id=b.user_id
and not activity_type='chat')
group by a.age_bucket
-- bai tap 4
