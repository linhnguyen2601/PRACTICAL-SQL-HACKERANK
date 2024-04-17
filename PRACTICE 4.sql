-- bai tap 1 -calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership.
SELECT
sum(case
when device_type = 'laptop' then 1 else 0 end) as laptop_view,
sum(case 
when device_type in ('tablet','phone') then 1 else 0 end) as mobile_view
FROM viewership;
-- bai tap 2
select x,y,z,
case when x+y> z and y+z>x and z+x>y then 'Yes' else 'No' end triangle 
from triangle
-- bai tap 3
-- bai tap 4
Select name from Customer
where referee_id <> 2 or referee_id is null;
