use company_db;

-- constraints: A constraint is a rule attached to a column or table that the database enforces automatically on every
-- INSERT, UPDATE, or DELETE.

-- NOT NULL: Forces a column to always have a value — it can never be left empty.

create table company_db.departmnt (
department_id int primary key,
department_name varchar(50) not null
);

select * from company_db.departmnt ;

-- department_name is not it will not allow null try passing null value and check.
insert into company_db.departmnt values (1,null);

-- Note: you will get error (column department_name cannot be null) bcz department_name is not null 
-- Now pass some value to department_name

insert into company_db.departmnt values (1,'IT');
-- Note: it will get inserted 

-- PRIMARY KEY: A Primary Key uniquely identifies each row in a table. it will not allow duplicates 
-- we have defined department_id as PK lets pass duplicate value and see what will happen

insert into company_db.departmnt values (1,'IT');
-- Note: error: duplicate entry
-- let's pass different department_id 2
insert into company_db.departmnt values (2,'IT');

-- Note: it will get inserted since 2 is not present departmnt

-- UNIQUE KEY: A Unique Key prevents duplicate values in a column
-- create table or alter table to change data type to unique

create table company_db.departmnt1 (
department_id int primary key,
department_name varchar(50) unique
);

insert into company_db.departmnt1 values (1,'IT');

-- lets try to insert duplicate value in unique key column department_name
insert into company_db.departmnt1 values (2,'IT');

-- Note: error:duplicate entry IT

-- pass different value
insert into company_db.departmnt1 values (2,'Finance');

-- check table

select * from company_db.departmnt1;

-- one pk per table is allowd

create table company_db.departmnt2 (
department_id int primary key,
department_id_OTHER int primary key,
department_name varchar(50) unique
);

-- Note: error: Multiple primary key defined

-- lets create table by commenting one 
create table company_db.departmnt2 (
department_id int primary key,
-- department_id_OTHER int primary key,
department_name varchar(50) unique
);

-- multiple unique keys per table allowed, lets add department_location one more unique key

ALTER TABLE company_db.departmnt2 ADD 
COLUMN department_location varchar(30) unique;

-- verify how many uniques keys created
desc departmnt2;

-- insert the data 
insert into company_db.departmnt2 values (1,'IT','1st floor');
-- verify the data 
select * from company_db.departmnt2;

-- practice some inserts by pasing null values to PK and unique key

-- Note:

-- MAIN DIFFRENCE BETWWEN PRIMARY KEY AND UNIQUE KEY IS:
-- PRIMARY WILL NOT ALLOW NULLS AND WILL NOT ALLOW DUPLICATES - ONE PRIMARY KEY PER TABLE IS ALLOWED
-- UNIQUE KEY WILL ALLOW NULLS AND WILL NOT ALLOW DUPLICATES - MULTIPLE UNIQUE KEYS PER TABLE IS ALLOWED.

-- FOREIGN KEY : A Foreign Key creates a relationship between two tables. In the example, employees.department_id
-- refers to departments.department_id:

-- create table
CREATE TABLE departments3 (
department_id INT PRIMARY KEY,
department_name VARCHAR(50) UNIQUE
);

-- insert data
INSERT INTO departments3 (department_id, department_name)
VALUES (10, 'IT'), (20, 'HR'), (30, 'Finance');

-- verify the data
select * from departments3;

-- create table 

CREATE TABLE employees (
emp_id INT PRIMARY KEY,
emp_name VARCHAR(100),
email VARCHAR(100) UNIQUE,
age int CHECK (age >= 17),
department_id INT,
FOREIGN KEY (department_id)
REFERENCES departments3(department_id));

-- Note: FOREIGN KEY (department_id)
-- REFERENCES departments1(department_id));

-- explanition: FOREIGN KEY (child_column)
-- REFERENCES parent_table(parent_column);

-- in our example:
-- FOREIGN KEY (department_id)
-- REFERENCES departments1(department_id);

-- insert data

INSERT INTO employees VALUES (1, 'm1', 'm1@gmail.com',50,10);

-- lets try inserting departemnt id 90 which is not present departments3
INSERT INTO employees VALUES (2, 'm2', 'm2@gmail.com',50,90);

-- Note: erro: foreign key constraints fails bcz 90 is not present departments3, it will allow only values present departments3  like(10,20,30) 
-- this how FK prevent data integrity (means kind of validation check)

-- lets insert 20 instaed 90 
INSERT INTO employees VALUES (2, 'm2', 'm2@gmail.com',50,20);

-- verify the data
select * from employees;
