-- ********** operators ***********-

# from now onwards we going to work with below master dataset 

CREATE TABLE department (
    department_id INT PRIMARY KEY,
   department_name VARCHAR(50) UNIQUE,
    department_location VARCHAR(50)
);

INSERT INTO department (department_id, department_name, department_location) VALUES
(10, 'IT', 'Block A'),
(20, 'HR', 'Block B'),
(30, 'Finance','Block C'),
(40, 'Marketing', 'Block D'),
(50, 'Sales', 'Block E');

desc department;

select * from department;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary int,
    department_id INT,
    manager_id INT,
    hire_date DATE,
    status VARCHAR(20),
    phone VARCHAR(20),
    email VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

INSERT INTO employees
(employee_id, employee_name, salary, department_id, manager_id, hire_date, status, phone, email)
VALUES
(101, 'Ravi Kumar', 95000, 10, NULL, '2018-01-10', 'ACTIVE', '9876500001', 'ravi@company.com'),
(102, 'Meera Shah', 72000, 10, 101, '2019-03-15', 'ACTIVE', '9876500002', 'meera@company.com'),
(103, 'Manoj Verma', 72000, 10, 101, '2019-07-20', 'ACTIVE', NULL, 'manoj@company.com'),
(104, 'Anjali Rao', 105000, 20, NULL, '2017-06-01', 'ACTIVE', '9876500008', 'anjali@company.com'),
(105, 'Priya Nair', 78000, 20, 104, '2019-09-12', 'ACTIVE', '9876500009', NULL),
(106, 'Kavya Iyer', 78000, 20, 104, '2020-02-18', 'INACTIVE', '9876500010', 'kavya@company.com'),
(107, 'Arjun Mehta', 55000, 30, NULL, '2016-08-14', 'ACTIVE', '9876500013', 'arjun@company.com'),
(108, 'Divya Pillai', 82000, 30, 107, '2018-12-01', 'ACTIVE', '9876500014', 'divya@company.com'),
(109, 'Swati Kulkarni', 99000, 40, NULL, '2015-03-03', 'ACTIVE', '9876500018', 'swati@company.com'),
(110, 'Rohit Sharma', 74000, 40, 109, '2020-06-06', 'ACTIVE', '9876500019', 'rohit@company.com'),
(111, 'Kiran Rao', 55000, NULL, NULL, '2023-01-01', 'ACTIVE', '9876500023', 'kiran@company.com'),
(112, 'Amit Sharma', 58000, NULL, NULL, '2023-06-15', 'ACTIVE', '9876500024', 'amit@company.com');
 
-- equal 

 select * from employees where employee_id=101;

-- not equal

 select * from employees where employee_id!=101;

-- Greater than

 select * from employees where salary > 100000;

-- less than

 select * from employees where salary < 60000;

-- AND department and salary

 select * from employees where department_id=10 and salary > 90000;

-- OR 

 select * from employees where department_id=10 or salary > 90000;

-- NOT

 select * from employees where not department_id=10;

-- IN

 select * from employees where department_id in (10,20,30);

-- NOT IN

 select * from employees where department_id not in (10,20);

-- BETWEEN

 select * from employees where salary between 50000 and 60000;

-- LIKE 

 select * from employees where  employee_name like '_a%';

-- NULL

 select * from employees where manager_id is null;

-- Ascending

 select * from employees order by salary;

-- Descending
select * from employees order by salary desc;

-- Top 5

select * from employees limit 5;

select * from employees order by employee_id limit 5;

desc employees;

-- Update before running any update first run select and check your updating correct one or not

update employees
set salary=98000
where employee_id=101;

select * from employees
-- set salary=98000
where employee_id=101;

-- Update multiple columns

update employees
set salary=99000,
department_id=20
where employee_id=101;

-- before Delete, first select the rows which you want to delete, once you confirm the data then only delete. otherwise you might delete all.

delete from employees
where employee_id=101;

desc employees;

-- Truncate
-- before doing truncate or drop pls create backup tables it will save us if anything goes wrong.

select * from employees;
 
create table employees_bkp as 
select * from employees;

select * from employees_bkp;
 
select count(*) from employees_bkp; -- 12

truncate table employees;

-- DROP 
drop table employees;
