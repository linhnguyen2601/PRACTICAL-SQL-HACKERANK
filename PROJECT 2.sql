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
