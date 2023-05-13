Introduction - CUBE
You learned how to use ROLLUP in the previous part. Here, we will practice CUBE – another GROUP BY extension 
that is mainly used in ETL processes (i.e., when working with data warehouses and creating advanced reports).

Get to know the tables – vaccine_administration

We will use a table named vaccine_administration in our examples. It describes vaccination efficacy in 
various test patients. 
The following columns are available:
id – A unique identifier for each record/row in the table.
location – A patient’s location, either Norway or Argentina.
gender – Denoted as either Male or Female.
risk – The patient’s risk of contracting a disease: Low, Medium, or High.
age – The patient’s age in years.
efficacy – An integer value ranging from 1 (poor vaccination efficacy) to 3 (excellent efficacy).

Get to know the tables – wildfire_incident
Now, let’s take a look at the table that you’ll be querying in the exercises. It is named wildfire_incident 
and it contains the following columns:
id – A unique identifier for each record/row in the table.
year – The year when a given wildfire started: 2016, 2017, or 2018.
month – The month when a given wildfire started: May, June, or July.
cause – Lightning Strike, Arson, Spontaneous Combustion, or Unintentional Human Involvement.
damage_repair_cost – estimated cost to repair the damage caused by a given wildfire.
duration – The number of hours a given wildfire lasted.

Introduction to CUBE
In principle, ROLLUP and CUBE are similar. The difference is that CUBE does not remove columns from the right to create grouping levels. 
Instead, it creates every possible grouping combination based on the columns inside its parentheses. Take a look:

SELECT
  location, 
  gender, 
  risk, 
  AVG(age) AS avg_age
FROM vaccine_administration
GROUP BY CUBE (location, gender, risk);
Syntax-wise, we only replaced ROLLUP with CUBE. Let’s see what result we’ll get.

Exercise
Run the template query and note how many grouping levels are created.

Introduction to CUBE – exercise
As you could see, the following rows were created:

GROUP BY CUBE(location, gender, risk) =
GROUP BY location, gender, risk +
GROUP BY location, gender +
GROUP BY gender, risk +
GROUP BY location, risk +
GROUP BY location +
GROUP BY gender +
GROUP BY risk +
GROUP BY ()
Quite a lot! For n columns passed in as parameters, CUBE creates  2^n grouping levels, 
while ROLLUP only creates n+1 levels:

No.columns	No.grouping levels
			ROLLUP	CUBE
1				2	2
2				3	4
3				4	8
4				5	16
5				6	32
6				7	64
You need to be aware that CUBE can significantly lower the performance of your queries. As few as 
three columns in CUBE create eight different types of groupings. Even though a query with CUBE is 
faster than separate grouping queries merged with UNION, performance can still be an issue for large tables.

Exercise
Show the sum of damage_repair_cost (as sum_damage_repair_cost) for all possible grouping combinations 
based on the year, month, and cause columns.

Show the following columns in the query result: year, month, cause, and sum_damage_repair_cost.
SELECT
	year,
    month,
    cause,
    sum(damage_repair_cost)as sum_damage_repair_cost
FROM  wildfire_incident
GROUP BY CUBE(year,month,cause)

Order of Columns in CUBE
Good job! CUBE creates all possible grouping combinations. This means that, unlike ROLLUP, CUBE does 
not change the query result when the order of columns inside the parentheses is changed.

CUBE with GROUPING()- Exercise
Show the average damage repair cost for all possible combinations of year, month, and cause. 
Remove the row containing the total average from the results with the help of the GROUPING() function.

Show the following columns in the query result: year, month, cause, and avg_cost.
SELECT
	year,
    month,
    cause,
    avg(damage_repair_cost)as avg_cost
FROM  wildfire_incident
GROUP BY CUBE(year,month,cause)
HAVING (GROUPING(year) + GROUPING(month) + GROUPING(cause) < 3)

Columns outside CUBE
Good job! Now, if we want to reduce the number of grouping combinations, we can exclude some columns from CUBE:

SELECT
  location,
  gender,
  risk,
  MIN(efficacy) AS min_efficacy
FROM vaccine_administration
GROUP BY 
  CUBE (location, gender), risk;
In the query above, CUBE will create grouping combinations for location and gender, 
but risk will be added to each grouping combination. As a result, we’ll get the following levels:

