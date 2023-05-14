Introduction

So far, you''ve learned how to use CUBE and ROLLUP for advanced reporting purposes. 
This time, we''ll present GROUPING SETS – the third and last GROUP BY extension in this course.

Get to know the warranty_repair table

We''ll use a table named warranty_repair in our examples. It has the following columns:

id – the ID of the repair.
customer_id – the ID of the customer who ordered a given repair.
repair_center – denotes which warranty center repaired the device (USA, Germany, or Japan).
date_received – the date when the repair center received the device for repair.
repair_duration – the number of days it took to repair the device.
repair_cost – the USD cost of spare parts used to repair the device (0 in the case of software problems).

Get to know the loan table
it contains information on loans made by an imaginary bank to imaginary clients.

id – the ID of the loan.
client_id – the ID of the client.
sales_person – the first and last name of the sales person.
country – the country where the loan was made.
year – the year in which the loan was taken out.
quarter – the yearly quarter when the loan was taken out.
principal – the amount borrowed.
interest – the interest rate on the loan.

Multiple grouping with UNION ALL

Imagine that you need to create a report on the average repair duration for two grouping levels:

per customer_id and repair_center.
per date_received date.
You don''t want to create any additional grouping levels because you need the report to stay clear and simple.

There is no way you could use either ROLLUP or CUBE to create those grouping levels. 
One thing you could do is write two separate queries and join them with UNION ALL:

SELECT
  NULL AS date_received, 
  customer_id, 
  repair_center, 
  AVG(repair_duration) AS avg_repair_duration
FROM warranty_repair
GROUP BY customer_id, repair_center
UNION ALL
SELECT
  date_received, 
  NULL, 
  NULL, 
  AVG(repair_duration) AS avg_repair_duration
FROM warranty_repair
GROUP BY date_received
Note that UNION ALL requires both queries to have the same number of columns. 
This is why we needed to add some NULLs as columns in the SELECT clause.

Exercise
Run the template query to see how it works.

Multiple grouping with UNION ALL – practice

Exercise
Find the average principal amounts for the following two grouping combinations:
year and quarter
country
Show the following columns in the query result: year, quarter, country, and avg_principal.

SELECT
  year,
  quarter,
  NULL AS country,
  AVG(principal) AS avg_principal
FROM loan
GROUP BY year, quarter
UNION ALL
SELECT
  NULL AS year,
  NULL AS quarter,
  country,
  AVG(principal)
FROM loan
GROUP BY country;

Multiple groupings with GROUPING SETS
Good job! As you saw, using UNION ALL is one way of dealing with such reports, but it seems to cause all kinds of problems:

The statement becomes huge as more queries are added with UNION ALL
The table has to be accessed multiple times, which affects performance
Adding NULL values in the SELECT clause is awkward and error prone
That''s where GROUPING SETS come in handy. They allow you to perform multiple groupings within a single query;
 each grouping is explicitly stated, as we see below:

SELECT
  date_received, 
  customer_id,   
  repair_center, 
  AVG(repair_duration) AS avg_repair_duration
FROM warranty_repair
GROUP BY GROUPING SETS
(
  (customer_id, repair_center),
  (date_received)
)
As you can see, GROUP BY GROUPING SETS is followed by a pair of parentheses. Inside, we put all the grouping combinations 
we wish to get, each in a separate pair of parentheses and separated by a comma.

Exercise
Run the template query. Note how two different grouping levels are created.

Exercise
Rewrite the template query so it uses GROUPING SETS instead of UNION ALL.
SELECT
  year,
  quarter,
  country,
  AVG(principal) AS avg_principal
FROM loan
GROUP BY GROUPING SETS(
  (year, quarter),
  (country)
)
Using an empty grouping set
Well done! Let''s say we also need to add the general average repair duration to our report. 
To that end, we can use an empty pair of parentheses:

SELECT
  date_received, 
  customer_id, 
  repair_center, 
  AVG(repair_duration) AS avg_repair_duration
FROM warranty_repair
GROUP BY GROUPING SETS
(
  (customer_id, repair_center),
  (date_received),
  ()
)
Exercise
Run the template query. As you can see, a row with a general average was added.

Exercise
Find the average principal (as avg_principal) and average interest (as avg_interest) for the following grouping combinations:
year and quarter
country
None (overall averages)

SELECT
	year,
    quarter,
    country,
    AVG(principal) AS avg_principal,
    AVG(interest) AS avg_interest
FROM  loan
GROUP BY GROUPING SETS
(    
    (year, quarter),
    (country),
    ()
)

