Q1.Write a SQL query to find the student name who will receive the 'Consistency Award'.
Consistency award will be given to only those students who have scored more than 90 in both Phy and Che.

Create table Student(Studid int,NAME varchar(10),Subject varchar(20),marks number);
insert into student values(1,'A','Phy','90');
insert into student values(1,'A','Che','95');
insert into student values(2,'B','Phy','80');
insert into student values(2,'B','Che','85');
insert into student values(3,'C','Phy','90');
insert into student values(4,'D','Phy','75');
insert into student values(4,'D','Che','90');

ANS:
select a.name 
from student a 
join student b
on a.name = b.name
 where  a.Subject<>b.Subject  AND (a.marks>=90 AND b.marks>=90) 
limit 1

o/p: A

Q2.Write an sql query to find the investor name who has invested in more than 1 fund.You should not use union/union all/minus keywords.
investor1 is the table which shows the investment done by investors in first round and 
investor2 table shows the investment done in second round.

create table investor1 (investorname varchar(40),sector varchar(50));
insert into investor1 values('Ashneer','Food and Beverages');
insert into investor1 values('Anupam','Automobile');
insert into investor1 values('Piyush','Tech');
insert into investor1 values('Namita','Food and Beverages');

create table investor2(investorname varchar(40),sector varchar(50));
insert into investor2 values('Aman','Food and Beverages');
insert into investor2 values('Namita','Automobile');
insert into investor2 values('Piyush','Sales');
insert into investor2 values('Vineeta','Food and Beverages');

O/p:
Investorname
Piyush
Namita

ANS: just join
select a.investorname 
from investor1 a
join investor2 b
on  a.investorname = b. investorname;

o/p : 
Namita
Piyush

drop table investor1;
drop table investor2;

Q3.Write an sql query to find the investor name who has done investment in only first round.You should not use union/union all/minus keywords.
investor1 is the table which shows the investment done by investors in first round and 
investor2 table shows the investment done in second round.

create table investor1(investorname varchar(40),sector varchar(50));
insert into investor1 values('Ashneer','Food and Beverages');
insert into investor1 values('Anupam','Automobile');
insert into investor1 values('Piyush','Tech');
insert into investor1 values('Namita','Food and Beverages');

create table investor2(investorname varchar(40),sector varchar(50));
insert into investor2 values('Aman','Food and Beverages');
insert into investor2 values('Namita','Automobile');
insert into investor2 values('Piyush','Tech');
insert into investor2 values('Vineeta','Food and Beverages');

ANS: 
select a.investorname 
from investor1 a
left join investor2 b
on  a.investorname = b. investorname
where b.investorname is null;

o/p:
Ashneer
Anupam

Q4.Write an sql query to find the investor name who has done investment in only second round.You should not use union/union all/minus keywords.
investor1 is the table which shows the investment done by investors in first round and 
investor2 table shows the investment done in second round.

create table investor1(investorname varchar(40),sector varchar(50));
insert into investor1('Ashneer','Food and Beverages');
insert into investor1('Anupam','Automobile');
insert into investor1('Piyush','Tech');
insert into investor1('Namita','Food and Beverages');

create table investor2(investorname varchar2(40),sector varchar2(50));
insert into investor2('Aman','Food and Beverages');
insert into investor2('Namita','Automobile');
insert into investor2('Piyush','Tech');
insert into investor2('Vineeta','Food and Beverages');

ANS:
select b.investorname 
from investor1 a
right join investor2 b
on  a.investorname = b. investorname
where a.investorname is null;

Q5.Write an sql query to fetch the empname and their manager name.
create table emp(empid int,empname varchar(50),mgr_id int);
insert into emp values (1,'A',4);
insert into emp values (2,'B',4);
insert into emp values (3,'C',5);
insert into emp values (4,'D',NULL);
insert into emp values (5,'E',NULL);

ANS: 
select a.empname as emp_name,b.empname as manager_name
from emp a
join emp b
on a.mgr_id = b.empid;
not on a.empid = b.mgr_id

O/P:
 emp_name	manager_name
	B	D
	A	D
	C	E

Q6.Write a SQL query to fetch the below output.
Input 
Id    Name     Add1          Add2
1     Ramesh   Bangalore     Chennai
2     Suresh   Vizag         Null
3     Mani     Null          Hyd 


