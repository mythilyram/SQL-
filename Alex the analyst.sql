CREATE SCHEMA alex_yt_employee;
# Table 1 Query:
Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
);

# Table 2 Query:
Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
);



# Table 1 Insert:
Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male');

# Table 2 Insert:
Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000);
-- ----------------------------------------------------------------------------
/*
Today's Topic: Subqueries (in the Select, From, and Where Statement)
*/
Select EmployeeID, JobTitle, Salary
From EmployeeSalary;

-- Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary;

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary;

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID;


-- Subquery in From

Select a.EmployeeID, AllAvgSalary # temptable or CTE is much prefered method.
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmployeeID;


-- Subquery in Where

# If subquery in WHERE, you can have only 1 column selected.
Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30);
    
    -- ------------------------------------------------------------------------
# CTE
WITH CTE_Employee as
(SELECT FirstName, LastName, Gender, Salary,
COUNT(gender) OVER (PARTITION by Gender) as TotalGender,
AVG(salary) OVER (PARTITION by Gender) as AvgSalary
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
WHERE Salary > '45000'
)
Select FirstName, Avgsalary 
FROM CTE_Employee;

-- -----------------------------------------------------------
CREATE TEMPORARY TABLE temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
);

/*Create table #temp_employee2 (
EmployeeID int,
JobTitle varchar(100),
Salary int
);*/

Select * From temp_employee;

Insert into temp_employee values (
'1001', 'HR', '45000'
); 

Insert into temp_employee
SELECT * From EmployeeSalary;

Select * From temp_employee;



DROP TABLE IF EXISTS temp_employee3;
Create TEMPORARY table temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
);


Insert into temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle;

Select * 
From temp_employee3;

SELECT AvgAge * AvgSalary
from temp_employee3;
-- ------------------------------------------------------------------------
 /*

Today's Topic: String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

*/

-- Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
);

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired');

Select *
From EmployeeErrors;

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors ;

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors ;

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors ;


-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors;


-- Using Substring
Select Substring(err.FirstName,1,3)
FROM EmployeeErrors err;

Select Substring(err.FirstName,2,4)
FROM EmployeeErrors err;

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3),
 Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3);



-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors;

Select Firstname, UPPER(FirstName)
from EmployeeErrors;

/*
Today's Topic: Stored Procedures
*/

CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee
GO;




CREATE PROCEDURE Temp_Employee2 
@JobTitle nvarchar(100)
AS
DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
where JobTitle = @JobTitle --- make sure to change this in this script from original above
group by JobTitle

Select * 
From #temp_employee3
GO;


exec Temp_Employee2 @jobtitle = 'Salesman'
exec Temp_Employee2 @jobtitle = 'Accountant'    