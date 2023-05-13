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
Show how much was spent for each category on each day, for each category in general, and for all days and all categories. Show the following columns: category, delivery_date, and the sum of total_price (rename the column total).