-- 1. Enable the pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Create the Users Table (The Relational Metadata)
-- This holds the "source of truth" for who the user is.
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    job_level INT,       -- Stored as an integer (e.g., 3 for L3) for easy comparison
    location VARCHAR(50), -- e.g., 'California', 'Texas', 'Global'
    department VARCHAR(100)
);

-- 3. Create the Policies Table (The Vector Knowledge Base)
-- This stores the text snippets and their high-dimensional embeddings.
CREATE TABLE IF NOT EXISTS policies (
    policy_id SERIAL PRIMARY KEY,
    content TEXT,                        -- The actual text from the MD files
    embedding VECTOR(768),               -- 768 is the dimension for Vertex AI 'text-embedding-004'
    required_level INT DEFAULT 1,        -- Minimum level required to see this policy
    region VARCHAR(50) DEFAULT 'Global', -- Targeted region
    policy_type VARCHAR(50)              -- e.g., 'Travel', 'Benefits', 'Executive'
);

-- 4. Create an HNSW Index for Fast Vector Search
-- This is a key "Scale" feature to highlight for Enterprise audiences
CREATE INDEX ON policies USING hnsw (embedding vector_cosine_ops);

-- Insert Sample Users
INSERT INTO users (name, job_level, location, department) VALUES 
('Alice', 3, 'Texas', 'Engineering'),
('Bob', 8, 'California', 'Sales');

-- Insert Sample Policies (Assuming you've generated embeddings for the text)
-- Note: '0.12, 0.45...' is a placeholder for the actual vector array
INSERT INTO policies (content, required_level, region, policy_type, embedding) VALUES 
('The standard daily meal allowance for business travel is $75 USD per day...', 1, 'Global', 'Travel', '[0.12, 0.45, ...]'),
('California employees receive a $500 annual stipend for gym memberships...', 1, 'California', 'Benefits', '[0.22, 0.11, ...]'),
('L8+ employees are authorized to book Business Class for international flights...', 8, 'Global', 'Executive', '[0.88, 0.05, ...]');
