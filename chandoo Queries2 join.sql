SELECT * FROM sales;
SELECT * FROM people;
SELECT * FROM products;
SELECT s.SaleDate, s.Amount, p.Salesperson,s.SPID, p.SPID
FROM sales s
JOIN people p on p.SPID = s.SPID;

-- join with product table
SELECT s.saledate, s.amount,  pr.product
FROM Sales s
LEFT JOIN products pr on pr.PID= s.PID; 
-- if there is a PID in sales that doesnot have a matching PID in product, it will still showup, but product name will be blank--

SELECT s.SaleDate, s.Amount, p.Salesperson, p.team, pr.product
FROM sales s
JOIN people p on p.SPID = s.SPID
JOIN products pr on pr.PID= s.PID ;
-- Conditions with join
SELECT s.SaleDate, s.Amount, p.Salesperson, p.team, pr.product
FROM sales s
JOIN people p on p.SPID = s.SPID
JOIN products pr on pr.PID= s.PID 
where s.amount < 500 
and p.Team = 'Delish';

SELECT s.SaleDate, s.Amount, p.Salesperson, p.team, pr.product
FROM sales s
JOIN people p on p.SPID = s.SPID
JOIN products pr on pr.PID= s.PID 
where s.amount < 500 
and p.Team = '';  -- IS Null
-- join with geog either ne zeland or india
Select * from geo;
Select * 
from sales s
JOIN Geo g on g.geoid= s.geoid
-- where g.geo = 'India' or g.geo = 'New Zealand'
where g.geo in ('India','New Zealand')
order by saledate;

