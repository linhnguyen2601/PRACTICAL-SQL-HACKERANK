-- bai tap 1: Query the Name of any student in STUDENTS who scored higher than  Marks
select name from students
where marks > 75
order by right(name,3), id
-- bai tap 2: 
select user_id,
concat(upper(left(name,1)), lower(substring(name,2))) as name
from Users
order by user_id
-- bai tap 3: Write a query to calculate the total drug sales for each manufacturer. 
SELECT manufacturer,
'$' ||ROUND(SUM(total_sales)/1000000)||' '||'million'
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC
-- bai tap 4: write a query to retrieve the average star rating for each product, grouped by month. 
SELECT 
extract(month from submit_date) as month,
product_id,
ROUND(AVG(stars),2)
FROM reviews
GROUP BY product_id, extract(month from submit_date)
ORDER BY extract(month from submit_date), product_id;
-- bai tap 5: Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022.
Select
sender_id, 
COUNT(sender_id)
FROM messages
where sent_date between '08/01/2022' and '09/01/2022'
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
limit 2;
-- bai tap 6
select 
tweet_id from tweets
where length(content)>15
-- bai tap 7
