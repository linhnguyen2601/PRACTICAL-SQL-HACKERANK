--cau 1
select month_year, 
count(order_id) as total_order, count(distinct user_id) as total_user
from (
select
order_id, user_id,
format_date('%Y-%m',created_at) as month_year,
created_at from bigquery-public-data.thelook_ecommerce.orders
where status ='Complete') as a
where month_year between '2019-01' and '2022-04'
group by month_year

--cau 2
with e as (
select
b.order_id, b.user_id,
format_date('%Y-%m',b.created_at) as month_year,
c.order_amount
from bigquery-public-data.thelook_ecommerce.orders as b
JOIN 
(select order_id, sum(sale_price) as order_amount
from bigquery-public-data.thelook_ecommerce.order_items
group by order_id) as c
on b.order_id=c.order_id
where status ='Complete')

select month_year,
count(distinct user_id) as distinct_users,
sum(order_amount)/count(order_id) as average_order_value
from e 
group by month_year
order by month_year

--cau 3
with oldest_youngest as
(
select first_name, last_name, age, gender,
case when youngest = 1 then 'youngest' else 'oldest' end as tag
from (
select first_name, last_name, age, gender,
rank() over (partition by gender order by age) as youngest,
rank() over (partition by gender order by age desc) as oldest
from bigquery-public-data.thelook_ecommerce.users) as g
where youngest =1 or oldest=1
order by last_name)

select tag, age,
count(*) as cnt from oldest_youngest
group by tag, age

--cau 4
with price_cost as (
select 
a.product_id, a.sale_price,
format_date('%Y-%m',a.created_at) as month_year,
b.cost, b.name
from bigquery-public-data.thelook_ecommerce.order_items as a
JOIN bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
where status = "Complete"),

product_profit as (
select 
month_year,
product_id, name,sale_price, cost,
sum(sale_price - cost) as profit
from price_cost
group by month_year, product_id, name,sale_price, cost)

select * from (
select *,
dense_rank() over(partition by month_year order by profit desc) as rank_per_month
from product_profit) as profit_ranking
where rank_per_month <=5

--cau 5
with a as (
select a.order_id,
a.product_id,a.sale_price,
format_date('%Y-%m-%d',a.created_at) as day,
b.category as product_categories
from bigquery-public-data.thelook_ecommerce.order_items as a
JOIN bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
where status = "Complete"
)
select day, product_categories,   
sum(sale_price) as revenue
from a
where day between '2022-01-15' and '2022-04-15'
group by product_categories, day 

-- Phần 2
-- cau 1
CREATE TEMP VIEW vw_ecommerce_analyst as (
with d as(
select
a.order_id, 
format_date('%Y-%m', a.created_at) as month,
format_date('%Y', a.created_at) as year,
b.product_id, b.sale_price, c.category, c.cost
from bigquery-public-data.thelook_ecommerce.orders as a
JOIN
bigquery-public-data.thelook_ecommerce.order_items as b
on a.order_id=b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products as c
on b.order_id=c.id
where a.status = 'Complete'),

e as (
select month,year, sale_price, category,cost,
sum(sale_price) over(partition by month, category) as TPV,
sum(cost) over(partition by month, category) as total_cost,
sum(order_id) over(partition by month, category) as TPO,
sum(sale_price-cost) over(partition by month, category) as total_profit,
sum((sale_price-cost)/cost) over(partition by month, category) as Profit_to_cost_ratio
from d)

select *,
lead(TPV) over(order by month, category) as previous_TPV,
lead(total_cost) over(order by month,category)as previous_total_cost,
lead(TPO) over(order by month,category) as previous_TPO,
lead(total_profit) over(order by month,category) as previous_total_profit_total_profit,
lead(Profit_to_cost_ratio) over(order by month,category) as previous_Profit_to_cost_ratio
from e
order by month
)
-- cau 2
with a as (
select user_id,created_at,
format_date('%Y-%m-%d',(min(created_at) over(partition by user_id))) as first_order, 
format_date('%Y-%m-%d', created_at) as order_date
from bigquery-public-data.thelook_ecommerce.order_items
where status ='Complete'
),
b as (
select *, format_date('%Y-%m', created_at) as order_month,
(extract(year from date(order_date))- extract(year from date(first_order)))*12+
(extract(month from date(order_date))- extract(month from date(first_order)))+1 as index
from a
where (extract(year from date(order_date))- extract(year from date(first_order)))*12+
(extract(month from date(order_date))- extract(month from date(first_order)))+1<=4
),
c as(
select order_month, index,
count(user_id) as so_KH
from b
group by order_month, index)
select order_month,
sum(case when index=1 then so_KH else 0 end) as m1,
sum(case when index=2 then so_KH else 0 end) as m2,
sum(case when index=3 then so_KH else 0 end) as m3,
sum(case when index=4 then so_KH else 0 end) as m4
from c
group by order_month
order by order_month
