Bài 1: Xác định dạng của tam giác qua số đo các cạnh:
/% Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:
Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle 
https://www.hackerrank.com/challenges/what-type-of-triangle/problem?isFullScreen=true  %/
select
case when A + B <= C or A+C <= B or C + B <= A then 'Not A Triangle'
        when A=B and B=C then 'Equilateral'
        when (A=B and B != C) or (A=C and A != B) or (B=C and B != A) then 'Isosceles'
        else 'Scalene'
        end category
from Triangles;

Bài 2: Liệt kê danh sách người và vị trí làm việc, tổng hợp số lượng người mỗi ngành nghề theo format có sẵn
https://www.hackerrank.com/challenges/the-pads/problem
Select * from 
(
select concat (name, '(', left(occupation, 1), ')') as people from occupations
order by name asc) as a
union 
select * from
(
select concat ('There are a total of ', count(occupation), ' ', lower(occupation), 's.') from occupations
group by occupation
order by count(occupation), occupation) as b


Bài 3: Sắp xếp tên vào các cột là nghề nghiệp tương ứng
https://www.hackerrank.com/challenges/occupations/problem        
with cte as
(
select name, occupation,
rank() over(partition by occupation order by name) as ratingrank from occupations
order by ratingrank)

select 
max(case when occupation = 'Doctor' then name else null end) as Doctor,
max(case when occupation = 'Professor' then name else null end) as Professor,
max(case when occupation = 'Singer' then name else null end) as Singer,
max(case when occupation = 'Actor' then name else null end) as Actor
from cte
group by ratingrank


Bài 4: Xác định project và sắp xếp theo số ngày hoàn thành 1 projects
https://www.hackerrank.com/challenges/sql-projects/problem 
with cte1 as
(Select Start_Date, End_Date, 
End_date - Dense_Rank() Over (Order By End_Date)  AS Part From Projects),
cte2 as
(select part,
min(Start_date) as start_project_date, max(End_date) as end_project_date from cte1
group by part)
select start_project_date, end_project_date from cte2
order by end_project_date - start_project_date

Bài 5: Xác định xem ai có bạn được offer mức lương cao hơn
https://www.hackerrank.com/challenges/placements/problem?isFullScreen=true
with cte as
(
Select a.id, a.name, b.salary, c.friend_id
from students as a
join packages as b
on a.id=b.id
join friends as c
on a.id=c.id),

cte2 as (
select cte.*, d.salary as friend_salary
from cte as cte
join packages as d
on cte.friend_id = d.id)

select name from cte2
where friend_salary > salary
order by friend_salary

Bai 6:
with cte1 as (
select *,
row_number() over (partition by x,y order by x,y) as rownumber from functions),

cte2 as (
select x, y from cte1
where (x=y and rownumber > 1)
or x !=y)

select b1.*
from cte2 as b1
join cte2 as b2
on b1.x = b2.y
and b1.y = b2.x
where b1.x <= b1.y
order by b1.x

Bai 7:
select a.contest_id, 
a.hacker_id, a.name, 
sum(total_submissions) over (partition by a.hacker_id) as sumtotal_submissions, 
sum(total_accepted_submissions) over (partition by a.hacker_id) as sumaccepted_submissions, 
sum(total_views) over(partition by a.hacker_id) as sum_total_views, 
sum(total_unique_views) over(partition by a.hacker_id) as sum_unique_views
from contests as a
join colleges as b
on a.contest_id = b.contest_id
join Challenges as c
on b.college_id = c.college_id
join view_stats as d
on c.challenge_id = d.challenge_id
join Submission_Stats as e
on e.challenge_id = d.challenge_id

Bai 8: Advanced question (suspicious transactions)
with cte as 
	(
select *,
lead(dt) over(partition by sender order by dt) as next_dt,
lead(dt) over(partition by sender order by dt) - dt as timediff
from crypto_market
	),
	cte2 as (
select *,
row_number() over(partition by sender order by dt)
from cte
where timediff <= interval '1' hour or timediff is null),
	cte3 as (
select * from cte2
where not (row_number=1 and timediff is null)
	)
select min(dt), max(next_dt), sender, max(row_number) as transactions, sum(amount) as total_transaction from cte3
group by sender
having sum(amount) >=150
order by min(dt)
