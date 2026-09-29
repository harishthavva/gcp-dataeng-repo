-- ============================================================
--              BIGQUERY VIEWS & TYPE CASTING
-- ============================================================
--
-- This demo covers the following BigQuery concepts:
--
-- 1. Standard / Logical View
-- 2. Materialized View
-- 3. Authorized View
-- 4. INFORMATION_SCHEMA / Metadata
-- 5. Type Casting
-- 6. CAST()
-- 7. SAFE_CAST()
--
-- ============================================================



-- ============================================================
--                  SECTION 1: VIEWS
-- ============================================================
--
-- A VIEW is a virtual table based on a SQL query.
--
-- A view does not normally store a separate copy of the
-- underlying data.
--
-- Instead, the view stores the SQL query definition.
--
-- When users query the view, BigQuery executes the view query
-- against the underlying/base tables.
-- ============================================================


-- ============================================================
-- CONCEPT 1: READ DATA FROM A VIEW
-- ============================================================
--
-- The following query returns the number of records available
-- through the view.
--
-- COUNT(1) returns the total number of rows.
-- ============================================================

-- SELECT COUNT(1)
-- FROM `dev-bq-509502.v_demo_dataset.v_employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 2: SELECT DATA FROM A VIEW
-- ============================================================
--
-- We can query a view in the same way we query a table.
--
-- The important difference is that the view contains a SQL
-- definition that references the underlying/base table.
-- ============================================================

-- SELECT *
-- FROM `dev-bq-509502.v_demo_dataset.v_employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 3: DML ON A VIEW
-- ============================================================
--
-- A standard view should be treated as a READ interface to
-- the underlying data.
--
-- We generally perform DML operations such as UPDATE directly
-- on the underlying/base table rather than treating the view
-- as a physical table.
--
-- The following example demonstrates an attempted UPDATE
-- through the view.
-- ============================================================

-- UPDATE
-- `dev-bq-509502.v_demo_dataset.v_employee_gcs_native_table`
-- SET LAST_NAME = 'HARISH'
-- WHERE EMPLOYEE_ID = 'EMP0790';



-- ============================================================
--                  TYPES OF VIEWS
-- ============================================================
--
-- Common BigQuery view concepts:
--
-- 1. Standard / Logical View
-- 2. Materialized View
-- 3. Authorized View
--
-- ============================================================


-- ============================================================
-- CONCEPT 4: STANDARD / LOGICAL VIEW
-- ============================================================
--
-- A standard view stores the SQL query definition rather than
-- storing a separate copy of the query result.
--
-- When the view is queried, BigQuery evaluates the view query
-- against the underlying/base table.
--
-- USE CASE:
--     - Hide complex SQL logic
--     - Provide a simplified interface to users
--     - Restrict the columns/rows exposed to users
--     - Reuse commonly required SQL logic
-- ============================================================


-- ============================================================
-- CONCEPT 5: DROP VIEW
-- ============================================================
--
-- DROP VIEW removes the view definition.
--
-- IMPORTANT:
-- Dropping a view does NOT mean that the underlying/base table
-- is deleted.
-- ============================================================