Output 
Id  Name    Address 
1   Ramesh  Bangalore 
1   Ramesh  Chennai
2   Suresh  Vizag 
3   Mani    Hyd

create table input(id int,name varchar(20),add1 varchar(50),add2 varchar(50));
insert into input values(1,'Ramesh','Bangalore','Chennai');
insert into input values(2,'Suresh','Vizag',NULL);
insert into input values(3,'Mani',NULL,'Hyd');
Try with full outer join
ANS:
with cte as (
select a.id,a.name,a.add1 from input a
left join input b on a.id=b.id 
Union All
select a.id,a.name,a.add2 from input a
right join input b on a.id=b.id )
select * from cte 
where add1 is not null
ORDER BY id

Q7. Write an SQL query to display source and destination

create table city(location varchar(50));
insert into city values('Delhi');
insert into city values('Chennai');
insert into city values('Mumbai');
insert into city values('Bangalore');

Exp. output:
SOURCE	DESTINATION
Chennai	Bangalore
Delhi	Bangalore
Delhi	Chennai
Mumbai	Chennai
Mumbai	Delhi
Mumbai	Bangalore

ANS:
select 
    a.location as SOURCE,
    b.location as DESTINATION
    from city A
    cross join city B
    where a.location <> b.location
    order by a.location;
o/p
Bangalore	Delhi
Bangalore	Chennai
Bangalore	Mumbai
Chennai	Mumbai
Chennai	Delhi
Chennai	Bangalore
Delhi	Mumbai
Delhi	Chennai
Delhi	Bangalore
Mumbai	Delhi
Mumbai	Chennai
Mumbai	Bangalore

ANS 2 :
select 
    a.location as SOURCE,
    b.location as DESTINATION
    from city A
    inner join city B
     on a.location > b.location
    order by b.location;

SOURCE	DESTINATION
Chennai	Bangalore
Delhi	Bangalore
Mumbai	Bangalore
Delhi	Chennai
Mumbai	Chennai
Mumbai	Delhi

Q8. Write an SQL query to get the tournament list.
Each country should play only 1 match with other country

create table teams(country varchar2(50));
insert into teams values('India');
insert into teams values('Pak');
insert into teams values('NZ');
insert into teams values('SA');
insert into teams values('SL');
insert into teams values('Eng');

Q9. Write an SQL query to list the student name whose marks have increased in second semester as compared to first semester.

create table student(studid int,studname varchar(50),semester int,marks int);
insert into student values(1,'A',1,120);
insert into student values(1,'A',2,140);

insert into student values(2,'B',1,120);
insert into student values(2,'B',2,100);

insert into student values(3,'C',1,120);
insert into student values(3,'C',2,120);

Q10. Write an SQL query to find the student who has scored same marks in 1st and 2nd sem in 'PHYSICS'.

CREATE TABLE STUD(ID NUMBER,NAME VARCHAR2(10),SEMESTER NUMBER,SUBJECT VARCHAR2(10),MARKS NUMBER);
INSERT INTO STUD VALUES(1,'A',1,'PHYSICS',100);
INSERT INTO STUD VALUES(1,'A',2,'PHYSICS',150);
INSERT INTO STUD VALUES(1,'A',3,'PHYSICS',200);
INSERT INTO STUD VALUES(1,'A',4,'PHYSICS',250);

INSERT INTO STUD VALUES(1,'A',1,'CHEMISTRY',50);
INSERT INTO STUD VALUES(1,'A',2,'CHEMISTRY',250);
INSERT INTO STUD VALUES(1,'A',3,'CHEMISTRY',200);
INSERT INTO STUD VALUES(1,'A',4,'CHEMISTRY',350);

INSERT INTO STUD VALUES(2,'B',1,'PHYSICS',150);
INSERT INTO STUD VALUES(2,'B',2,'PHYSICS',250);
INSERT INTO STUD VALUES(2,'B',3,'PHYSICS',100);
INSERT INTO STUD VALUES(2,'B',4,'PHYSICS',200);

INSERT INTO STUD VALUES(2,'B',1,'CHEMISTRY',150);
INSERT INTO STUD VALUES(2,'B',2,'CHEMISTRY',150);
INSERT INTO STUD VALUES(2,'B',3,'CHEMISTRY',250);
INSERT INTO STUD VALUES(2,'B',4,'CHEMISTRY',300);Q
