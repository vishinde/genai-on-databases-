** Troubleshooting Playbook **
Deploying this architecture involves multiple services. This section provides a high-value guide to the most common errors encountered during development and their solutions, turning this log of issues into a reusable asset for engineers.

Network Binding Error
ERR_CONNECTION_REFUSED

Browser can't connect to the VM's external IP on port 5000, even though the firewall is open.

Solution:
The server is bound to `localhost`. Restart the MCP Toolbox and bind to all interfaces using the `--address "0.0.0.0"` flag.

IAM Permission Error (BQ Jobs)
403: User does not have bigquery.jobs.create permission

The MCP Toolbox server attempts to run a query but is denied by BigQuery.

Solution:
Grant the GCE VM's Service Account the `roles/bigquery.jobUser` and `roles/bigquery.dataViewer` IAM roles.

IAM Permission Error (Federation)
403: User does not have bigquery.connections.use permission

The GCE VM's Service Account can create BQ jobs but cannot use the AlloyDB connection.

Solution:
Grant the GCE VM's Service Account the `roles/bigquery.connectionUser` IAM role on the specific connection resource.

ADK Validation Error
ValidationError: Invalid app name 'fraud-detect-agent'

ADK fails to run the agent due to an invalid name format.

Solution:
Agent names must be valid Python identifiers. Rename the agent to use underscores (e.g., `fraud_detect_agent`).

ADK Pathing Error
Error: Directory 'fraud_detect_agent' does not exist.

`adk run` fails because it expects a directory, not a Python file.

Solution:
Use the `[module_name]:[object_name]` syntax. If your file is `agent.py` and object is `root_agent`, run: `adk run agent:root_agent`.

Toolbox 404 Error
404 (Not Found): toolset "..." does not exist

The ADK agent connects to the Toolbox but can't find the requested toolset.

Solution:
Ensure the `toolsets:` section is correctly defined in `tools.yaml` and matches the name in `toolbox.load_toolset(...)`.
