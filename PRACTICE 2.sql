-- bai tap 1
select distinct City from Station
where ID%2=0
-- bai tap 2
select count(city) - count(distinct city) from station;
-- bai tap 3
-- bai tap 4
SELECT ROUND(CAST(SUM(item_count * order_occurrences)/SUM(order_occurrences) AS DECIMAL),1) as mean
FROM items_per_order
-- bai tap 5
SELECT candidate_id,
count(skill) as skill_count
from candidates
where skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING count(skill) = 3
--bai tap 6
SELECT user_id,
--MIN(post_date::DATE) As first_date,
--max(post_date::DATE) as last_date,
max(post_date::DATE) - MIN(post_date::DATE) As days_between
FROM posts
WHERE post_date between '01-01-2021' and '12-31-2021'
GROUP BY user_id
HAVING count(post_id) > 1 ;
--bai tap 7
SELECT 
card_name,
--MIN(issued_amount) As min_month,
--max(issued_amount) as max_month, 
Max(issued_amount) - MIN(issued_amount) as difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY Max(issued_amount) - MIN(issued_amount) DESC;
--bai tap 8
SELECT
  manufacturer,
  COUNT(drug) AS drug_count,
  abs(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY total_loss DESC;
-- bai tap 9
select
id, movie, description, rating
from cinema
where id%2=1 and description not like 'boring'
order by rating desc
-- bai tap 10
select teacher_id,
count(distinct subject_id) as cnt
from Teacher
group by teacher_id;
-- bai tap 11
select
user_id,
count(follower_id) as followers_count
from followers
group by user_id
--bai tap 12
select 
class
from courses
group by class
having count(distinct student)> 5
