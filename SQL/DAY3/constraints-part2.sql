- **** FOREIGN KEY : A Foreign Key creates a relationship between two tables. In the example, employees.department_id
-- refers to departments.department_id ***** --

-- ******** how to give name to constraint ********- 

-- Note: when your creating FK constraint table in our case employees1 first create PK table i.e. departments4 otherwise u will get error

-- create departments4 table 

CREATE TABLE departments4 (
department_id INT PRIMARY KEY,
department_name VARCHAR(50) UNIQUE
);

-- create employees1 table

CREATE TABLE employees1 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    age INT,
    CONSTRAINT chk_employee_age
        CHECK (age >= 17),
    department_id INT,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id)
        REFERENCES departments4 (department_id)
);

INSERT INTO departments4 (department_id, department_name)
VALUES (10, 'IT'), (20, 'HR'), (30, 'Finance');

SELECT * FROM departments4;

INSERT INTO employees1 VALUES (1, 'H1', 'H1@gmail.com',50,20);
INSERT INTO employees1 VALUES (2, 'H2', 'H2@gmail.com',60,10);

SELECT * FROM employees1;


-- try into insert employee record whose deparment is not present in departments4

INSERT INTO employees1 VALUES (3, 'H3', 'H3@gmail.com',50,40);

-- Note: error -- foregin constriant fail

-- change the value of deparment_id
INSERT INTO employees1 VALUES (3, 'H3', 'H3@gmail.com',50,30);

-- ***** CHECK: Rejects a value unless it satisfies a boolean condition ***** --

INSERT INTO employees1 VALUES (4, 'H4', 'H4@gmail.com',15,30);

-- Note: error constarint vialation

INSERT INTO employees1 VALUES (4, 'H4', 'H4@gmail.com',18,30);


-- ***** DEFAULT: it will insert default value provided in table creation if value is not provided. ***** ---

-- select table employees1 before adding Default constraint how table looks do select


select * from employees1;

-- add default constraint

ALTER TABLE employees1 
ADD status VARCHAR(50) DEFAULT 'ACTIVE';


-- verify the table now, in status column all records are ACTIVE i.e. bcz of DEFAULT 'ACTIVE' when u don't pass the value it will, by default take value as default value here 'ACTIVE'.

select * from employees1;

-- add one record to the table 

INSERT INTO employees1 VALUES (5, 'H5', 'H5@gmail.com',18,30,'INACTIVE');

select * from employees1;

-- let's try without passing any value to status 

-- column count should match we have 6 columns but 5 values it will column count doesn't match
INSERT INTO employees1 VALUES (6, 'H6', 'H6@gmail.com',18,30);

-- pass columnns and values 
INSERT INTO employees1 (emp_id,emp_name,email,age,department_id) VALUES (6, 'H6', 'H6@gmail.com',18,30);


-- ***** AUTO_INCREMENT: Generates the next whole number automatically — commonly used on a PRIMARY KEY so IDs never,
--  have to be picked by hand. Only one AUTO_INCREMENT column is allowed per table ***** --

-- lets modify the emp_id primary key defination

ALTER TABLE employees1
MODIFY emp_id int PRIMARY KEY AUTO_INCREMENT;

-- Note: error - Multiple primary key defined, so drop the primary key cloumn and recreate it.
ALTER TABLE employees1
DROP emp_id;

select * from employees1;

-- add auto increment now

ALTER TABLE employees1
ADD emp_id int PRIMARY KEY AUTO_INCREMENT FIRST;

INSERT INTO employees1 (emp_name,email,age,department_id) VALUES ('H7', 'H7@gmail.com',18,30);

-- verify the data
select * from employees1;

-- if you want increment the value by 2 instead of one. SET SESSION auto_increment_increment = 2;

SET SESSION auto_increment_increment = 2;

-- insert record 

INSERT INTO employees1 (emp_name,email,age,department_id) VALUES ('H8', 'H8@gmail.com',18,30);

select * from employees1;

-- how to drop FK constraint, before dropping constriant check the table definition and see defined FK

SHOW CREATE TABLE employees1;

-- drop the FK

alter table employees1 drop FOREIGN KEY fk_employee_department;

-- after dropping check check table definition. in key column FK key will be removed

SHOW CREATE TABLE employees1;

-- similarly drop check constraint

alter table employees1 drop check chk_employee_age;

SHOW CREATE TABLE employees1;
