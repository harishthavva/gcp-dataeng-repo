-- ============================================================
--              PARTITIONING & CLUSTERING IN BIGQUERY
-- ============================================================
--
-- In this demo, we will compare:
--
-- 1. Non-partitioned table
-- 2. Partitioned table
-- 3. Partitioned + Clustered table
--
-- We will use the Stack Overflow public dataset to understand
-- how partitioning and clustering can reduce the amount of data
-- processed by BigQuery.
--
-- IMPORTANT:
-- Partitioning helps BigQuery eliminate unnecessary partitions.
-- Clustering helps BigQuery filter/scan data more efficiently
-- within the selected partitions.
-- ============================================================


-- ============================================================
-- CONCEPT 1: NON-PARTITIONED TABLE
-- ============================================================
--
-- Source table:
-- bigquery-public-data.stackoverflow.comments
--
-- This is a NON-PARTITIONED table for this demonstration.
--
-- Logical size of the source table:
-- Approximately 16.03 GB
--
-- Since the table is not partitioned, BigQuery cannot eliminate
-- partitions based on the CREATION_DATE filter.
-- ============================================================


-- View all records from the non-partitioned public table.
-- This query reads the complete table.

SELECT *
FROM bigquery-public-data.stackoverflow.comments;


-- Filtering based on CREATION_DATE.
--
-- Even though we are requesting data for only one particular date,
-- the source table is not partitioned.
--
-- Therefore, BigQuery cannot perform partition pruning based on
-- CREATION_DATE.
--
-- Students can check the "Bytes processed" value in the query
-- execution details to understand the amount of data processed.

SELECT *
FROM bigquery-public-data.stackoverflow.comments
WHERE DATE(CREATION_DATE) = '2015-06-15';


-- ============================================================
-- CONCEPT 2: CREATE A NON-PARTITIONED TABLE
-- ============================================================
--
-- We are creating our own copy of the Stack Overflow comments
-- table without defining any partitioning.
--
-- Therefore, this table is also a NON-PARTITIONED table.
-- ============================================================

CREATE TABLE IF NOT EXISTS
    `dev-bq-509502.demo_dataset.stackoverflow_comments_non_parition`
AS
SELECT *
FROM bigquery-public-data.stackoverflow.comments;


-- ============================================================
-- CONCEPT 3: CREATE A PARTITIONED TABLE
-- ============================================================
--
-- PARTITION BY:
-- DATE_TRUNC(creation_date, MONTH)
--
-- This creates MONTHLY partitions based on CREATION_DATE.
--
-- Example:
--
-- January 2015  -> One partition
-- February 2015 -> One partition
-- March 2015    -> One partition
-- ...
--
-- Instead of scanning the complete table, BigQuery can identify
-- the required partition when a query contains a suitable filter
-- on CREATION_DATE.
--
-- This is called PARTITION PRUNING.
--
-- Partitioning is useful when queries frequently filter data
-- based on a particular column such as:
--
--   - Date
--   - Timestamp
--   - Integer range
--
-- Here, we are using CREATION_DATE to create monthly partitions.
-- ============================================================

CREATE TABLE IF NOT EXISTS
    `dev-bq-509502.demo_dataset.stackoverflow_comments_parition`
PARTITION BY DATE_TRUNC(creation_date, MONTH)
AS
SELECT *
FROM bigquery-public-data.stackoverflow.comments;


-- ============================================================
-- CONCEPT 4: QUERYING THE NON-PARTITIONED TABLE
-- ============================================================
--
-- We are filtering for a specific date.
--
-- Since this table is NOT partitioned, BigQuery cannot eliminate
-- partitions based on CREATION_DATE.
--
-- Observe the "Bytes processed" in the query execution details.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.stackoverflow_comments_non_parition`
WHERE DATE(CREATION_DATE) = '2015-06-15';


-- ============================================================
-- CONCEPT 5: QUERYING THE PARTITIONED TABLE
-- ============================================================
--
-- The table is partitioned by MONTH using CREATION_DATE.
--
-- The query filters using CREATION_DATE, allowing BigQuery to
-- identify the relevant partition(s).
--
-- This reduces the amount of data that needs to be scanned.
--
-- Compare the "Bytes processed" with the previous query.
--
-- KEY CONCEPT:
-- Partition pruning = BigQuery scans only the required partitions
-- instead of scanning the entire table.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.stackoverflow_comments_parition`
WHERE DATE(CREATION_DATE) = '2015-06-15';


