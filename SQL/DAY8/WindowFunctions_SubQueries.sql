-- still now we have 2 tables, how to join 3 tables 

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

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    employee_id INT
);

INSERT INTO projects VALUES
(1001, 'Cloud Migration', 101),
(1002, 'Data Pipeline', 102),
(1003, 'HR Portal', 103),
(1004, 'Finance Report', 104);
-- select 3 tables 

select * from department;

select * from employees;

select * from projects;

-- inner join 

select e.employee_name,d.department_name,p.project_name
from employees e
join department d
on e.department_id=d.department_id
join projects p
on e.employee_id=p.employee_id where employee_name='Ravi';

-- left 
select e.employee_name,d.department_name ,p.project_name
from employees e
left join department d
on e.department_id=d.department_id
left join projects p
on e.employee_id=p.employee_id where employee_name='Ravi';


-- self join giving simple example to understand

--  Create the table
CREATE TABLE emp (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT
);

--  Insert sample data
INSERT INTO emp (emp_id, emp_name, manager_id) VALUES
(1, 'Mahesh', NULL),
(2, 'Harish', 1),
(3, 'Manohar', 1),
(4, 'adi', 2),
(5, 'divya', 2);


select * from emp;

SELECT
e.*,m.*
FROM emp e
LEFT JOIN emp m
ON e.manager_id = m.emp_id;

SELECT
e.emp_name AS employee,
m.emp_name AS manager
FROM emp e
JOIN emp m
ON e.manager_id = m.emp_id;

SELECT
e.emp_name AS employee,
m.emp_name AS manager
FROM emp e
left JOIN emp m
ON e.manager_id = m.emp_id;

-- important interview question on self join -----
-- create one more dataset to get more clarity
CREATE TABLE emp1 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT,
    salary INT,
    department VARCHAR(50)
);

INSERT INTO emp1 (emp_id, emp_name, manager_id, salary, department) VALUES
(1,  'Alice',   NULL, 90000, 'Engineering'),
(2,  'Bob',     1,    95000, 'Engineering'),   -- earns MORE than manager Alice
(3,  'Carol',   1,    95000, 'Engineering'),
(4,  'David',   2,    60000, 'Engineering'),
(5,  'Eve',     2,    65000, 'Engineering'),
(6,  'Frank',   NULL, 80000, 'Sales'),
(7,  'Grace',   6,    85000, 'Sales'),         -- earns MORE than manager Frank
(8,  'Heidi',   6,    85000, 'Sales'),
(9,  'Ivan',    7,    45000, 'Sales'),
(10, 'Judy',    NULL, 100000,'Marketing'),
(11, 'Judy',    10,   40000, 'Marketing');     -- DUPLICATE name (for duplicate-check query)

-- 01. Find employees who earn more than their manager.

select * from emp1;

select e.emp_name employee_name, e.salary as emp_sal, m.emp_name as manger_name, m.salary as manger_sal
from emp1 e
join emp1 m
on e.manager_id = m.emp_id
where e.salary > m.salary;

-- sub query

select * from emp1;

-- Find employees earning above the company average salary.
select emp_name,salary from emp1 where salary > (
select avg(salary) from emp1);

-- Find employees who work in the same department as 'Alice'.

select emp_name,department from emp1 where department in (
select department from emp1 where emp_name='Alice');

-- window functions: very important concept for interview.
-- syntax: FUNCTION() OVER (PARTITION BY column ORDER BY column)
/* 
ROW_NUMBER() – Gives each row a unique sequential number.
RANK() – Ranks rows, when there is tie in the records it will skip next number.
DENSE_RANK() – Ranks rows, when there is tie in the records it will skip next number.
SUM() OVER – grouped total without collapsing rows.
AVG() OVER – Shows the average alongside every row instead of one row per group.
LAG() – Fetches the value from the previous row.
LEAD() – Fetches the value from the next row.
*/

select * from emp1;

-- ROW_NUMBER
-- i want highest paid employees in decending order.

select emp_name,department,salary,
ROW_NUMBER() OVER (ORDER BY salary desc) as rn
from emp1;

-- i want department wise salary in descending order.

select emp_name,department,salary,
ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary desc) as rn
from emp1;

-- RANK

select emp_name,department,salary,
RANK() OVER (ORDER BY salary desc) as rnK
from emp1;

-- i want department wise salary in descending order.
 
 -- DENSE_RANK
select emp_name,department,salary,
DENSE_RANK() OVER (ORDER BY salary desc) as rnK
from emp1;

select emp_name,department,salary,
RANK() OVER (ORDER BY salary desc) as rk,
DENSE_RANK() OVER (ORDER BY salary desc) as drank
from emp1;

-- Note: important interview question what is diffrence between rank and dense_rank
-- in case of Rank when there is tie it will skip number, in case of dense_rank it will not skip the next number.

select emp_name,department,salary,
DENSE_RANK() OVER (PARTITION BY department ORDER BY salary desc) as rnK
from emp1;

-- sum

select * from emp1;

select emp_name,department,salary,
SUM(salary) OVER (ORDER BY emp_id) as total_sum
from emp1;

-- avg

select emp_name,department,salary,
avg (salary) OVER (ORDER BY emp_id) as total_avg
from emp1;

-- lag 

select emp_name,department,salary,
lag (salary) OVER (ORDER BY emp_id) as lag1
from emp1;

select * from emp1;

-- lead 

select emp_name,department,salary,
lead (salary) OVER (ORDER BY emp_id) as le
from emp1;

-- case statement
/* syntx
CASE 
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
*/

-- categorize salary into bands

select emp_name,salary,
case 
when salary >=90000 THEN 'HIGH'
WHEN SALARY >=60000 THEN 'MEDIUM'
ELSE 'LOW'
END AS SALARY_BAND
FROM emp1;


-- CTE

/*
A CTE (Common Table Expression) is a temporary, named result set you define using WITH,
which you can then query like a normal table — it only exists for the duration of that one query.
syntax:

WITH cte_name AS (
    -- your query here
)
SELECT * FROM cte_name;
*/

WITH mahesh AS (
    SELECT * FROM emp1 WHERE department = 'Engineering'
)
SELECT emp_name, salary FROM mahesh;
