-- ============================================================
--                    BIGQUERY DATE FUNCTIONS
-- ============================================================
--
-- In this demo, we will learn commonly used BigQuery DATE
-- functions with employee data.
--
-- Functions covered:
--
-- 1. DATE_ADD()
-- 2. CURRENT_DATE()
-- 3. CURRENT_TIMESTAMP()
-- 4. DATE_DIFF()
-- 5. EXTRACT()
--
-- We will also understand some real-time business use cases
-- for these functions.
-- ============================================================


-- ============================================================
-- CONCEPT 1: VIEW EMPLOYEE DATA
-- ============================================================
--
-- Retrieve all employee records from the native table.
--
-- Important date columns in this table:
--
--     HIRE_DATE       -> Employee joining date
--     DATE_OF_BIRTH   -> Employee date of birth
--
-- These columns will be used for our DATE function examples.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 2: DATE_ADD()
-- ============================================================
--
-- BUSINESS USE CASE:
-- Prohibition Period = 90 days
--
-- Suppose an employee has a prohibition/probation period of
-- 90 days from the date of joining.
--
-- Formula:
--
--     Prohibition End Date
--     =
--     Employee Joining Date + 90 Days
--
-- BigQuery DATE_ADD() is used to add a specific time interval
-- to a DATE value.
--
-- Syntax:
--
--     DATE_ADD(date, INTERVAL value DAY)
--
-- Example:
--
--     Hire Date = 2018-06-15
--     + 90 days
--     = Prohibition End Date
-- ============================================================

SELECT
    employee_id,
    full_name,
    hire_date,

    -- Add 90 days to the employee's hire date.
    DATE_ADD(hire_date, INTERVAL 90 DAY) AS prohibition_end_date

FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 3: CURRENT_DATE()
-- ============================================================
--
-- CURRENT_DATE() returns today's date based on the execution
-- environment/time zone.
--
-- Example:
--
--     2026-09-29
--
-- This is commonly used when we need to compare employee dates
-- with today's date.
-- ============================================================

SELECT
    CURRENT_DATE() AS current_date;


-- ============================================================
-- CONCEPT 4: CURRENT_TIMESTAMP()
-- ============================================================
--
-- CURRENT_TIMESTAMP() returns the current date and time
-- including time zone information.
--
-- Example:
--
--     2026-09-29 03:40:00+00
--
-- USE CASE:
-- Useful when the exact date + time is required, such as:
--
--     - Audit columns
--     - Record creation time
--     - Last updated timestamp
--     - Job execution time
--     - Event processing time
-- ============================================================

SELECT
    CURRENT_TIMESTAMP() AS current_timestamp;


-- ============================================================
-- CONCEPT 5: DATE_DIFF()
-- ============================================================
--
-- BUSINESS USE CASE:
-- Calculate the current age of an employee based on their
-- Date of Birth.
--
-- Formula:
--
--     Current Date - Date of Birth = Employee Age
--
-- DATE_DIFF() calculates the difference between two DATE values.
--
-- Syntax:
--
--     DATE_DIFF(end_date, start_date, date_part)
--
-- Here:
--
--     End Date   = CURRENT_DATE()
--     Start Date = DATE_OF_BIRTH
--     Date Part  = YEAR
--
-- NOTE:
-- For exact age calculation, especially around birthdays,
-- DATE_DIFF(..., YEAR) can differ from the person's completed age.
-- For production-grade age calculation, compare the birthday
-- within the current year as well.
-- ============================================================

SELECT
    employee_id,
    full_name,
    date_of_birth,

    -- Calculate the difference between today's date and DOB
    -- in terms of calendar year boundaries.
    DATE_DIFF(
        CURRENT_DATE(),
        DATE_OF_BIRTH,
        YEAR
    ) AS current_age

FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 6: EXTRACT()
-- ============================================================
--
-- EXTRACT() is used to extract a specific part of a DATE,
-- DATETIME, TIMESTAMP, or TIME value.
--
-- Common date parts:
--
--     YEAR
--     MONTH
--     DAY
--     QUARTER
--     DAYOFWEEK
--     DAYOFYEAR
--
-- Example:
--
--     Hire Date = 2018-06-15
--
--     YEAR  -> 2018
--     MONTH -> 6
--     DAY   -> 15
-- ============================================================

SELECT
    employee_id,
    hire_date,

    -- Extract the year from the hire date.
    EXTRACT(YEAR FROM hire_date) AS year,

    -- Extract the month from the hire date.
    EXTRACT(MONTH FROM hire_date) AS month,

    -- Extract the day from the hire date.
    EXTRACT(DAY FROM hire_date) AS day

FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;


-- ============================================================
-- CONCEPT 7: FILTER DATA USING EXTRACT()
-- ============================================================
--
-- BUSINESS USE CASE:
-- Find employees who joined in June 2018.
--
-- Instead of comparing the complete date, we extract:
--
--     YEAR  = 2018
--     MONTH = 6
--
-- This allows us to filter records based on individual
-- components of a date.
-- ============================================================

SELECT
    employee_id,
    hire_date,

    EXTRACT(YEAR FROM hire_date) AS year,
    EXTRACT(MONTH FROM hire_date) AS month,
    EXTRACT(DAY FROM hire_date) AS day

FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`

WHERE EXTRACT(YEAR FROM hire_date) = 2018
  AND EXTRACT(MONTH FROM hire_date) = 6;


-- ============================================================
--                    KEY TAKEAWAY
-- ============================================================
--
-- DATE_ADD()
-- ----------
-- Adds an interval to a date.
--
-- Example:
-- Hire Date + 90 Days = Prohibition End Date
--
--
-- CURRENT_DATE()
-- --------------
-- Returns the current date.
--
--
-- CURRENT_TIMESTAMP()
-- -------------------
-- Returns the current date and time.
--
--
-- DATE_DIFF()
-- -----------
-- Calculates the difference between two dates.
--
-- Example:
-- Current Date - DOB = Age
--
--
-- EXTRACT()
-- ---------
-- Extracts individual components from a date.
--
-- Example:
-- Hire Date -> YEAR / MONTH / DAY
--
--
-- SIMPLE WAY TO REMEMBER:
--
-- DATE_ADD   -> Add time to a date
-- DATE_DIFF  -> Find difference between dates
-- EXTRACT    -> Get a specific part of a date
-- CURRENT_DATE -> Today's date
-- CURRENT_TIMESTAMP -> Current date + time
--
-- ============================================================
