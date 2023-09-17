/* This course aims to teach you how to use various GROUP BY extensions: ROLLUP, CUBE, and GROUPING SETS. They are often used to create advanced reports with PostgreSQL.
These extensions to the GROUP BY clause have been added to the ANSI/ISO standard SQL:1999, but they have been available in PostgreSQL since version 9.6.
We assume that you already know a lot about SQL and can put that knowledge into practice. In particular, we assume that you know how to group rows by single or multiple columns and how to calculate aggregate functions: sums, averages, maximum values, etc.

Get to know the tables – contest_score
Let's first get to know the tables that we'll use in this part of the course.
Our examples will be based on a table named contest_score. You can check its contents using the button on the right side of the screen.
This table is used in a TV show in which contestants are given points for tasks in two categories: physical (Workout) and intellectual (Knowledge). scores from 1 to 10 are given over the course of five weeks to five contestants.
This table has the following columns: full_name, week, category, and score.*/
​
SELECT * FROM contest_score;

/*Get to know the tables – delivery
Great! The second table is named delivery; it will be used in our exercises. It is used by a supermarket to keep track of all deliveries.

The table has the following columns:

supplier (the company that delivers the products).
category (such as Toys or Office).
delivery_date (when the products were delivered to the store).
totalprice (how much was paid for the whole delivery).*/

​SELECT * FROM delivery;

/** to know the average score for each TV show contestant over the course of five weeks. */
SELECT
  full_name,
  AVG(score) AS avg_score
FROM contest_score
GROUP BY full_name;

/** How much, in total, was spent on deliveries for each category? */
​SELECT
	category,
	SUM(total_price) as total
FROM delivery
GROUP BY category;

/* Grouping by multiple columns
Great! Okay, we know how well each contestant did in general, but we would also like to know how well 
they did on average in each category. To achieve that, we can add another column to the GROUP BY clause:*/

SELECT
  full_name,
  category, 
  AVG(score) AS avg_score
FROM contest_score
GROUP BY full_name, category;

/** How much, in total, was spent on deliveries for each category on each day? 
Show three columns: category, delivery_date, and the sum of total_price (rename the column total).*/
SELECT
	category,
    delivery_date,
	SUM(total_price) as total
FROM delivery
GROUP BY category,delivery_date;

/* ROLLUP introduction
Good! Now we know how well each contestant did in general (GROUP BY full_name), and also how well 
they did in each category (GROUP BY full_name, category). But note one thing: by adding the 
second column to the GROUP BY clause, we lost some information from the previous query. 
With the GROUP BY full_name, category clause, we know the average scores for each contestant 
in each category, but we are no longer able to check the overall average for each contestant.

That's where GROUP BY ROLLUP comes in handy. Take a look:*/

SELECT
  full_name,
  category, 
  AVG(score) AS avg_score
FROM contest_score
GROUP BY ROLLUP (full_name, category);

/*Note the change in the GROUP BY clause. We added the ROLLUP operator, followed by a pair of parentheses. 
Inside, we put full_name and category. Let's see what changes when we use ROLLUP.

Exercise
Run the template query and note what happens.

Apart from averages by contestant and category, we can also see averages by contestant and an overall average across all contestants and categories.
Great! We see that ROLLUP added two new rows to the query result: overall averages for each contestant and a general overall average for all contestants:

Exercise
Show how much was spent for each category on each day, for each category in general, and for all days and all categories. 
Show the following columns: category, delivery_date, and the sum of total_price (rename the column total).*/

SELECT
	category,
    delivery_date,
	SUM(total_price) as total
FROM delivery
GROUP BY ROLLUP (category,delivery_date);

/* Order of columns in ROLLUP
Excellent. Now, you may have noticed that when we wrote:*/

SELECT
  full_name,
  category, 
  AVG(score) AS avg_score
FROM contest_score
GROUP BY ROLLUP (full_name, category);

we got the following groupings:

Average by full_name and category
Average by full_name
Overall average
In other words, we saw the full_name average, but we didn't see an average for category only. That's because the column order matters in ROLLUP.

