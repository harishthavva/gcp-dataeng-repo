- aggregations

-- COUNT(*)

SELECT count(*) FROM employees;

-- COUNT column: count(col) - will not count null values

SELECT count(manager_id) FROM employees;

-- COUNT(1): 

SELECT count(1) FROM employees;

SELECT count(0) FROM employees;

SELECT count('mahesh') FROM employees;

/*
NOTE: IN interview they will difference between count(*), count(col) and count(1)
count(*) will count no.of rows in a table with nulls where as count(col) will count only non nulls in particular column 
and count(1) 1 is a constent number it will also count number of rows in a table with nulls, in place of 1 you can mention 
annything like count(0),count(mahesh) result is same
*/

SELECT * FROM employees;
-- SUM

SELECT SUM(salary) FROM employees;

SELECT SUM(salary) FROM employees where department_id=10;
-- AVG

SELECT AVG(salary) FROM employees;

SELECT AVG(salary) FROM employees where department_id=10;
-- MIN
SELECT MIN(salary) FROM employees;

SELECT MIN(salary) FROM employees where department_id=10;

-- MAX 
SELECT * FROM employees;

SELECT max(salary) FROM employees;

SELECT max(salary) FROM employees where department_id=10;

-- GROUP BY: Counts employees in each department.

SELECT department_id,AVG(salary) FROM employees group by department_id;


-- Group average,min,max: Calculates average salary by department.

-- HAVING: Filters groups after aggregation.
-- Now my requirement is find the departments WHERE salary avg is more than 75000.

SELECT department_id,AVG(salary) FROM employees group by department_id having AVG(salary) > 75000;

SELECT department_id,AVG(salary) FROM employees where department_id=10 group by department_id having AVG(salary) > 75000;

/* 
Note: interview question, what is difference between where and having
where filters the data before aggregation, and having will be used when you want to perform filters on aggregation 
*/

CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO department (department_id, department_name)
VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance'),
(40, 'Marketing'),
(50, 'Sales');

select * from department;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department_id INT
);

INSERT INTO employees (employee_id, employee_name, department_id)
VALUES
(101, 'Ravi', 10),
(102, 'Meera', 10),
(103, 'Priya', 20),
(104, 'Arjun', 30),
(105, 'John', NULL),
(106, 'Kiran', 60);

select * from department;

select * from employees;

-- INNER JOIN

select e.employee_id,e.employee_name,d.department_name
from employees e
inner join department d
on e.department_id=d.department_id;

-- LEFT JOIN 

select e.employee_id,e.employee_name,d.department_name
from employees e
left join department d
on e.department_id=d.department_id;


select e.employee_id,e.employee_name,d.department_name
from employees e
left join department d
on d.department_id=e.department_id;
-- RIGHT JOIN

select e.employee_id,e.employee_name,d.department_name
from employees e
right join department d
on e.department_id=d.department_id;

-- FULL JOIN

select e.employee_id,e.employee_name,d.department_name
from employees e
left join department d
on e.department_id=d.department_id
union 
select e.employee_id,e.employee_name,d.department_name
from employees e
right join department d
on e.department_id=d.department_id;
