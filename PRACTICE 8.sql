-- cau 1
with result as (
select *, customer_pref_delivery_date - order_date as diff,
rank() over(partition by customer_id order by order_date) as first_order
from delivery)
select 
sum(Case when diff=0 then 1 else 0 end)/count(*)*100 as immediate_percentage
from result
where first_order =1
-- cau 2
with result as (
select player_id, event_date,
lead(event_date) over(partition by player_id order by event_date) as next_date,
event_date - (lead(event_date) over(partition by player_id order by event_date)) as diff
from activity 
)
select 
round(sum(Case when diff=-1 then 1 else 0 end)/count(distinct(player_id)),2) as fraction from result
-- cau 3
 select
 case 
 when id = (select count(*) from seat) and id%2=1 then id 
 when id < (select count(*) from seat) and id%2=1 then id+1 else id-1 
 end
 as id, student
from seat
order by id
-- cau 4
with a as
(select visited_on, sum(amount) as amount from customer
group by visited_on)

select visited_on,
sum(amount) over(order by visited_on 
rows between 6 preceding and current row) as amount,
round(avg(amount) over(order by visited_on 
rows between 6 preceding and current row),2) as average_amount
from a
LIMIT 10000000
OFFSET 6
-- cau 5
select sum(tiv_2016) as tiv_2016 from Insurance 
where tiv_2015 in
(select tiv_2015
from Insurance
group by tiv_2015
having count(tiv_2016) >1)
and (lat, lon) in
(SELECT lat, lon
FROM Insurance
GROUP BY lat, lon
HAVING COUNT(*) = 1)
-- cau 6

-- cau 7

-- cau 8

