/* Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
The STATION table is described as follows:*/
select count(id)-count(distinct city)
from station;

/*Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
The STATION table is described as follows:https://s3.amazonaws.com/hr-challenge-images/9336/1449345840-5f0a551030-Station.jpg*/
select city, LENGTH(city)
from station
order by LENGTH(city),city
limit 1;
select city, LENGTH(city)
from station
order by LENGTH(city) desc,city
limit 1;


-- Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
select distinct city from station
where (city like 'a%' or city like 'e%' or city like 'i%' or city like 'o%' or city like 'u%');
-- %% city like 'a%' or city like
SELECT distinct CITY
FROM STATION
WHERE (CITY LIKE 'a%') OR (CITY LIKE 'e%') OR (CITY LIKE 'i%') OR (CITY LIKE 'o%') OR (CITY LIKE 'u%')
ORDER BY CITY;

-- Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
select distinct city from station
where (city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u');


--Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
select distinct city from station
where (city like 'a%a' or city like 'e%e' or city like 'i%i' or city like 'o%o' or city like 'u%u');
SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP  '^[aeiou].*[aeiou]$' ;