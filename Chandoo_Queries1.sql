-- USE awesome chocolates;
show tables;
describe sales;
-- Ctrl+Enter to execute
select * from sales;

select SaleDate, Amount, Customers from sales;

SELECT	SaleDate, Amount, boxes, Amount/Boxes from sales;
SELECT	SaleDate, Amount, boxes, Amount/Boxes 'Amount per box' from sales; -- Alias
SELECT	SaleDate, Amount, boxes, Amount/Boxes as 'Amount per box' from sales;

SELECT * from sales
WHERE amount > 10000
ORDER BY amount desc;

SELECT * from sales
WHERE geoid = 'g1' -- filter
ORDER BY PID, amount desc; -- sort; -- double sort

-- Value>10000 & year = 2022
SELECT * from sales
WHERE Amount > 10000 AND saledate > '2022-01-01'; -- coz we only have values in 21 &22 no 23
-- YEAR function
SELECT * from sales
WHERE Amount > 10000 AND year(saledate) = 2022 -- year returns a no. so you dont need ''
ORDER BY amount desc;

-- No of boxes b/w 0 to 50
SELECT * from sales
WHERE boxes > 0 and Boxes <=50;

SELECT * from sales
WHERE boxes between 0 and 50;
 -- b/w fn is inclusive, includes both 0 and 50. no brackets, use and
 
-- find all shipments happening on FRidays - WEEKDAY fn (Monday - 1)
SELECT SaleDate, Amount, boxes,  weekday(saledate) AS 'Day of week'  from sales
WHERE weekday(saledate) = 4;

-- Working with multiple tables
-- Either Delish or Jucies team
SELECT * FROM people
WHERE team = 'Delish' OR Team = 'Jucies';
-- IN
SELECT * FROM people
WHERE team in ('Delish', 'Jucies'); -- Text values in '', in operator (,)

-- LIKE (Pattern matching)
SELECT * FROM people
-- WHERE Salesperson LIKE 'b%' -- anything that begins with b
WHERE Salesperson LIKE '%b%'; -- anything that has b in it 

-- case operator
SELECT * FROM sales;

-- Amt category as column, any amt upto $1000 having label of under 1000,
-- 1000 to 5000 under 5000, 5000 to 10k under 10k, else 
SELECT SaleDate, Amount, 
	case	when amount < 1000 then 'Under 1K'
			when amount < 5000 then 'Under 5K'
            when amount < 10000 then 'Under 10K'
		else '10K or more'
	end as 'Amount Category'
    from sales;
    

    
            


 