-- DROP VIEW
-- `dev-bq-509502.v_demo_dataset.v_employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 6: CREATE STANDARD VIEW
-- ============================================================
--
-- CREATE VIEW creates a logical/standard view.
--
-- Here, the view is based on the employee native table.
--
-- The view stores the SELECT query definition.
-- ============================================================

-- CREATE VIEW
-- `dev-bq-509502.v_demo_dataset.v_employee_gcs_native_table`
-- AS
-- SELECT *
-- FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;



-- ============================================================
--              MATERIALIZED VIEW
-- ============================================================
--
-- A materialized view stores precomputed results for supported
-- queries.
--
-- BigQuery can maintain the materialized view as the underlying
-- data changes and can use it to optimize eligible queries.
--
-- IMPORTANT:
-- A materialized view is different from a standard view because
-- it has stored/precomputed data rather than only storing the
-- SQL definition.
--
-- USE CASE:
--     Useful for frequently executed aggregation queries where
--     precomputed results can reduce the amount of computation.
-- ============================================================


-- ============================================================
-- CONCEPT 7: CREATE MATERIALIZED VIEW
-- ============================================================
--
-- The following creates a materialized view based on the
-- employee table.
--
-- NOTE:
-- In real projects, materialized views are typically created
-- for supported, frequently used query patterns, especially
-- aggregations.
-- ============================================================

-- CREATE MATERIALIZED VIEW
-- `dev-bq-509502.v_demo_dataset.mv_employee_gcs_native_table`
-- AS
-- SELECT *
-- FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;



-- ============================================================
--                 AUTHORIZED VIEW
-- ============================================================
--
-- An Authorized View is used mainly for DATA SECURITY.
--
-- It allows users to query selected data through a view without
-- giving them direct access to the underlying/base table.
--
-- REAL-TIME BUSINESS USE CASE:
--
-- Suppose the employee table contains:
--
--     EMPLOYEE_ID
--     FULL_NAME
--     SALARY
--     BANK_ACCOUNT
--     SSN
--
-- We may want users to see:
--
--     EMPLOYEE_ID
--     FULL_NAME
--
-- but NOT:
--
--     SALARY
--     BANK_ACCOUNT
--     SSN
--
-- We can create a view that exposes only the permitted columns
-- and authorize users to access the view.
--
-- This is commonly used when implementing controlled access
-- to sensitive data.
--
-- Example business scenario:
-- INVESTRAN
--
-- Authorized views can be useful when different teams need
-- controlled access to selected information without direct
-- access to the underlying sensitive table.
-- ============================================================



-- ============================================================
--                  SECTION 2: METADATA
-- ============================================================
--
-- BigQuery provides INFORMATION_SCHEMA views to retrieve
-- metadata about datasets, tables, columns, jobs, etc.
--
-- INFORMATION_SCHEMA is useful for:
--
--     - Finding column names
--     - Finding data types
--     - Finding table information
--     - Checking table DDL
--     - Building metadata-driven processes
-- ============================================================


-- ============================================================
-- CONCEPT 8: INFORMATION_SCHEMA.COLUMNS
-- ============================================================
--
-- INFORMATION_SCHEMA.COLUMNS provides metadata about columns
-- in tables.
--
-- We can retrieve:
--
--     COLUMN_NAME
--     DATA_TYPE
--     IS_NULLABLE
--     ORDINAL_POSITION
--     and other column metadata.
--
-- Here, we are retrieving the column metadata for the
-- employee_gcs_native_table.
-- ============================================================

SELECT *
FROM `demo_dataset.INFORMATION_SCHEMA.COLUMNS`
WHERE TABLE_NAME = 'employee_gcs_native_table';


-- ============================================================
-- CONCEPT 9: FIND COLUMNS OF A SPECIFIC DATA TYPE
-- ============================================================
--
-- We can filter INFORMATION_SCHEMA.COLUMNS based on DATA_TYPE.
--
-- Here, we are retrieving only columns whose data type is INT64.
--
-- USE CASE:
-- Useful when we need to identify all integer columns in a table
-- for metadata-driven processing or data validation.
-- ============================================================

SELECT COLUMN_NAME
FROM `demo_dataset.INFORMATION_SCHEMA.COLUMNS`
WHERE TABLE_NAME = 'employee_gcs_native_table'
  AND DATA_TYPE = 'INT64';


-- ============================================================
-- CONCEPT 10: INFORMATION_SCHEMA.TABLES
-- ============================================================
--
-- INFORMATION_SCHEMA.TABLES provides metadata about tables
-- and views.
--
-- The DDL column contains the CREATE statement used to define
-- the table/view.
--
-- USE CASE:
-- Useful for understanding or extracting the definition of
-- existing database objects.
-- ============================================================

SELECT DDL
FROM `demo_dataset.INFORMATION_SCHEMA.TABLES`
WHERE TABLE_NAME = 'employee_gcs_native_table';



-- ============================================================
--                  SECTION 3: TYPE CASTING
-- ============================================================
--
-- TYPE CASTING means converting a value from one data type
-- to another data type.
--
-- Example:
--
--     STRING  -> INT64
--     INT64   -> STRING
--     STRING  -> FLOAT64
--     FLOAT64 -> INT64
--
-- BigQuery provides:
--
--     CAST()
--     SAFE_CAST()
--
-- ============================================================


-- ============================================================
-- CONCEPT 11: VIEW THE SOURCE DATA
-- ============================================================
--
-- First, let's look at the employee table before performing
-- type conversion.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 12: CAST() - FLOAT64/NUMERIC TO STRING
-- ============================================================
--
-- Suppose BONUS_PERCENTAGE is stored as a numeric data type,
-- but we need it as a STRING.
--
-- CAST() converts the value into the requested target data type.
--
-- Syntax:
--
--     CAST(expression AS data_type)
--
-- Here:
--
--     BONUS_PERCENTAGE -> STRING
-- ============================================================

SELECT
    CAST(bonus_percentage AS STRING) AS bonus_percentage
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 13: CAST() - TO FLOAT64
-- ============================================================
--
-- Here, we are converting BONUS_PERCENTAGE into FLOAT64.
--
-- The original column and converted column are displayed
-- together so that students can compare the values.
-- ============================================================

SELECT
    bonus_percentage,
    CAST(bonus_percentage AS FLOAT64) AS bonus_percentage_new
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 14: CREATE A NEW TABLE WITH A CASTED COLUMN
-- ============================================================
--
-- CREATE OR REPLACE TABLE creates the table if it doesn't exist
-- or replaces the existing table if it already exists.
--
-- Here:
--
--     1. All existing employee columns are selected.
--     2. BONUS_PERCENTAGE is converted to STRING.
--     3. The converted value is stored as a new column.
--
-- USE CASE:
-- Useful when creating a transformed/curated table with the
-- required target data types.
-- ============================================================

CREATE OR REPLACE TABLE
    `dev-bq-509502.demo_dataset.dummy_table`
AS
SELECT
    *,
    CAST(bonus_percentage AS STRING) AS bonus_percentage_new
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 15: CAST() - NUMERIC TO INT64
-- ============================================================
--
-- Here, SALARY is converted to INT64.
--
-- This is useful when the source data type is different from
-- the required target data type.
--
-- IMPORTANT:
-- Converting a value from a decimal type to INT64 can result
-- in loss of the fractional portion.
-- ============================================================

SELECT
    salary,
    CAST(salary AS INT64) AS latest
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 16: STRING TO INT64
-- ============================================================
--
-- CAST() can convert a valid numeric STRING into INT64.
--
-- Input:
--     '1' -> STRING
--
-- Output:
--     1 -> INT64
-- ============================================================

SELECT CAST('1' AS INT64);


-- ============================================================
-- CONCEPT 17: INT64 TO STRING
-- ============================================================
--
-- CAST() can also convert an INT64 value into STRING.
--
-- Input:
--     1 -> INT64
--
-- Output:
--     '1' -> STRING
-- ============================================================

SELECT CAST(1 AS STRING);


-- ============================================================
-- CONCEPT 18: SAFE_CAST()
-- ============================================================
--
-- SAFE_CAST() is safer than CAST() when the input data may
-- contain invalid values.
--
-- Example:
--
--     'E123' cannot be converted to INT64.
--
-- CAST() would generate an error.
--
-- SAFE_CAST() returns NULL instead of failing the query.
--
-- This is especially useful in ETL/ELT pipelines when source
-- data may contain invalid or unexpected values.
-- ============================================================

SELECT SAFE_CAST('E123' AS INT64);


-- ============================================================
--                  CAST vs SAFE_CAST
-- ============================================================
--
-- CAST()
-- -------
-- Invalid conversion -> Query ERROR
--
-- Example:
--
--     CAST('E123' AS INT64)
--     -> ERROR
--
--
-- SAFE_CAST()
-- -----------
-- Invalid conversion -> NULL
--
-- Example:
--
--     SAFE_CAST('E123' AS INT64)
--     -> NULL
--
--
-- SIMPLE WAY TO REMEMBER:
--
-- CAST      -> Strict conversion
-- SAFE_CAST -> Safe conversion
--
-- ============================================================


-- ============================================================
--                    KEY TAKEAWAY
-- ============================================================
--
-- VIEWS
-- -----
-- A view provides a virtual/logical interface to underlying data.
--
--
-- STANDARD VIEW
-- -------------
-- Stores the query definition.
--
--
-- MATERIALIZED VIEW
-- -----------------
-- Stores/precomputes results for supported query patterns and
-- can reduce repeated computation.
--
--
-- AUTHORIZED VIEW
-- ---------------
-- Used to provide controlled access to selected data without
-- granting direct access to the underlying table.
--
--
-- INFORMATION_SCHEMA
-- ------------------
-- Used to retrieve metadata about database objects.
--
--
-- CAST()
-- ------
-- Converts one data type into another.
--
--
-- SAFE_CAST()
-- -----------
-- Converts data types safely and returns NULL when conversion
-- is not possible.
--
-- ============================================================
