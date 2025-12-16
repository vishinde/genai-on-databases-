from google.adk.agents.llm_agent import Agent
from toolbox_core import ToolboxSyncClient

# --- Configuration ---
# NOTE: Ensure the MCP Toolbox Server is running locally (e.g., on the GCE VM) 
# and accessible via its public IP or a tunnel.
# Replace the IP below with your actual GCE public IP if not tunnelling.
# The server is running on http://35.193.18.104:5000/ui/
TOOLBOX_URL = "http://127.0.0.1:5000" 

# --- Tool Loading ---
try:
    toolbox = ToolboxSyncClient(TOOLBOX_URL)
    # Load the toolset named 'realtime_fraud_check' defined in tools.yaml
    tools = toolbox.load_toolset('realtime_fraud_check')
except Exception as e:
    print(f"Error connecting to MCP Toolbox: {e}")
    tools = [] # Load an empty toolset if connection fails

# --- Agent Definition ---
# Use underscores instead of hyphens for the file and object name (root_agent)
root_agent = Agent(
    model='gemini-2.5-flash',
    name='fraud_detect_agent',
    description='Agent that performs real-time fraud assessment by checking live transactions against historical risk scores.',
    instruction="""
    You are a professional Financial Fraud Analyst. Your goal is to review the latest pending transactions and determine if they are fraudulent based on the data provided by the tool.

    **SCORING RULE:**
    A transaction is considered **FRAUDULENT** if the 'bqml_risk_score' is greater than 0.5 AND the 'risk_segment' is 'High' or 'CRITICAL'. Otherwise, the transaction is **NOT FRAUDULENT**.

    **STEPS:**
    1. First, use the `realtime_fraud_check` tool to retrieve the list of pending transactions and their augmented risk features (score and segment).
    2. Analyze the results against the SCORING RULE.
    3. Output the results in a formatted list. For each transaction, provide the Customer ID, Transaction Amount, and specify the exact reason based on the rule. Use only the provided data.
    
    **REQUIRED OUTPUT FORMAT:**
    - **Customer ID:** [ID], **Transaction Amount:** [Amount]
        This transaction is [fraudulent/not fraudulent] because the risk score ([score]) is [greater/not greater] than 0.5 and the risk segment is [High/not High].
    """,
    tools=tools,
)
