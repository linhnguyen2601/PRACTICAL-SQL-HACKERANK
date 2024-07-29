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

with cte as (
select *, recordDate -1 as previous_recordDate from weather)
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