-- ============================================================
--              PARTITIONING + CLUSTERING
-- ============================================================
--
-- Partitioning and clustering solve two different problems.
--
-- PARTITIONING:
-- Divides the table into partitions based on a partitioning
-- column.
--
-- CLUSTERING:
-- Organizes/sorts the data within each partition based on the
-- specified clustering column(s).
--
-- Example:
--
-- Suppose we have 100,000 records.
--
-- Partitioning:
--
--     Partition 1 -> 10,000 records
--     Partition 2 -> 10,000 records
--     ...
--     Partition 10 -> 10,000 records
--
-- Now suppose we CLUSTER BY ID.
--
-- BigQuery organizes the data within each partition based on ID.
--
-- Conceptually:
--
-- Partition 1
--    -> IDs organized into clustering blocks
--
-- Partition 2
--    -> IDs organized into clustering blocks
--
-- ...
--
-- Therefore:
--
-- PARTITIONING = Which partitions should be scanned?
--
-- CLUSTERING = Which data blocks inside those partitions
--              need to be scanned?
-- ============================================================


-- ============================================================
-- CONCEPT 6: CREATE PARTITIONED + CLUSTERED TABLE
-- ============================================================
--
-- PARTITION BY:
--     DATE_TRUNC(creation_date, MONTH)
--
-- Creates monthly partitions based on CREATION_DATE.
--
-- CLUSTER BY:
--     id
--
-- Organizes data within each partition based on ID.
--
-- This is particularly useful when queries commonly contain
-- filters on both:
--
--     1. CREATION_DATE
--     2. ID
--
-- Example query:
--
-- WHERE CREATION_DATE = ...
-- AND ID = ...
--
-- BigQuery can first prune unnecessary partitions and then use
-- clustering information to reduce the amount of data scanned
-- within the relevant partition(s).
-- ============================================================

CREATE TABLE IF NOT EXISTS
    `dev-bq-509502.demo_dataset.stackoverflow_comments_parition_clustering`
PARTITION BY DATE_TRUNC(creation_date, MONTH)
CLUSTER BY id
AS
SELECT *
FROM bigquery-public-data.stackoverflow.comments;


-- ============================================================
-- CONCEPT 7: QUERY PARTITIONED TABLE
-- ============================================================
--
-- The query filters using:
--
--     CREATION_DATE
--     ID
--
-- However, this table has ONLY partitioning based on
-- CREATION_DATE. It does NOT have clustering on ID.
--
-- BigQuery can use partition pruning to identify the required
-- monthly partition.
--
-- However, within that partition, ID is not a clustering column.
--
-- Compare the bytes processed with the partitioned + clustered
-- table query below.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.stackoverflow_comments_parition`
WHERE DATE(CREATION_DATE) = '2016-07-01'
  AND id = 63702758;


-- ============================================================
-- CONCEPT 8: QUERY PARTITIONED + CLUSTERED TABLE
-- ============================================================
--
-- This table is:
--
--     PARTITIONED BY -> CREATION_DATE (Monthly)
--     CLUSTERED BY  -> ID
--
-- The query filters using both columns:
--
--     CREATION_DATE = '2016-07-01'
--     ID = 63702758
--
-- STEP 1:
-- BigQuery uses CREATION_DATE to identify the required partition.
--
-- STEP 2:
-- Within that partition, BigQuery can use the clustering
-- information on ID to reduce the amount of data that needs
-- to be scanned.
--
-- This demonstrates how PARTITIONING + CLUSTERING can work
-- together to improve query efficiency.
--
-- Compare the "Bytes processed" with the previous query.
-- ============================================================

SELECT *
FROM `dev-bq-509502.demo_dataset.stackoverflow_comments_parition_clustering`
WHERE DATE(CREATION_DATE) = '2016-07-01'
  AND id = 63702758;


-- ============================================================
--                KEY TAKEAWAY
-- ============================================================
--
-- PARTITIONING
-- ------------
-- Divides a large table into smaller partitions.
--
-- Example:
--     2015-01
--     2015-02
--     2015-03
--     ...
--
-- Main benefit:
-- Partition pruning reduces the amount of data scanned by
-- eliminating unnecessary partitions.
--
--
-- CLUSTERING
-- ----------
-- Organizes data within each partition based on one or more
-- clustering columns.
--
-- Main benefit:
-- BigQuery can reduce the number of data blocks scanned within
-- the selected partition(s).
--
--
-- PARTITIONING + CLUSTERING
-- -------------------------
-- Partitioning determines:
--     "Which partitions do I need?"
--
-- Clustering helps determine:
--     "Which data blocks inside those partitions do I need?"
--
--
-- SIMPLE WAY TO REMEMBER:
--
-- PARTITIONING -> Divide the table
-- CLUSTERING   -> Organize data within the partitions
--
-- ============================================================
