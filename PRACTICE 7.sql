-- cau 1
With sum_extract AS
(SELECT product_id, 
extract(year from transaction_date),
sum(spend) 
FROM user_transactions
group by product_id,extract(year from transaction_date)
)
select extract as year, 
product_id,
sum as current_year_spend,
previous_spend,
round((sum-previous_spend)/previous_spend*100,2) as YOY_growth_rate
FROM
(
select *,
LAG(sum) OVER(PARTITION by product_id order by extract) as previous_spend
from sum_extract) as result
order by product_id,extract
-- cau 2
select card_name, issued_amount from (
SELECT *,
RANK() OVER(PARTITION BY card_name ORDER BY
MAKE_DATE(issue_year, issue_month, 1))
FROM monthly_cards_issued) as a   
where rank =1
order by issued_amount DESC
-- cau 3
SELECT user_id, spend,transaction_date FROM
(SELECT *,
RANK() OVER (PARTITION BY user_id ORDER BY transaction_date) as rank
FROM transactions) as result
where rank =3
-- cau 4
select transaction_date, user_id, COUNT
FROM(
SELECT user_id, count(product_id), transaction_date,
rank() over(PARTITION BY user_id order by transaction_date DESC)
FROM user_transactions
group by user_id, transaction_date) as a  
where rank =1
order by transaction_date
-- cau 5
-- cau 6
SELECT count(*) 
from (
select transaction_id, 
EXTRACT(EPOCH FROM transaction_timestamp - lag)/60 as time_span
FROM (
SELECT *,
LAG (transaction_timestamp) 
OVER(PARTITION BY merchant_id, credit_card_id, amount order by transaction_timestamp)
FROM transactions) as a
where EXTRACT(EPOCH FROM transaction_timestamp - lag)/60 <=10) as b  
-- cau 7
SELECT category, product, total_spend
FROM (
SELECT category, product, SUM(spend) as total_spend,
RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC)
from product_spend
where transaction_date between '01-01-2022' and '01-01-2023'
group by (category, product)
) as result
where rank < 3
-- cau 8
select * from (
select c.artist_name,
dense_rank() over(order by COUNT(*) DESC) as top_artist
from songs as a
JOIN global_song_rank as b
on a.song_id=b.song_id
JOIN artists as c  
on a.artist_id = c.artist_id
where rank <=10
group by c.artist_name) as a  
where top_artist <=5
