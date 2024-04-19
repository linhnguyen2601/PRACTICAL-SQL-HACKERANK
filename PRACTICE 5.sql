-- bai tap 1: query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer
select b.continent, floor(avg(a.population))
from city as a
JOIN country as b
on a.countrycode = b.code
group by b.continent
-- bai tap 2: Write a query to find the activation rate. Round the percentage to 2 decimal places.
SELECT ROUND(count(a.signup_action='confirmed')/count(*),2)
from texts as a
JOIN emails as b 
ON a.email_id=b.email_id
