-- Doanh thu theo từng ProductLine, Year  và DealSize
select productline, year_id, dealsize,
sum(quantityordered*priceeach) as revenue
from public.sales_dataset_rfm_prj
  where status='Shipped'
group by productline, year_id, dealsize
order by productline, year_id,dealsize

  --  Đâu là tháng có bán tốt nhất mỗi năm?
with a as (
select year_id, month_id,
sum(quantityordered*priceeach) as revenue
from public.sales_dataset_rfm_prj
where status='Shipped'
group by year_id, month_id
order by year_id, month_id)
,b as (
select *,
rank() over(partition by year_id order by revenue desc) as order_number
from a)
select CONCAT(year_id,'-',month_id) as month_id, revenue, order_number  from b
where order_number =1

  --Product line nào được bán nhiều ở tháng 11?
with a as (
select year_id, month_id, productline,
sum(quantityordered*priceeach) as revenue
from public.sales_dataset_rfm_prj
where status='Shipped' and month_id=11
group by year_id, month_id,productline
order by year_id, month_id)
,b as (
select *,
rank() over(partition by year_id order by revenue desc) as order_number
from a)
select CONCAT(year_id,'-',month_id) as month_id, revenue, productline, order_number  from b
where order_number =1

-- Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
