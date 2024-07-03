-- 1. CREATE TABLE AND IMPORT DATA
create table SALES_DATASET_RFM_PRJ
(
  ordernumber VARCHAR,
  quantityordered VARCHAR,
  priceeach        VARCHAR,
  orderlinenumber  VARCHAR,
  sales            VARCHAR,
  orderdate        VARCHAR,
  status           VARCHAR,
  productline      VARCHAR,
  msrp             VARCHAR,
  productcode      VARCHAR,
  customername     VARCHAR,
  phone            VARCHAR,
  addressline1     VARCHAR,
  addressline2     VARCHAR,
  city             VARCHAR,
  state            VARCHAR,
  postalcode       VARCHAR,
  country          VARCHAR,
  territory        VARCHAR,
  contactfullname  VARCHAR,
  dealsize         VARCHAR
) 

-- 2. CHANGE DATA TYPE
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN ordernumber TYPE integer USING ordernumber::integer,
ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer,
ALTER COLUMN priceeach TYPE float USING priceeach::double precision,
ALTER COLUMN orderlinenumber TYPE integer USING orderlinenumber::integer,
ALTER COLUMN sales TYPE float USING sales::double precision,
ALTER COLUMN orderdate TYPE date USING orderdate::date,
ALTER COLUMN msrp TYPE integer USING msrp::integer

-- 3. Check Null/Blank
select * from public.sales_dataset_rfm_prj
where ordernumber is null

select * from public.sales_dataset_rfm_prj
where quantityordered is null

select * from public.sales_dataset_rfm_prj
where priceeach is null

select * from public.sales_dataset_rfm_prj
where orderlinenumber is null

select * from public.sales_dataset_rfm_prj
where sales is null

select * from public.sales_dataset_rfm_prj
where orderdate is null

-- 4. ADD CONTACTLASTNAME, CONTACTFIRSTNAME WHICH ARE EXTRACTED FROM CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN first_name varchar,
ADD COLUMN last_name varchar

UPDATE sales_dataset_rfm_prj
SET first_name = left(contactfullname, position('-' in contactfullname) -1),
	last_name = right(contactfullname, length(contactfullname) - position('-' in contactfullname))

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN contactfirstname varchar,
ADD COLUMN contactlastname varchar

UPDATE sales_dataset_rfm_prj
SET contactfirstname = concat(upper(left(first_name,1)),right(first_name, length(first_name)-1)),
	contactlastname = concat(upper(left(last_name,1)),right(last_name, length(last_name)-1))

ALTER TABLE sales_dataset_rfm_prj
DROP first_name,
DROP last_name

-- 5. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN year_id integer,
ADD COLUMN qtr_id integer,
ADD COLUMN month_id integer

UPDATE sales_dataset_rfm_prj
set year_id = extract(year from orderdate),
	qtr_id = extract(quarter from orderdate),
	month_id = extract(month from orderdate)
	
-- 6. CHECK OUTLIERS
-- Cách 1: IQR
with cte as 
	(
select percentile_cont(0.25) within group (order by quantityordered) as Q1, 
	percentile_cont(0.75) within group (order by quantityordered) as Q3, 
	percentile_cont(0.75) within group (order by quantityordered) - 
	percentile_cont(0.25) within group (order by quantityordered) as IQR
	from sales_dataset_rfm_prj),
cte2 as
	(
select Q1 - 1.5*IQR as min_value,
		Q3 + 1.5*IQR as max_value from cte)
select quantityordered from sales_dataset_rfm_prj
where quantityordered < (select min_value from cte2)
or quantityordered > (select max_value from cte2)

-- Cách 2: Z-Score
with cte as
	(
select *,
(select avg(quantityordered) from sales_dataset_rfm_prj),
(select stddev(quantityordered) from sales_dataset_rfm_prj)
from sales_dataset_rfm_prj)

select quantityordered, (quantityordered - avg)/stddev as z_score from cte
where abs((quantityordered - avg)/stddev) > 3

--7. CREATE NEW TABLE: SALES_DATASET_RFM_PRJ_CLEAN
CREATE TABLE sales_dataset_rfm_clean as 
	
with cte as
	(
select *,
(select avg(quantityordered) from sales_dataset_rfm_prj),
(select stddev(quantityordered) from sales_dataset_rfm_prj)
from sales_dataset_rfm_prj)

select * from cte
where abs((quantityordered - avg)/stddev) <= 3
