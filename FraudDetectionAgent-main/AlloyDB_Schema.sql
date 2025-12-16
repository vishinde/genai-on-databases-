-- USE DATABASE frauddetect

-- 1. Create the Live Transaction Table
CREATE TABLE IF NOT EXISTS public.live_transactions (
    transaction_id BIGINT PRIMARY KEY,
    customer_id INT NOT NULL,
    transaction_amount NUMERIC(10, 2) NOT NULL,
    transaction_timestamp TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    device_fingerprint TEXT, -- Feature used for real-time check
    status VARCHAR(20) DEFAULT 'PENDING'
);

-- 2. Insert Sample Live Transactions (Executed constantly by the application)
INSERT INTO public.live_transactions 
(transaction_id, customer_id, transaction_amount, device_fingerprint) 
VALUES
(5001, 1001, 550.00, 'device_A'), -- High risk customer, new device
(5002, 1002, 15.00, 'device_B'), -- Low risk customer, standard device
(5003, 1004, 899.99, 'device_A'); -- High risk customer, known device

-- 3. Create a simplified AlloyDB Vector Store table
-- For a Fraud Detection system, the log_summary in your customer_unstructured_data table should represent aggregated, 
-- semantically meaningful text data that captures customer behavior, intent, and communications. 
-- This type of data is excellent for uncovering "soft" fraud signals that rule-based systems might miss.
-- This supports the Hybrid RAG deep dive
CREATE EXTENSION IF NOT EXISTS vector;
CREATE TABLE IF NOT EXISTS public.customer_unstructured_data (
    customer_id INT PRIMARY KEY,
    log_summary TEXT,
    context_source VARCHAR(50), -- NEW COLUMN: Source of the unstructured data
    log_embedding VECTOR(3) -- Simplified vector dimension for demo
);

INSERT INTO public.customer_unstructured_data
(customer_id, log_summary, context_source, log_embedding)
VALUES
(1001, 'Recent account login failure, high transaction attempt.', 'API Log', '[0.9, 0.1, 0.5]'),
(1002, 'Standard activity pattern.', 'System Log', '[0.1, 0.8, 0.2]'),
(1003, 'Customer initiated chat asking repeatedly about withdrawal limits and account transfer hold times.', 'Chat Transcript', '[0.6, 0.3, 0.4]'),
(1004, 'Email from unusual domain requesting a change in beneficiary information and address on file.', 'Email System', '[0.95, 0.05, 0.8]');

-- 4. Sample AlloyDB Query (Operational App Check)
-- An operational application checking the transaction amount before processing.
SELECT transaction_amount FROM public.live_transactions WHERE transaction_id = 5001;
