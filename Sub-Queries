	53. Introduction
	We'll start with simple, uncorrelated subqueries. (We'll revisit correlated subqueries later in this part.) Here's a brief reminder:
	A subquery is a query within another query.
	We can use subqueries in the WHERE clause to compare a given column with the result of a whole query. When comparing with the result of the subquery, you can use comparison operators by themselves:
	SELECT cat_id
FROM cats
WHERE age > (SELECT age FROM cats WHERE cat_name = 'Kitty')
	or comparison operators with the ANY or ALL keywords, if your subquery can return multiple rows:
	SELECT cat_id
FROM cats
WHERE age > ANY(SELECT age FROM cats WHER E cat_name = 'Kitty')
	or the operator IN, if the value of the column compared with the subquery has to be in the result of particular subquery, e.g.
	SELECT cat_id
FROM cats
WHERE age IN(SELECT age FROM cats WHERE cat_name LIKE 'K%')
	We can also use the subqueries in the FROM clause, and filter our rows in this way. The subquery in the FROM clause has to have an alias.
	SELECTMAX(number_of_cats)
FROM(SELECTbreed,
    COUNT(*) ASnumber_of_cats
  FROMcat
  GROUPBYbreed) breed_count
	
	54. Get to know the orchestras table	select * FROM Orchestras
	id  	name	                      rating	city_origin	   country_origin	year
	1	  Cair Symphonic Orchestra	    7.2	  Cair	        Egypt	1959
	2 	The Great Symphony Orchestra	9.4	    New York	    USA	1922
	3 	Court Orchestra             	8.6	   Mannheim	      Germany	
  
	• id – the ID of the orchestra.
	• name – the name of the orchestra.
	• rating – the rating of the orchestra over the last ten years.
	• city_origin – the city from which the orchestra originates.
	• country_origin – the country of origin of the orchestra.
	• year – year in which the orchestra was created.
  
	55. Get to know the concerts table	select * FROM concerts
	id	city	country	year	rating	orchestra_id
	1	Phnom Penh	Cambodia	2003	9.3	5
	2	Tehran	Iran	2014	9.2	1
	3	Port Vila	Vanuatu	2008	7.0	1
	• id – the ID of the concert.
	• city – the name of the city where the concert took place.
	• country – the name of the country where the concert took place.
	• year – the year in which the concert was performed.
	• rating – the rating (by critics) of the concert.
	• orchestra_id – the ID of the orchestra that performed at the concert.
  
	56. Get to know the members table	select * FROM Members
id	name	position	experience	orchestra_id	wage
1	Warrix Lutterman	flute	16	3	16900
2	Knackstedt Dalhart	cello	16	9	17100
3	Tyrie Yaiva	bassoon	19	7	
• id – the ID of a given member.
• name – the name of a given member.
• position – the position of a given member in an orchestra.
• wage – the fixed monthly payment a given musician receives.
• experience – the number of years of experience a given musician has.
• orchestra_id – the ID of the orchestra in which a given musician works.

For each orchestra select its name and the number of members in this orchestra (name the column members_count).

select
	count(m.id) members_count,
	o.name
FROM Orchestras o
Join members m
on o.id = m.orchestra_id
group by orchestra_id, o.name


Exercises
	57. Good orchestras that are newer than the Chamber Orchestra

Show the names of orchestras that were created after the 'Chamber Orchestra' and have a rating greater than 7.5.

select 
		o.name
	from  orchestras  o 
	where  year > (select year from orchestras where name =  'Chamber Orchestra')
	 and rating >7.5
   
	58. Orchestras from cities visited in 2013

Select the names of all orchestras that have the same city of origin as any city in which there was a concert in 2013.

select 
	o.name
from  orchestras  o 
where city_origin = 
any (select city from concerts 
 where year = 2013)
   
	59. Same number of members as the Musical Orchestra

SELECT 
o.name,
count(m.id) as members_count
FROM orchestras o
join members m 
on o.id=m.orchestra_id
group by o.name
having count(m.id)=
(SELECT 
count(m.id) 
FROM orchestras o
join members m 
on o.id=m.orchestra_id
group by o.name
 having o.name = 'Musical Orchestra'

   
	60. The average number of members in orchestra

Select avg(subqry.count)	Sub-query in from needs alias name
	from (SELECT count(id) FROM members group by orchestra_id) as subqry

SELECTAVG(d.count) 
FROM(SELECTorchestra_id, COUNT(id) FROMmembers GROUPBY1) d;	

61. The biggest orchestras
	Show the name and number of members for each orchestra that has more members than the average membership of all orchestras in the table.
	
  3levels, 2 subqueries
  
	Select o.name, count(m.id)
	from orchestras o
	join members m
	on o.id = m. orchestra_id
	group by 1
	having count(m.id) > (SELECT 
	  AVG(d.count) 
	FROM 
	  (SELECT orchestra_id, COUNT(id) FROM members GROUP BY 1) d)
	
