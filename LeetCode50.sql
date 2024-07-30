# 1757. Recyclable and Low Fat Products

select product_id from Products
  where low_fats='Y' and recyclable ='Y'

# 584. Find Customer Referee

select name from customer
  where referee_id is null or referee_id <> 2

# 595. Big Countries

select name, population, area from world
where area >= 3000000 or population >= 25000000

# 1148. Article Views I
  
select distinct(author_id) as id from views
  where author_id  = viewer_id

#  1683. Invalid Tweets I
select tweet_id from tweets
  where length(content) > 15

# 1378. Replace Employee ID With The Unique Identifier
  
select b.unique_id,a.name from employees as a
  left join employeeUNI as b
  on a.id=b.id
  
#  1068. Product Sales Analysis I

select product_name,year, price from sales as a
  join product as b
  on a.product_id=b.product_id

1581. Customer Who Visited but Did Not Make Any Transactions

select customer_id, count(visit_id) as count_no_trans from visits  
  where visit_id not in (Select visit_id from transactions)
  group by customer_id

select customer_id, count(a.visit_id) as count_no_trans from visits as a
  left join transactions as b
  on a.visit_id=b.visit_id
  where transaction_id is null
  group by customer_id

# 197. Rising Temperature

select id from 
(
select id, temperature,
  lag(temperature) over(order by recorddate) as tem_next_day 
  from weather) as a
  where temperature > tem_next_day
=> không pass được test case nếu ngày recordDate không liền nhau

with cte as 
  (
select *, recordDate -1 as previous_recordDate 
  from weather)
select a.id from cte as a
  join weather as b
  on a.previous_recordDate = b.recordDate
  where a.temperature > b.temperature

# 1661. Average Time of Process per Machine

select machine_id, 
  round(avg(end_time - start_time)::numeric,3) as processing_time
  from
(
select a.machine_id, a.process_id, a.activity_type, a.timestamp as start_time, b.timestamp as end_time from activity as a
  join activity as b
  on (a.machine_id = b.machine_id) and (a.process_id = b.process_id)
  where a.activity_type = 'start' and b.activity_type = 'end') as c
  group by machine_id

# 577. Employee Bonus

select name, bonus from employee as a
  left join bonus as b
  on a.empID= b.empID
  where bonus < 1000 or bonus is null

# 1280. Students and Examinations  #cross join
  
with cte as
  (
select a.*, b.*, c.student_id as student_exam from students as a
  cross join subjects as b
  left join examinations as c
  on a.student_id = c.student_id 
    and b.subject_name = c.subject_name
  order by a.student_id, b.subject_name
  ),
cte2 as
  (
select student_id, student_name, subject_name, 
  case 
    when student_exam is null 
    then 0 
    else 1 end as exam
  from cte
  )
select student_id, student_name, subject_name, sum(exam) as attended_exams 
  from cte2
  group by student_id, student_name, subject_name

# 570. Managers with at Least 5 Direct Reports

select name from employee 
  where id in 
    (select managerid from employee
      group by managerid
      having count(*) >= 5
    ) 

# 1934. Confirmation Rate

with cte as 
  (
select a.user_id, b.action from signups as a
  left join confirmations as b
  on a.user_id = b.user_id 
  )

select user_id, 
round
  (sum
    (case   
        when action = 'confirmed' 
        then 1 
        else 0 end)*1.0/count(*),2) as confirmation_rate 
  from cte
  group by user_id

# 620. Not boring movie

select * from cinema
  where id % 2 = 1 and description <> 'boring'
  order by rating desc  

# 1251. Average Selling Prices

with cte as
  (
select a.product_id, a.price, b.units from prices as a
  join unitssold as b
  on a.product_id = b.product_id
  where b.purchase_date between a.start_date and a.end_date
  )
select product_id, 
    round(sum(price*units)/sum(units) :: numeric, 2) as average_price from cte
  group by product_id

# không qua được test case trong trường hợp bảng products có những sản phẩm không được bán và không có trong unitsSold

with cte as(
select a.product_id, a.price, b.units from prices as a
  left join unitssold as b
  on a.product_id = b.product_id
  where b.purchase_date is null or b.purchase_date between a.start_date and a.end_date)
select product_id, 
case 
  when sum(units) is not null 
  then (round(sum(price*units)/sum(units) :: numeric, 2)) 
  else 0 end as average_price 
  from cte
group by product_id

# 2356. Number of Unique Subjects Taught by Each Teacher

#Pandas:

import pandas as pd

def count_unique_subjects(teacher: pd.DataFrame) -> pd.DataFrame:

#PostgresSQL:

# 1075. Project Employees I

select project_id, round(avg(experience_years), 2) as average_years from
(
select a.*, experience_years from project as a
join employee as b
on a.employee_id = b.employee_id) as c
group by project_id

# 1633. Percentage of Users Attended a Contest

select contest_id, 
round(
    count(user_id)*100.00/(select count(Distinct(user_Id)) from users)
    ,2) as percentage 
  from register
group by contest_id
order by percentage desc, contest_id

# 1211. Queries Quality and Percentage

select query_name,
round(avg(rating*1.0/position),2) as quality,
round(
    sum(case when rating < 3 then 1 else 0 end)*100.00/count(rating)
    ,2) as poor_query_percentage 
from queries
where query_name is not null
group by query_name

# 1193. Monthly Transactions I

SELECT 
    TO_CHAR(trans_date, 'YYYY-MM') AS month,
    country, 
    COUNT(id) AS trans_count,
    SUM(case when state = 'approved' then 1 else 0 end) as approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(case when state = 'approved' then amount else 0 end) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    month, country;

# 1174. Immediate Food Delivery II

## Tỷ lệ đơn hàng giao ngay trong ngày:

select 
round(
sum(case when 
order_date = customer_pref_delivery_date 
then 1 else 0 end
    )*100.0
    /count(*) 
    ,2)as immediate_percentage from Delivery

## Tỷ lệ khách hàng nhận được đơn hàng đầu tiên giao ngay trong ngày
