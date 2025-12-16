-- -----------------------------------------------------------------------
-- FILE 1: BigQuery (Analytical) Table Setup
-- Purpose: Stores the historical, aggregated risk scores and features
-- generated periodically by a BigQuery ML fraud detection model.
-- -----------------------------------------------------------------------

-- 1. Create a Historical Training Data Table
-- This table contains the features used to train the fraud model.
CREATE OR REPLACE TABLE `my-alloydb-project-vivekshinde.bq_fraud_detection.fraud_historical_data` (
    customer_id INT64 NOT NULL,
    total_transactions_90d INT64,    -- Feature: High frequency suggests risk
    avg_txn_amount_usd FLOAT64,      -- Feature: Deviation from average suggests risk
    is_new_device_login BOOL,        -- Feature: Login from a new location/device
    is_fraud INT64                  -- LABEL: 1 for fraud, 0 for legitimate (what we predict)
);

-- 2. Sample Data Insertion (Illustrative training set)
INSERT INTO `my-alloydb-project-vivekshinde.bq_fraud_detection.fraud_historical_data` 
(customer_id, total_transactions_90d, avg_txn_amount_usd, is_new_device_login, is_fraud)
VALUES
(1001, 150, 450.00, TRUE, 1),   -- High frequency, high amount, new device -> FRAUD (1)
(1002, 5, 25.50, FALSE, 0),     -- Low activity, low amount -> LEGITIMATE (0)
(1003, 75, 1200.00, TRUE, 1),  -- Moderate activity, very high average -> FRAUD (1)
(1004, 25, 80.00, FALSE, 0),    -- Normal behavior -> LEGITIMATE (0)
(1005, 210, 50.00, TRUE, 0),    -- Very high frequency, low amount -> LEGITIMATE (0, possible bot)
(1006, 2, 2500.00, TRUE, 1);    -- Very low activity, very high amount -> FRAUD (1)


-- 3. BigQuery ML Model Creation (Logistic Regression for Binary Classification)
-- This creates a model that learns the relationship between the features and the fraud label.
CREATE OR REPLACE MODEL `my-alloydb-project-vivekshinde.bq_fraud_detection.fraud_detection_model`
OPTIONS(
    model_type='LOGISTIC_REG',
    input_label_cols=['is_fraud']
) AS
SELECT
    total_transactions_90d,
    avg_txn_amount_usd,
    is_new_device_login,
    is_fraud
FROM
    `my-alloydb-project-vivekshinde.bq_fraud_detection.fraud_historical_data`;

-- 1. Create the BigQuery Table
CREATE TABLE IF NOT EXISTS `my-alloydb-project-vivekshinde.bq_fraud_detection.historical_risk_profile` (
    customer_id INT64 NOT NULL,
    risk_score FLOAT64,              -- Score derived from historical BQ ML model
    risk_segment STRING,             -- 'High', 'Medium', 'Low'
    last_flag_date DATE              -- Date of the last suspicious event
);

-- 2. Sample Data Insertion (Represents millions of rows)
INSERT INTO `my-alloydb-project-vivekshinde.bq_fraud_detection.historical_risk_profile` 
(customer_id, risk_score, risk_segment, last_flag_date)
VALUES
(1001, 0.95, 'High', '2025-11-15'),
(1002, 0.12, 'Low', NULL),
(1003, 0.68, 'Medium', '2025-08-20'),
(1004, 0.88, 'High', '2025-11-10'),
(1005, 0.30, 'Low', NULL);



