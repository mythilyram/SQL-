CREATE DATABASE Giraffe;
CREATE TABLE student (
  student_id INT PRIMARY KEY,
  name VARCHAR(20),
  major VARCHAR(20) 
  -- PRIMARY KEY(student_id)
  );
DESCRIBE student;
DROP TABLE student;
ALTER TABLE student ADD gpa DECIMAL(3,2);
ALTER TABLE student DROP COLUMN gpa;

INSERT INTO student VALUES(1, 'Jack', 'Biology');
INSERT INTO student VALUES(2, 'Kate', 'Sociology');
INSERT INTO student(student_id, name) VALUES(3, 'Claire'); -- if you do not know a value, use this. the blacnk value is NULL
INSERT INTO student VALUES(4, 'Jack', 'Biology');
INSERT INTO student VALUES(5, 'Mike', 'Computer Science');

SELECT * FROM student;

CREATE TABLE student (
  student_id INT,
  name VARCHAR(20) NOT NULL,
  major VARCHAR(20) DEFAULT 'undecided',
  PRIMARY KEY(student_id)
  );

  -- major VARCHAR(20) UNIQUE, 

INSERT INTO student(student_id, name) VALUES(3, 'Claire'); -- DEFAULT 'undecided' gets populated 

CREATE TABLE student (
  student_id INT AUTO_INCREMENT,
  name VARCHAR(20),
  major VARCHAR(20) DEFAULT 'undecided',
  PRIMARY KEY(student_id)
  );
INSERT INTO student(name,major) VALUES('Jack', 'Biology'); -- (student_id auto populated)
INSERT INTO student(name,major) VALUES('Kate', 'Sociology');
-- from https://www.mikedane.com/databases/sql/constraints/
-- constraints  NOT NULL,DEFAULT 'default value', AUTO_INCREMENT,  UNIQUE
CREATE TABLE student (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(40) NOT NULL,
  -- name VARCHAR(40) UNIQUE,
  major VARCHAR(40) DEFAULT 'undecided'
);


-- UPDATE & DELETE rows
DELETE FROM student;

DELETE FROM student
WHERE student_id = 4;

DELETE FROM student
WHERE major = 'Sociology' AND name = 'Kate';

UPDATE student
SET major = 'Undecided';

UPDATE student
SET name = 'Johnny'
WHERE student_id = 4;

UPDATE student
SET major = 'Biological Sciences'
WHERE major = 'Biology';

UPDATE student
SET major = 'Biosociology'
WHERE major = 'Biology' OR major = 'sociology';

UPDATE student
SET major = 'Undecided', name = 'Tom'
WHERE student_id = 4;

-- Basic Queries

SELECT *
FROM student;

SELECT student.name, student.major
FROM student;

SELECT *
FROM student
WHERE name = 'Jack';

SELECT *
FROM student
WHERE student_id > 2;

SELECT *
FROM student
WHERE major = 'Biology' AND student_id > 1;
