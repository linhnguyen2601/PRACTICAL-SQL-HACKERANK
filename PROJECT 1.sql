-- Câu 1)	Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING (trim(ordernumber)::integer)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE integer USING (trim(quantityordered)::integer)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE integer USING (trim(orderlinenumber)::integer)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric USING (trim(sales)::numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE timestamp without time zone USING (trim(orderdate)::timestamp without time zone)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN status TYPE text USING (trim(status)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN productline TYPE text USING (trim(productline)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN addressline1 TYPE text USING (trim(addressline1)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN addressline2 TYPE text USING (trim(addressline2)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN productcode TYPE text USING (trim(productcode)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN customername TYPE text USING (trim(customername)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN phone TYPE text USING (trim(phone)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN city TYPE text USING (trim(city)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN state TYPE text USING (trim(state)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN postalcode TYPE text USING (trim(postalcode)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN country TYPE text USING (trim(country)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN territory TYPE text USING (trim(territory)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN contactfullname TYPE text USING (trim(contactfullname)::text)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN dealsize TYPE text USING (trim(dealsize)::text)
-- Câu 2)	Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
select * from sales_dataset_rfm_prj
where ordernumber is null 

-- Câu 3)	Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
-- Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME varchar(50)

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTFIRSTNAME varchar(50)

UPDATE sales_dataset_rfm_prj
set CONTACTFIRSTNAME = left(contactfullname, position('-' in contactfullname) -1)

UPDATE sales_dataset_rfm_prj
set CONTACTLASTNAME = right(contactfullname, length(contactfullname) - position('-' in contactfullname))

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME1 varchar(50)

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTFIRSTNAME1 varchar(50)

UPDATE sales_dataset_rfm_prj
set CONTACTLASTNAME1= CONCAT(upper (left(CONTACTLASTNAME,1)),right(CONTACTLASTNAME,length(CONTACTLASTNAME)-1))

UPDATE sales_dataset_rfm_prj
set CONTACTFIRSTNAME1= CONCAT(upper(left(CONTACTFIRSTNAME,1)),right(CONTACTFIRSTNAME,length(CONTACTFIRSTNAME)-1))

-- Câu 4)	Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID integer

UPDATE sales_dataset_rfm_prj
set QTR_ID = extract(quarter from orderdate)

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN MONTH_ID integer
UPDATE sales_dataset_rfm_prj
set MONTH_ID = extract(month from orderdate)

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN YEAR_ID integer
UPDATE sales_dataset_rfm_prj
set YEAR_ID = extract(year from orderdate)
-- Câu 5)	Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
CREATE TABLE boxplot_outlier as
(
with b as (
select (Q1 -1.5* IQR) as min_value,
(Q3 +1.5* IQR) as max_value from
(select
percentile_cont(0.25) within group (order by quantityordered) as Q1,
percentile_cont(0.75) within group (order by quantityordered) as Q3,
percentile_cont(0.75) within group (order by quantityordered)- percentile_cont(0.25) within group (order by quantityordered) as IQR
from sales_dataset_rfm_prj) as a
	)
select quantityordered from sales_dataset_rfm_prj
where quantityordered< (Select min_value from b) or quantityordered > (select max_value from b)
	)

CREATE TABLE zscore_outlier as 
(
with c as (
select *,
(select avg(quantityordered) from sales_dataset_rfm_prj),
(select stddev(quantityordered) from sales_dataset_rfm_prj)
from sales_dataset_rfm_prj)
select quantityordered, (quantityordered-avg)/stddev as z_score from c
where abs((quantityordered-avg)/stddev)>3)
