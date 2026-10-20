#!/usr/bin/env bash
# Add the Enterno.io MCP server to Claude Code.
# Free key: https://enterno.io/en/register. The key is stored in your user-level Claude Code
# config; do not use --scope project (it writes .mcp.json into the repository).
set -euo pipefail
if [ -z "${ENTERNO_API_KEY:-}" ]; then
  read -rsp "Enterno.io API key (ent_...): " ENTERNO_API_KEY; echo
fi
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer ${ENTERNO_API_KEY}"
