select database();

create table demo_db.windows_emp_table 
(
  emp_id int,
  emp_name varchar(100),
  emp_salary int
);

ALTER TABLE demo_db.windows_emp_table ADD COLUMN depart_name varchar(100);

select * from demo_db.windows_emp_table;

insert into demo_db.windows_emp_table
values (1,"Rahul",100,"CSE"), (2, "Mahesh",200,"ECE"), (3,"Zameer",200,"ECE"), (4,"Manohar",100,"MECH"), (5,"Manohar",200,"MECH"), (6,"Divya",100,"CSE"),(7,"Malli",200,"CSE");

-- Fetch the highest salary amount in each dep.

SELECT DEPART_NAME, MAX(EMP_SALARY) AS HIGHEST_SAL, EMP_NAME
FROM demo_db.windows_emp_table
GROUP BY DEPART_NAME;

-- WINDOWS FUNCTION -- ROW_NUMBER() - Unique Identifier for each row , RANK() , Dense Rank(), LAG() , LEAD()
-- 1,2,2,4  --> RANK ()
-- 1,2,2,3  --> DENSE_RANK()

select * from demo_db.windows_emp_table;

-- Fetch the highest salary amount in each dep.
SELECT e.*, ROW_NUMBER() OVER() AS rn
FROM demo_db.windows_emp_table e;

SELECT e.*, ROW_NUMBER() OVER(PARTITION BY DEPART_NAME) AS rn
FROM demo_db.windows_emp_table e;

SELECT e.*, 
       ROW_NUMBER() OVER(PARTITION BY DEPART_NAME ORDER BY EMP_SALARY DESC) AS rn,
       RANK() OVER(PARTITION BY DEPART_NAME ORDER BY EMP_SALARY DESC) as rnk,
       dense_rank() OVER(PARTITION BY DEPART_NAME ORDER BY EMP_SALARY DESC) as dense_rnk
FROM demo_db.windows_emp_table e;




insert into demo_db.windows_emp_table 
values (8,"Harish",50,"CSE");

SET SQL_SAFE_UPDATES = 0;

UPDATE demo_db.windows_emp_table SET DEPART_NAME="CSE" WHERE EMP_ID=8;


-- Fetch the highest salary amount in each dep.

SELECT e.*, 
       ROW_NUMBER() OVER(PARTITION BY DEPART_NAME ORDER BY EMP_SALARY DESC) AS rn,
       RANK() OVER(PARTITION BY DEPART_NAME ORDER BY EMP_SALARY DESC) as rnk,
       dense_rank() OVER(PARTITION BY DEPART_NAME ORDER BY EMP_SALARY DESC) as dense_rnk
FROM demo_db.windows_emp_table e;

-- In output we need the highest salary emp_name, emp_id in each department

select a.emp_id, a.emp_name, a.depart_name from
(SELECT e.*, RANK() OVER(PARTITION BY DEPART_NAME ORDER BY EMP_SALARY DESC) as rnk
FROM demo_db.windows_emp_table e) a
where a.rnk=1
;

-- 7	Malli	CSE
-- 2	Mahesh	ECE
-- 3	Zameer	ECE
-- 5	Manohar	MECH

SELECT B.emp_id, B.emp_name, B.depart_name FROM (
SELECT e.*, row_number() OVER(PARTITION BY DEPART_NAME ORDER BY EMP_SALARY DESC,EMP_ID DESC) as rnk
FROM demo_db.windows_emp_table e) B
WHERE B.rnk=1 ;

-- 7	Malli	CSE
-- 3	Zameer	ECE
-- 5	Manohar	MECH

---------- LAG & LEAD ------------

CREATE TABLE demo_db.employee_salary (
    employee_id INT,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    effective_date DATE
);

INSERT INTO demo_db.employee_salary
    (employee_id, employee_name, department, salary, effective_date)
VALUES
    (101, 'Rahul', 'IT', 50000, '2023-01-01'),
    (101, 'Rahul', 'IT', 55000, '2023-07-01'),
    (101, 'Rahul', 'IT', 60000, '2024-01-01'),
    (101, 'Rahul', 'IT', 65000, '2024-07-01'),

    (102, 'Priya', 'HR', 45000, '2023-01-01'),
    (102, 'Priya', 'HR', 48000, '2023-07-01'),
    (102, 'Priya', 'HR', 52000, '2024-01-01'),

    (103, 'Arjun', 'Finance', 55000, '2023-01-01'),
    (103, 'Arjun', 'Finance', 58000, '2023-07-01'),
    (103, 'Arjun', 'Finance', 62000, '2024-01-01');
    
select * from demo_db.employee_salary;

-- LAG - It will go backward and fetch it's corresponding prev. value.
-- Lead  - It will go forward and fetch it's corresponding prev. value.

SELECT emp_sal.*, LAG(salary,1,0) OVER(PARTITION BY employee_id order by effective_date) as prev_sal
FROM demo_db.employee_salary emp_sal ;


SELECT emp_sal.*, LAG(salary,2,0) OVER(PARTITION BY employee_id order by effective_date) as prev_sal
FROM demo_db.employee_salary emp_sal ;


SELECT emp_sal.*,
	   LAG(salary,1,0) OVER(PARTITION BY employee_id order by effective_date) as prev_sal,
	   LEAD(salary,1,0) OVER(partition by employee_id order by effective_date) as For_Sal
FROM demo_db.employee_salary emp_sal;


-- Want to know how much salary has been increased for each empolyee based on the revised effective date.

SELECT
       e.*,
       LAG(e.SALARY,1,0) OVER(PARTITION BY employee_id  ORDER BY effective_date) as prev_sal,
       e.salary - LAG(e.SALARY,1,0) OVER(PARTITION BY employee_id  ORDER BY effective_date)    AS INCREASED_AMOUNT
FROM demo_db.employee_salary e;


-- SUM() 

SELECT e.*, min(salary) OVER(partition by employee_id order by effective_date) AS cumm_sum 
FROM demo_db.employee_salary e;

--  CASE STATEMENT 

SELECT
       e.*,
       LAG(e.SALARY,1,0) OVER(PARTITION BY employee_id  ORDER BY effective_date) as prev_sal,
       e.salary - LAG(e.SALARY,1,0) OVER(PARTITION BY employee_id  ORDER BY effective_date)    AS INCREASED_AMOUNT
FROM demo_db.employee_salary e
WHERE e.INCREASED_AMOUNT > 0
;


select * ,
       CASE WHEN a.INCREASED_AMOUNT > 0 Then "Increase"
            WHEN a.INCREASED_AMOUNT = 0 Then "Neutral/No Increement"
            ELSE "Decrease"
		END as Flag
from
(SELECT
       e.*,
       LAG(e.SALARY,1,0) OVER(PARTITION BY employee_id  ORDER BY effective_date) as prev_sal,
       e.salary - LAG(e.SALARY,1,0) OVER(PARTITION BY employee_id  ORDER BY effective_date)    AS INCREASED_AMOUNT
FROM demo_db.employee_salary e) a
;

-- CTE, STORED PROCEDURE , UDF --> User Defined Functions
