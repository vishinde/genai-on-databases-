-- ----------------------------------------------------------------------------------
-- FILE 3: BigQuery Federated Query - Customer 360 Join
-- Purpose: Merges live status from AlloyDB with historical LTV from BigQuery.
-- ----------------------------------------------------------------------------------

SELECT
    a.customer_id,
    a.current_status,
    b.lifetime_value_usd,
    b.customer_segment,
    a.recent_activity_timestamp
FROM
    `your_project.your_dataset.customer_analytics` AS b
INNER JOIN
    EXTERNAL_QUERY(
        'us.bq_alloydb_conn', 
        '''
        SELECT 
            customer_id, 
            current_status, 
            recent_activity_timestamp
        FROM 
            public.customer_status 
        WHERE 
            customer_id = 9003
        '''
    ) AS a
ON a.customer_id = b.customer_id
WHERE b.customer_id = 9003;
