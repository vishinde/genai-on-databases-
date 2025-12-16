-- ----------------------------------------------------------------------------------
-- FILE 1: BigQuery (Analytical) Setup - Customer 360
-- Purpose: Stores aggregated and historical customer data.
-- ----------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `your_project.your_dataset.customer_analytics` (
    customer_id INT64 NOT NULL,
    customer_name STRING,
    customer_segment STRING,
    lifetime_value_usd NUMERIC,
    total_policy_count INT64
);

INSERT INTO `your_project.your_dataset.customer_analytics` 
(customer_id, customer_name, customer_segment, lifetime_value_usd, total_policy_count)
VALUES
(9001, 'Alice Johnson', 'Premium', 12500.50, 4),
(9003, 'Charles Lee', 'Churn Risk', 150.99, 1);
