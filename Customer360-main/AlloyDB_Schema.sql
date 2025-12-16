-- ----------------------------------------------------------------------------------
-- FILE 2: AlloyDB (Operational) Setup - Customer 360
-- Purpose: Stores live, high-velocity operational data.
-- ----------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.customer_status (
    customer_id INT PRIMARY KEY,
    current_status VARCHAR(50) NOT NULL,
    pending_claims INT DEFAULT 0,
    recent_activity_timestamp TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

INSERT INTO public.customer_status 
(customer_id, current_status, pending_claims, recent_activity_timestamp)
VALUES
(9001, 'Active', 0, NOW()),
(9003, 'Suspended', 0, NOW() - INTERVAL '10 minutes')
ON CONFLICT (customer_id) DO NOTHING;