Exercise
Run the template query. Note that the order of columns inside the parentheses of ROLLUP has been reversed.

As you can see, we now have the following groupings:

Average by full_name and category
Average by category
Overall average

Perfect! You can see that by reversing the order of the columns inside the ROLLUP's parentheses, we changed one of the groupings.

As a general rule, ROLLUP will always show new grouping combinations by removing columns one by one, starting from the right:

GROUP BY ROLLUP (A, B, C) =
GROUP BY (A, B, C) +
GROUP BY (A, B) +
GROUP BY (A) +
GROUP BY ()
Okay, it's your turn now!

Exercise
Show how much was spent in each category on each day, on each day in general, and in general among all days and categories. 
Show the following columns: category, delivery_date, and the sum of total_price (as total).

SELECT
	category,
    delivery_date,
	SUM(total_price) as total
FROM delivery
GROUP BY ROLLUP (delivery_date,category);

The GROUPING() function
When using multiple columns inside ROLLUP's parentheses, it's quite easy to get lost among the resulting rows. 
SQL offers a function that tells you if the column is included in the grouping: GROUPING().

The GROUPING() function takes one column as an argument. It returns a 0 if the column is used in the grouping and a 1 if it is not. Take a look:

SELECT
  full_name,
  category, 
  week,
  AVG(score) AS avg_score,
  GROUPING(full_name) AS F,
  GROUPING(category) AS C, 
  GROUPING(week) AS W
FROM contest_score
GROUP BY 
  ROLLUP (full_name, category, week);
As you can see, we added three GROUPING() functions in our SELECT clause.
 Inside the parentheses, we put all columns from the parentheses of ROLLUP. Let's see what the result is.'

Exercise
Run the template query. As you can see, integer numbers appear in the final columns, denoting the grouping level for a given row.

Exercise
Show how much was spent, on average: for each supplier, in each category, for each supplier in general; and in general among all suppliers and categories.

Show the following columns: supplier, category, the average total_price (rename the column to avg_price), and two new columns (S and C) 
denoting whether the columns supplier or category are used in the grouping (0 if used, 1 otherwise).

SELECT
	supplier,
	category,
    AVG(total_price) as avg_price,
    GROUPING(supplier) AS S,
  	GROUPING(category) AS C 
FROM delivery
GROUP BY ROLLUP (supplier,category);

Columns outside ROLLUP
Well done! Another thing you may be wondering about is whether you need to include all grouping columns inside the ROLLUP parentheses.
 No, you don't'! You can leave some columns outside ROLLUP:

SELECT
  full_name,
  category, 
  week,
  AVG(score) AS avg_price
FROM contest_score
GROUP BY 
  ROLLUP (full_name, category),
  week;
In the query above, all rows will be grouped by columns not included in ROLLUP. This means that the following grouping levels will be applied:

GROUP BY full_name, category, week
GROUP BY full_name, week
GROUP BY week
Exercise
Run the template query and see what happens.

Columns outside ROLLUP – exercise
Good job! It's' your turn now—try a similar exercise with the delivery table.

Exercise
Show how much was spent on average for each category on each day and on each day in general.
 Show the following columns: category, delivery_date, and the average total_price (name the column avg_price).
 Do not show a single general average among all days and categories.
 
 SELECT
	category,
    delivery_date,
    AVG(total_price) as avg_price
FROM delivery
GROUP BY ROLLUP (category),delivery_date;

Multiple ROLLUPs
Nice! If you need even more fine-grained control over the grouping combinations, you can also use multiple ROLLUPs:

SELECT
  full_name,
  category, 
  week,
  AVG(score) AS avg_score
FROM contest_score
GROUP BY 
  ROLLUP(full_name, category), 
  ROLLUP(week);
The query above will create even more combinations than

ROLLUP(full_name, category, week)
because the grouping options of ROLLUP(full_name, category) and the grouping options of ROLLUP(week) are combined together.
Take a look at the comparison:

Exercise
Run the template query, to see how multiple ROLLUPs work.

