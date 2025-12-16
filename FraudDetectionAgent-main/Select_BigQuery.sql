-- 1. Sample Model Prediction Query (Illustrative)
-- This shows how the model is used to generate a risk score for new data.
SELECT 
    *
FROM
    ML.PREDICT(MODEL `my-alloydb-project-vivekshinde.bq_fraud_detection.fraud_detection_model`, 
        (
            SELECT 
                15 AS total_transactions_90d, 
                1500.00 AS avg_txn_amount_usd, 
                TRUE AS is_new_device_login
        )
    );

-- 2. Sample BigQuery ML Query (How the data would be generated)
-- This query is illustrative; actual model training uses the CREATE MODEL syntax.
SELECT 
    history.customer_id,
    prediction_output.predicted_is_fraud
FROM
    ML.PREDICT(MODEL `my-alloydb-project-vivekshinde.bq_fraud_detection.fraud_detection_model`, 
        (SELECT * FROM `my-alloydb-project-vivekshinde.bq_fraud_detection.fraud_historical_data`)) AS prediction_output
INNER JOIN 
    `my-alloydb-project-vivekshinde.bq_fraud_detection.fraud_historical_data` As history
ON history.customer_id = prediction_output.customer_id
WHERE 
    history.customer_id = 1001;
