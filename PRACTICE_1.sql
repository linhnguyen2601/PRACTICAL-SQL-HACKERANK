--bai tạp 1
Select Name from City
where countrycode = 'USA' and Population > 120000;
-- bai tap 2
Select * from City
where countrycode = 'JPN';
-- bai tap 3
Select City, State from Station
-- bai tap 4
Select City from Station
Where City Like 'a%' or city like 'e%' or city like 'i%' or city like 'o%' or city like 'u%';
-- bai tap 5
Select distinct City from Station
where city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u';
-- bai tap 6
Select distinct City from Station
Where Not (City Like 'a%' or city like 'e%' or city like 'i%' or city like 'o%' or city like 'u%');
--bai tap 7
select name from employee
order by name;
-- bai tap 8
Select Name from Employee
where salary > 2000 and months < 10
order by employee_id;
-- bai tap 9
Select product_id from Products
where low_fats = 'Y' and recyclable = 'Y';  
-- bai tap 10
Select name from Customer
where referee_id <> 2 or referee_id is null;
-- bai tap 11
Select name, population, area from World
where area > 3000000 or population >= 25000000;
-- bai tap 12
select distinct author_id AS id from Views
where author_id = viewer_id
order by author_id;
-- bai tap 13
SELECT part, assembly_step FROM parts_assembly
where finish_date is NULL;
-- bai tap 14
select * from lyft_drivers
where not yearly_salary between 30000 and 70000;
-- bai tap 15
select advertising_channel from uber_advertising
where year = 2019 and money_spent > 100000;
