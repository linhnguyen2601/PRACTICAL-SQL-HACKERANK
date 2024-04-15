INTERVAL & TIMESTAMP
SELECT current_date, current_timestamp => trả về ngày giờ hiện tại
select rental_id,
extract(day from return_date - rental_date)*24 + extract(hour from return_date - rental_date) as interval => trả về số giờ thuê
from rental
-- Challenge: Tạo danh sách tất cả thời gian đã thuê của KH với customer_id 35
select rental_id, rental_date, return_date,
return_date - rental_date as interval
from rental
where customer_id=35
-- Khách hàng nào có thời gian thuê trung bình dài nhất
select customer_id,
avg(return_date - rental_date)
from rental
group by customer_id
order by avg(return_date - rental_date) desc

  --ngày nào trong tuần có tổng số tiền thanh toán cao nhất 
select
extract(DOW from payment_date), =>> DOW: day of week
sum(amount)
from payment
group by extract(DOW from payment_date)
order by sum(amount) desc
limit 1 --- ngay thu 5

--số tiền cao nhất mà 1 KH đã chi tiêu trong 1 tuần là bao nhiêu?
select
customer_id,
extract(WEEK from payment_date),
sum(amount)
from payment
group by extract(WEEK from payment_date), customer_id
order by sum(amount) desc
limit 1

TO_CHAR
Hàm Extract chỉ trả ra 1 con số nhưng không trả ra định dạng mong muốn của ngày tháng năm => cần phải sử dụng TO CHAR
select payment_date,
extract (day from payment_date),
TO_CHAR(payment_date,'dd-mm-yyyy' ) (định dạng ngày tháng năm)
TO_CHAR(payment_date,'dd-mm-yyyy hh:mm:ss' ) (định dạng ngày tháng năm giờ phút giây)
from payment

select payment_date,
extract (day from payment_date),
TO_CHAR (payment_date, ‘month’)
From payment

-- INTERVAL & TIMESTAMP
SELECT current_date, current_timestamp --trả về ngày giờ hiện tại
select rental_id,
extract(day from return_date - rental_date)*24 + extract(hour from return_date - rental_date) as interval => trả về số giờ thuê
from rental
--Challenge: Tạo danh sách tất cả thời gian đã thuê của KH với customer_id 35
select rental_id, rental_date, return_date,
return_date - rental_date as interval
from rental
where customer_id=35

  --Khách hàng nào có thời gian thuê trung bình dài nhất
select customer_id,
avg(return_date - rental_date)
from rental
group by customer_id
order by avg(return_date - rental_date) desc