GROUP BY CUBE (location, gender), risk =
GROUP BY location, gender, risk +
GROUP BY location, risk +
GROUP BY gender, risk +
GROUP BY risk
Exercise
Run the template query and note that risk is now always used for grouping.

Exercise
Show the average wildfire duration for all grouping combinations based on the year and month columns. 
Also, group each row by cause.
Show the following columns in the query result: year, month, cause, and avg_duration.
SELECT
	year, 
    month, 
    cause, 
    avg(duration) AS avg_duration
FROM wildfire_incident
GROUP BY CUBE(year, month), cause

CUBE with multiple pairs of parentheses
Good! There is one more interesting modification of CUBE worth mentioning. Take a look:

SELECT
  location,
  gender,
  risk,
  AVG(age) AS avg_age
FROM vaccine_administration
GROUP BY 
  CUBE ((location, gender), risk);
Inside CUBE''s parentheses, we put location and gender in another pair of parentheses! 
This means that location and gender will be treated as a single column – 
either both or neither of them will be used for grouping:

GROUP BY CUBE((location, gender), risk) =
GROUP BY location, gender, risk +
GROUP BY location, gender +
GROUP BY risk +
GROUP BY ()
Exercise
Run the template query. Note that each row is grouped by either location and gender together 
or by neither of these columns.

CUBE with multiple pairs of parentheses – exercise

Show the sum of damage_repair_cost for grouping combinations based on the columns year, month, and cause.
 Treat year and month as a single column.
Show the following columns in the query result: year, month, cause, and sum_damage_repair_cost.

SELECT
	year, 
    month, 
    cause, 
    sum(damage_repair_cost) AS sum_damage_repair_cost
FROM wildfire_incident
GROUP BY CUBE((year, month), cause)

CUBE with COALESCE()
Great! Lastly, the function COALESCE() can be used in the SELECT clause to replace NULL values with the values of your choice:

SELECT
  COALESCE(location, '--') AS location,
  COALESCE(gender, '--') AS gender,
  COALESCE(risk, '--') AS risk,
  AVG(age) AS avg_age
FROM vaccine_administration
GROUP BY 
  CUBE (location, gender, risk);
In the query above, '--' will be shown when location, gender, or risk is NULL.

Exercise
Show the average damage repair costs for all grouping combinations based on the year and month columns. 
Group all rows by cause. Replace any NULL values in month with the word 'ALL'.
Show the following columns in the query result: year, month, cause, and avg_damage_repair_cost.

SELECT
	year, 
    COALESCE(month, 'ALL') AS month, 
    cause, 
    AVG(damage_repair_cost) AS avg_damage_repair_cost
FROM wildfire_incident
GROUP BY CUBE(year, month), cause

we’ll be using a small table named customer_order. The following columns are available:
 id, country, customer, customization, and total_price. 
 
Exercise
Find the average total price in all grouping combinations made from the following columns: 
country, customer, and customization.

Show the following columns in the query result: country, customer, customization, and avg_price.
SELECT 
	country, 
    customer,
    customization,
	AVG(total_price) AS avg_price
FROM  customer_order
GROUP BY CUBE(country,customer,customization)

Exercise
Find the maximum total price in all grouping combinations based on the country and customer columns. 
Group all rows by the customization column. Instead of NULLs in the country and customer columns, 
show a double dash (--) in the country and customer columns.

Show the following columns in the query result: country, customer, customization, and max_total_price.
SELECT 
	COALESCE(country,'--')AS country, 
    COALESCE(customer,'--')AS customer,
    customization,
    MAX(total_price) AS max_total_price
FROM  customer_order
GROUP BY CUBE(country, customer), 
  customization;
  
 Summary
Great! It’s time to wrap things up.

GROUP BY CUBE () creates all possible grouping combinations with the columns inside its parentheses.
The order of columns within the parentheses of CUBE doesn''t matter.
You can use the GROUPING() function to show if the column is included in the grouping.
You can leave some columns outside CUBE. Such columns will always be used for grouping.
You can use additional pairs of parentheses inside CUBE to indicate that certain columns should be treated as a single column by the CUBE clause.
You can use COALESCE() to replace NULL values with something more meaningful. 
