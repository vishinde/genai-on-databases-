Act as a Python developer expert in Google's Agent Development Kit (ADK) and the Model Context Protocol (MCP) Toolbox.

Your task is to generate the complete configuration files necessary to deploy a 'Fraud Analyst' Agent.

The Agent's Goal: To securely access real-time transaction data and historical risk scores using a single tool that executes a BigQuery federated query on AlloyDB.

### Input Data and Core Logic

The Agent must operate on the following data points retrieved by the federated query and apply the following rule:

- **Input Features (from BigQuery Query Output):** customer_id, transaction_amount, bqml_risk_score, risk_segment.
- **Scoring Rule:** A transaction is **FRAUDULENT** if the 'bqml_risk_score' is greater than 0.5 AND the 'risk_segment' is 'High' or 'CRITICAL'. Otherwise, it is NOT FRAUDULENT.

### Tool Definition (tools.yaml)

Generate the complete contents for a **tools.yaml** file.
1. Define the BigQuery source.
2. Create a tool named **realtime\_fraud\_check** with no parameters.
3. The tool's statement must contain the following BigQuery federated query (which is limited to 5 pending transactions for the demo):

```sql
SELECT
    live.customer_id,
    live.amount AS transaction_amount,
    hist.bqml_risk_score,
    hist.risk_segment
FROM
    EXTERNAL_QUERY(
        'us.bq_alloydb_fraud_conn',
        '''
        SELECT 
            customer_id, 
            amount
        FROM 
            public.transactions_live 
        WHERE 
            status = 'PENDING' 
        LIMIT 5 
        '''
    ) AS live
LEFT JOIN
    `my-alloydb-project-vivekshinde.bq_fraud_detection.historical_risk_profile` AS hist
ON live.customer_id = hist.customer_id;
