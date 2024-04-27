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

-- cau 5

-- cau 6

-- cau 7

-- cau 8