GROUPING SETS with GROUPING()
Great! Of course, GROUPING SETS works with the GROUPING() function too:

SELECT
  date_received,
  customer_id,
  repair_center,
  AVG(repair_duration) AS avg_repair_duration,
  GROUPING(date_received) AS D,
  GROUPING(customer_id) AS C,
  GROUPING(repair_center) AS R
FROM warranty_repair
GROUP BY GROUPING SETS
(
  (customer_id, repair_center),
  (date_received)
)
Exercise
Find the average interest amounts for the following grouping levels:

year and quarter
country
Show the following columns in the query result: year, quarter, country, avg_interest,
 Y, Q, and C. The Y, Q, and C columns show if the columns year, quarter, and country were used in the grouping.
 
 SELECT
	year,
    quarter,
    country,
    AVG(interest) AS avg_interest,
    GROUPING(year) AS Y,
  	GROUPING(quarter) AS Q,
  	GROUPING(country) AS C
FROM  loan
GROUP BY GROUPING SETS
(    
    (year, quarter),
    (country)
)

GROUPING SETS with COALESCE()
Nice job!

What can we do with those NULL values? Naturally, we can use COALESCE():

SELECT
  date_received,
  customer_id,
  COALESCE(repair_center, 'ALL'),
  AVG(repair_duration) AS avg_repair_duration
FROM warranty_repair
GROUP BY GROUPING SETS
(
  (customer_id, repair_center),
  (date_received)
)
In the query above, any NULL values in the repair_center column will be replaced with the word ALL.

Exercise
Show the sum of all principal amounts for two grouping sets: sales_person, country
Show the following columns in the query result: sales_person, country, and Sumprincipal.
Instead of NULL values in the columns sales_person and country, show a double dash (--).
 SELECT
	COALESCE(sales_person,'--') as sales_person,
    COALESCE(country, '--') as country,
    Sum(principal) as Sumprincipal
FROM  loan
GROUP BY GROUPING SETS
(    
   sales_person,country
)

GROUPING SETS with ROLLUP and CUBE
Good job! One more interesting thing we can do with GROUPING SETS is combine them with ROLLUP or CUBE:

SELECT
  date_received,
  customer_id,
  repair_center,
  AVG(repair_duration) AS avg_repair_duration
FROM warranty_repair
GROUP BY GROUPING SETS
(
  ROLLUP (customer_id, repair_center),
  (date_received)
)
The query above will merge ROLLUP grouping levels with a grouping level based on date_received. As a result, we''ll get the following grouping combinations: PIC
Exercise
Run the template query and note how many grouping levels are created.

GROUPING SETS with ROLLUP and CUBE – practice
How about trying this exercise?

Exercise
Show the average interest amounts for the following grouping sets: ROLLUP by year and quarter,country
Show the following columns in the query result: year, quarter, country, and avg_interest.
 SELECT
	year,
    quarter,
    country,
    AVG(interest) AS avg_interest
FROM  loan
GROUP BY GROUPING SETS
(    
   ROLLUP(year, quarter),
    (country)
)
Exercise 1
In this quiz, we''re going to use a table named fruit_harvest. It has the following columns:

id – the ID of the harvest.
site – the ID of the harvest site.
year – the year of the harvest.
weather – either Fair or Poor. There are two harvests yearly, one in the high season (fair weather) and another in the low season (poor weather).
amount – the amount of fruit harvested.
All right, let''s take a look at the first question.

Exercise
Show the average amount of fruit harvested for the following grouping sets: site and year, weather
Show the following columns in the query result: site, year, weather, and avg_amount. Replace all NULLs in the site and weather columns with the word ALL.
SELECT
	COALESCE(site,'ALL') AS site, 
    year, 
    COALESCE(weather,'ALL') AS weather,
    avg(amount) AS avg_amount
FROM fruit_harvest
GROUP BY GROUPING SETS
(
    (site,year),
	weather
)  
Exercise
Show the total amount of the harvest for the following grouping sets: ROLLUP with site and year, weather
Show the following columns in the result: site, year, weather, and total_amount.
SELECT
	site, 
    year, 
    weather, 
    SUM(amount) as total_amount
FROM fruit_harvest
GROUP BY GROUPING SETS
(
  ROLLUP(site,year),
  	weather
)  


Summary
Good job! It''s time to wrap things up.

GROUP BY GROUPING SETS( ) works by creating the grouping levels provided explicitly within its parentheses.
You can use a pair of empty parentheses ( ) to introduce a general average, sum, etc.
The GROUPING SETS extension can be combined with COALESCE().
You can use both ROLLUP and CUBE to create even more sophisticated grouping combinations.