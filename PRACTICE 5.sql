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
SELECT a.customer_id
FROM customer_contracts as a
FULL JOIN products as b 
on a.product_id=b.product_id
GROUP BY a.customer_id
HAVING COUNT(distinct(b.product_category))=3
--bai tap 5
select a.reports_to as employee_id, b.name as name, count(a.name) as reports_count, round(avg(a.age)) as average_age
from employees as a
join
employees as b
on a.reports_to=b.employee_id
group by name
-- bai tap 6
select a.product_name, sum(b.unit) as unit
from products as a
RIGHT JOIN orders as b
on a.product_id = b.product_id
where (b.order_date between '2020-02-01' and '2020-02-28')
group by a.product_name
having sum(b.unit) >= 100
-- bai tap 7

--mid-course test
