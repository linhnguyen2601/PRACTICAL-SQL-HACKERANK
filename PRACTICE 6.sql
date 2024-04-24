-- cau 1
select count(company_id)
FROM (
select count(job_id) as count_job_id, company_id, title, description
from job_listings
group by company_id, title, description) as Results
where count_job_id > 1
-- cau 2
SELECT category, product, total_spend
FROM (
SELECT category, product, SUM(spend) as total_spend,
RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC)
from product_spend
where transaction_date between '01-01-2022' and '01-01-2023'
group by (category, product)
) as result
where rank < 3
-- cau 3
select COUNT(policy_holder_id) FROM
(SELECT policy_holder_id, COUNT(case_id) as number_of_calls FROM callers
group by policy_holder_id) as result
where number_of_calls >=3
-- cau 4
SELECT a.page_id
FROM pages as a  
FULL JOIN page_likes as b  
ON a.page_id = b.page_id
where b.page_id is NULL
order by a.page_id
-- cau 5
with result AS
(SELECT 
EXTRACT(MONTH from event_date) as month,
user_id
FROM user_actions
where event_date between '06/01/2022' and '08/01/2022')
select a.month, count(distinct(a.user_id))
from result as a  
join result as b  
on (a.user_id = b.user_id
and a.month <> b.month)
where a.month=7 
group by a.month
-- cau 6
with approved_transaction as
(select
date_format (trans_date, '%c %Y') as month,
country, count(id) as approved_trans_count,
sum(amount) as sum_approved_amount
from transactions
where state = 'approved'
group by date_format (trans_date, '%c %Y'), country
),
total_transaction as
(select
date_format (trans_date, '%c %Y') as month,
country,count(id) as trans_count,
sum(amount) as sum_amount
from transactions
group by date_format (trans_date, '%c %Y'), country)

select a.*, b.trans_count, b.sum_amount
from approved_transaction as a 
JOIN total_transaction as b
on a.month=b.month and a.country=b.country
-- cau 7
select product_id, year as first_year, quantity, price from
(select *,
rank () over (partition by product_id order by year) as rank_year
from sales) as result
where rank_year =1
-- cau 8
select customer_id from
customer 
group by customer_id
having count(distinct(product_key)) = (select count(distinct(product_key)) from product) 
-- cau 9
select a.employee_id
from employees as a
LEFT JOIN employees as b
ON a.manager_id = b.employee_id
where (a.manager_id is not null
and b.employee_id is null
and a.salary < 30000)
-- cau 11
-- cau 12

