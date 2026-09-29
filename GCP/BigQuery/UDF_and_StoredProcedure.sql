-- ============================================================
--              BIGQUERY UDF & STORED PROCEDURE
-- ============================================================
--
-- This demo covers:
--
-- 1. User Defined Function (UDF)
-- 2. Passing parameters to a UDF
-- 3. Calling a UDF
-- 4. Using a UDF with table data
-- 5. Using a UDF with CTE
-- 6. Using a UDF with a Subquery
-- 7. Stored Procedure
-- 8. Procedure parameters
-- 9. Multi-step ETL using a Stored Procedure
-- 10. Audit logging
-- 11. Calling a Stored Procedure
--
--
-- SIMPLE DIFFERENCE:
--
-- UDF
-- ---
-- Used mainly to perform a calculation/transformation
-- and RETURN a value.
--
-- Stored Procedure
-- ----------------
-- Used to execute a sequence of SQL statements/actions.
-- It can perform operations such as INSERT, UPDATE, DELETE,
-- CREATE TABLE, and other procedural logic.
--
-- ============================================================



-- ============================================================
--                 SECTION 1: UDF
-- ============================================================
--
-- UDF = User Defined Function
--
-- A UDF is a reusable function created by the user to perform
-- a specific calculation or transformation.
--
-- A UDF can:
--
--     - Accept input parameters
--     - Perform calculations
--     - Return a value
--
-- BUSINESS USE CASE:
--
-- Calculate employee bonus based on:
--
--     Salary
--     Bonus Percentage
--
-- Formula:
--
--     Bonus Amount = Salary * (Bonus Percentage / 100)
-- ============================================================


-- ============================================================
-- CONCEPT 1: SIMPLE BONUS CALCULATION
-- ============================================================
--
-- Before creating the UDF, let's perform the calculation
-- directly using SQL.
--
-- Example:
--
--     Salary = 264117
--     Bonus Percentage = 20%
--
--     Bonus = 264117 * 20 / 100
-- ============================================================

SELECT
    264117.0 * 0.2 AS bonus_amount;


-- ============================================================
-- CONCEPT 2: CREATE A SQL UDF
-- ============================================================
--
-- CREATE FUNCTION is used to create a User Defined Function.
--
-- Function name:
--     calculate_bonus
--
-- Input parameters:
--
--     SALARY -> FLOAT64
--     BONUS  -> INT64
--
-- Return type:
--     FLOAT64
--
-- Formula:
--
--     SALARY * (BONUS / 100)
--
-- The function can now be reused in multiple SQL queries
-- instead of writing the calculation repeatedly.
-- ============================================================

CREATE OR REPLACE FUNCTION
    `dev-bq-509502.demo_dataset.calculate_bonus`
    (SALARY FLOAT64, BONUS INT64)

RETURNS FLOAT64

AS (
    SALARY * (BONUS / 100)
);


-- ============================================================
-- CONCEPT 3: CALL THE UDF WITH INPUT PARAMETERS
-- ============================================================
--
-- We can pass values to the UDF as arguments.
--
-- Input:
--     Salary = 100000
--     Bonus  = 20%
--
-- Output:
--     20000
--
-- Syntax:
--
--     function_name(input1, input2)
-- ============================================================

SELECT
    `dev-bq-509502.demo_dataset.calculate_bonus`(100000, 20)
    AS bonus_amount;


-- ============================================================
-- CONCEPT 4: USE UDF WITH TABLE DATA
-- ============================================================
--
-- Instead of passing hard-coded values, we can pass column
-- values from a table to the UDF.
--
-- For every employee:
--
--     SALARY          -> First input parameter
--     BONUS_PERCENTAGE -> Second input parameter
--
-- The UDF calculates the bonus amount for each employee.
--
-- This demonstrates how a UDF can be reused across multiple
-- rows of a table.
-- ============================================================

SELECT
    employee_id,
    salary,
    bonus_percentage,

    `dev-bq-509502.demo_dataset.calculate_bonus`
    (salary, bonus_percentage) AS bonus_amount

FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 5: UDF WITH CTE
-- ============================================================
--
-- BUSINESS REQUIREMENT:
--
-- Fetch employees whose calculated bonus amount is greater
-- than 50,000.
--
-- We first calculate the bonus amount inside the CTE.
--
-- Then the outer query filters the calculated result.
--
-- WHY USE A CTE?
--
-- A CTE makes a complex query easier to read and organize.
--
-- Flow:
--
--     Employee Table
--          |
--          v
--     Calculate Bonus
--          |
--          v
--     CTE Result
--          |
--          v
--     Filter bonus > 50,000
-- ============================================================

WITH CTE AS (

    SELECT
        employee_id,
        salary,
        bonus_percentage,

        `dev-bq-509502.demo_dataset.calculate_bonus`
        (salary, bonus_percentage) AS bonus_amount

    FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`
)

SELECT *
FROM CTE
WHERE bonus_amount > 50000;


-- ============================================================
-- CONCEPT 6: UDF WITH SUBQUERY
-- ============================================================
--
-- The same business requirement can also be achieved using
-- a SUBQUERY instead of a CTE.
--
-- Inner query:
--     Calculates the bonus amount.
--
-- Outer query:
--     Filters employees whose bonus is greater than 50,000.
--
-- This produces the same logical result as the CTE example.
-- ============================================================

SELECT *
FROM (

    SELECT
        employee_id,
        salary,
        bonus_percentage,

        `dev-bq-509502.demo_dataset.calculate_bonus`
        (salary, bonus_percentage) AS bonus_amount

    FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`

) AS a

WHERE a.bonus_amount > 50000;



-- ============================================================
--              SECTION 2: STORED PROCEDURE
-- ============================================================
--
-- STORED PROCEDURE
-- ----------------
-- A stored procedure is a collection of SQL statements that
-- can be executed together as a single unit.
--
-- Unlike a UDF, a stored procedure is not primarily designed
-- to return a calculated value.
--
-- It is commonly used to implement:
--
--     - ETL/ELT workflows
--     - Data loading
--     - INSERT/UPDATE/DELETE operations
--     - Data validation
--     - Audit logging
--     - Multi-step SQL workflows
--
-- BUSINESS USE CASE:
--
--     STAGING TABLE
--          |
--          v
--     TARGET TABLE
--          |
--          v
--     AUDIT TABLE
--
-- We will implement this complete flow using a
-- Stored Procedure.
-- ============================================================


-- ============================================================
-- CONCEPT 7: CREATE A DATASET / SCHEMA
-- ============================================================
--
-- Create a separate schema/dataset to store the tables and
-- stored procedure used in this ETL demonstration.
-- ============================================================

CREATE SCHEMA demo_sp;


-- ============================================================
-- CONCEPT 8: CREATE STAGING TABLE
-- ============================================================
--
-- A STAGING TABLE is generally used as an intermediate area
-- where source data is initially loaded before being moved
-- into the target/curated table.
--
-- In this example, employee_staging contains the source data.
-- ============================================================

CREATE TABLE
    `dev-bq-509502.demo_sp.employee_staging`
(
    employee_id INT64,
    employee_name STRING,
    department STRING,
    salary NUMERIC
);


-- ============================================================
-- CONCEPT 9: INSERT DATA INTO STAGING TABLE
-- ============================================================
--
-- Insert sample employee records into the staging table.
--
-- In a real project, this data could come from:
--
--     - GCS
--     - Another BigQuery table
--     - Database
--     - Dataflow
--     - API
--     - Other source systems
-- ============================================================

INSERT INTO `dev-bq-509502.demo_sp.employee_staging`
VALUES
    (101, 'Ravi',  'IT',      50000),
    (102, 'Priya', 'HR',      70000),
    (103, 'John',  'Finance', 90000);


-- ============================================================
-- CONCEPT 10: CREATE TARGET TABLE
-- ============================================================
--
-- The TARGET TABLE contains the final/processed employee data.
--
-- Compared with the staging table, we have an additional
-- column:
--
--     LOAD_DATE
--
-- This column records the date on which the data was loaded
-- into the target table.
-- ============================================================

CREATE TABLE
    `dev-bq-509502.demo_sp.employee_target`
(
    employee_id INT64,
    employee_name STRING,
    department STRING,
    salary NUMERIC,
    load_date DATE
);


