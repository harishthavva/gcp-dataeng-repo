-- ============================================================
--          BIGQUERY NATIVE TABLE vs EXTERNAL TABLE
-- ============================================================
--
-- In this demo, we will understand the difference between:
--
-- 1. Native Table
-- 2. External Table
--
-- KEY DIFFERENCE:
--
-- NATIVE TABLE
--     Data is stored in BigQuery managed storage.
--     BigQuery manages the physical storage of the data.
--     We can perform both READ and WRITE/DML operations.
--
-- EXTERNAL TABLE
--     Data remains in an external data source such as:
--     Google Cloud Storage (GCS).
--     BigQuery only provides a table interface to query the
--     external data.
--
--     Therefore, the underlying external data is not modified
--     using normal BigQuery DML operations.
-- ============================================================


-- ============================================================
-- CONCEPT 1: READING DATA FROM A NATIVE TABLE
-- ============================================================
--
-- This table contains 1,000 employee records.
--
-- COUNT(1) returns the total number of records in the table.
--
-- Since this is a NATIVE TABLE, the data is stored in
-- BigQuery-managed storage.
-- ============================================================

SELECT COUNT(1)
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`;
-- Expected result: 1000


-- ============================================================
-- CONCEPT 2: READING DATA FROM AN EXTERNAL TABLE
-- ============================================================
--
-- This external table contains 1,001 records.
--
-- The table definition exists in BigQuery, but the actual data
-- is stored outside BigQuery, for example in Google Cloud Storage.
--
-- BigQuery reads the data from the external source when we query
-- the external table.
-- ============================================================

SELECT COUNT(1)
FROM `dev-bq-509502.demo_dataset.employee_gcs_external`;
-- Expected result: 1001


-- ============================================================
--                 NATIVE TABLE - DML
-- ============================================================
--
-- DML = Data Manipulation Language
--
-- Common DML operations include:
--
--     INSERT
--     UPDATE
--     DELETE
--     MERGE
--
-- Native BigQuery tables support DML operations because the data
-- is stored in BigQuery-managed storage.
-- ============================================================


-- ============================================================
-- CONCEPT 3: SELECT FROM NATIVE TABLE
-- ============================================================
--
-- Retrieve the employee whose EMPLOYEE_ID is EMP0155.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`
WHERE employee_id = 'EMP0155';


-- ============================================================
-- CONCEPT 4: UPDATE NATIVE TABLE
-- ============================================================
--
-- Updating LAST_NAME from its existing value to 'Sharma'
-- for employee EMP0155.
--
-- This operation is allowed because this is a native
-- BigQuery table.
-- ============================================================

UPDATE `dev-bq-509502.demo_dataset.employee_gcs_native_table`
SET LAST_NAME = 'Sharma'
WHERE employee_id = 'EMP0155';


-- Verify the UPDATE operation.
--
-- The result should show LAST_NAME = 'Sharma'.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.employee_gcs_native_table`
WHERE employee_id = 'EMP0155';


-- ============================================================
--               EXTERNAL TABLE - DML
-- ============================================================
--
-- External tables are different from native tables.
--
-- The actual data is stored in an external system such as GCS.
--
-- BigQuery can query/read the external data, but standard DML
-- operations such as UPDATE and DELETE cannot be used to modify
-- the underlying external file data through the external table.
-- ============================================================


-- ============================================================
-- CONCEPT 5: SELECT FROM EXTERNAL TABLE
-- ============================================================
--
-- We can READ/query data from an external table just like
-- a BigQuery table.
--
-- Here, we are retrieving employee EMP0155.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.employee_gcs_external`
WHERE employee_id = 'EMP0155';


-- ============================================================
-- CONCEPT 6: UPDATE EXTERNAL TABLE
-- ============================================================
--
-- This UPDATE operation is NOT supported for a standard
-- BigQuery external table.
--
-- Why?
--
-- Because the actual data is stored in the external source
-- (for example, a file in GCS), not in BigQuery managed storage.
--
-- BigQuery cannot use a normal UPDATE statement to modify
-- the underlying external file through the external table.
--
-- Therefore, this statement will result in an error.
-- ============================================================

UPDATE `dev-bq-509502.demo_dataset.employee_gcs_external`
SET LAST_NAME = 'Sharma'
WHERE employee_id = 'EMP0155';


-- ============================================================
--                    KEY TAKEAWAY
-- ============================================================
--
-- NATIVE TABLE
-- ------------
-- Data is stored in:
--     BigQuery managed storage
--
-- Operations:
--     READ  -> YES
--     INSERT -> YES
--     UPDATE -> YES
--     DELETE -> YES
--     MERGE  -> YES
--
--
-- EXTERNAL TABLE
-- --------------
-- Data is stored in:
--     External data source such as GCS
--
-- Operations:
--     READ -> YES
--     Normal DML modification of external data -> NO
--
--
-- SIMPLE WAY TO REMEMBER:
--
-- NATIVE TABLE
--     BigQuery owns/manages the data.
--     Therefore, BigQuery can read AND modify the data.
--
-- EXTERNAL TABLE
--     Data stays outside BigQuery.
--     BigQuery primarily provides a way to READ/query that data.
--
-- ============================================================
