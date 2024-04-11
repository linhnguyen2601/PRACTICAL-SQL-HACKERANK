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
order by name;/*
-- bai tap 8
Select Name from Employee
where salary > 2000 and months < 10
order by employee_id;
-- bai tap 9