-- ============================================================
-- CONCEPT 11: CREATE AUDIT TABLE
-- ============================================================
--
-- An AUDIT TABLE is used to maintain information about
-- ETL/process execution.
--
-- In this example, we will capture:
--
--     LOAD_TIME       -> When the process ran
--     RECORDS_LOADED  -> Number of records processed
--     STATUS          -> Process status
--
-- Audit tables are very useful for monitoring and troubleshooting
-- ETL pipelines.
-- ============================================================

CREATE TABLE
    `dev-bq-509502.demo_sp.employee_audit`
(
    load_time TIMESTAMP,
    records_loaded INT64,
    status STRING
);


-- ============================================================
-- CONCEPT 12: CREATE STORED PROCEDURE
-- ============================================================
--
-- The procedure name is:
--
--     etl_flow
--
-- This procedure contains multiple SQL statements that together
-- represent an ETL workflow.
--
-- ETL FLOW:
--
--     1. Read data from staging
--     2. Insert data into target
--     3. Write execution details into audit table
--
-- BEGIN
--     Starts the procedure body.
--
-- END
--     Marks the end of the procedure body.
-- ============================================================

CREATE PROCEDURE
    `dev-bq-509502.demo_sp.etl_flow`()

BEGIN


    -- ========================================================
    -- STEP 1: LOAD DATA FROM STAGING TO TARGET
    -- ========================================================
    --
    -- Read records from the staging table and insert them
    -- into the target table.
    --
    -- CURRENT_DATE() is added as LOAD_DATE so that we know
    -- when the records were loaded.
    -- ========================================================

    INSERT INTO
        `dev-bq-509502.demo_sp.employee_target`

    SELECT
        *,
        CURRENT_DATE()
    FROM `dev-bq-509502.demo_sp.employee_staging`;


    -- ========================================================
    -- STEP 2: WRITE EXECUTION DETAILS TO AUDIT TABLE
    -- ========================================================
    --
    -- After loading the target table, insert an audit record.
    --
    -- CURRENT_TIMESTAMP()
    --     Captures the exact execution time.
    --
    -- COUNT(1)
    --     Counts the number of records processed.
    --
    -- 'Success'
    --     Indicates that this execution completed successfully.
    -- ========================================================

    INSERT INTO
        `dev-bq-509502.demo_sp.employee_audit`

    SELECT
        CURRENT_TIMESTAMP() AS load_time,
        COUNT(1) AS records_loaded,
        'Success' AS status

    FROM `dev-bq-509502.demo_sp.employee_staging`;

END;


-- ============================================================
-- CONCEPT 13: INVOKE / EXECUTE STORED PROCEDURE
-- ============================================================
--
-- CALL is used to execute a stored procedure.
--
-- Syntax:
--
--     CALL project.dataset.procedure_name();
--
-- When this procedure executes, it will:
--
--     1. Load staging data into target.
--     2. Insert an audit record.
-- ============================================================

CALL `dev-bq-509502.demo_sp.etl_flow`();


-- ============================================================
-- CONCEPT 14: VERIFY TARGET DATA
-- ============================================================
--
-- After executing the procedure, verify that records have been
-- loaded into the target table.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_sp.employee_target`;


-- ============================================================
-- CONCEPT 15: VERIFY AUDIT LOG
-- ============================================================
--
-- Verify the audit information generated by the procedure.
--
-- Expected information:
--
--     LOAD_TIME
--     RECORDS_LOADED
--     STATUS
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_sp.employee_audit`;


-- ============================================================
--                 UDF vs STORED PROCEDURE
-- ============================================================
--
-- UDF
-- ---
-- Purpose:
--     Calculate/transform a value.
--
-- Input:
--     Can accept parameters.
--
-- Output:
--     Returns a value.
--
-- Example:
--     calculate_bonus(salary, bonus_percentage)
--
--
-- STORED PROCEDURE
-- ----------------
-- Purpose:
--     Execute a sequence of SQL statements/workflow.
--
-- Input:
--     Can accept parameters.
--
-- Output:
--     Primarily performs actions rather than returning a value
--     like a UDF.
--
-- Example:
--     Stage -> Target -> Audit
--
--
-- SIMPLE WAY TO REMEMBER:
--
-- UDF
--     "Give me input and I will CALCULATE something."
--
-- Stored Procedure
--     "Execute this WORKFLOW for me."
--
-- ============================================================
