import pandas as pd
from sqlalchemy import create_engine, text

# 1. Setup Connection (Replace with your actual AlloyDB/Cloud SQL credentials)
# connection_string = "postgresql+pg8000://user:pass@host:port/dbname"
# engine = create_engine(connection_string)

def agent_query(user_name, user_question, user_embedding):
    """
    Simulates an HR Agent that knows who the user is 
    and filters policies based on their DB profile.
    """
    
    with engine.connect() as conn:
        # STEP A: Fetch User Metadata from the Relational Table
        # This is the "Relational" part of the RAG.
        user_info = conn.execute(
            text("SELECT level, location FROM users WHERE name = :name"),
            {"name": user_name}
        ).fetchone()
        
        if not user_info:
            return "User not found."

        user_level, user_loc = user_info
        print(f"--- System identified user {user_name} as {user_level} in {user_loc} ---")

        # STEP B: The Hybrid Search
        # We search the 'policies' table for vectors, but 
        # WE FILTER by the user's level and location using standard SQL.
        query = text("""
            SELECT content, 
                   1 - (embedding <=> :query_embedding) AS similarity
            FROM policies
            WHERE 
                (required_level <= :level OR required_level IS NULL)
                AND (region = :loc OR region = 'Global')
            ORDER BY similarity DESC
            LIMIT 3;
        """)

        results = conn.execute(query, {
            "query_embedding": str(user_embedding), # The vector from Gemini
            "level": int(user_level.replace('L','')), # Convert 'L3' to 3
            "loc": user_loc
        }).fetchall()

        return results

# --- EXECUTION EXAMPLE ---
# question = "What is my dinner reimbursement limit?"
# embedding = get_gemini_embedding(question) # Call your embedding model

# alice_results = agent_query("Alice", question, embedding)
# bob_results = agent_query("Bob", question, embedding)
