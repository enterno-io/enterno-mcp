#!/usr/bin/env bash
# Talk to the Enterno.io MCP server with plain curl.
# Set ENTERNO_API_KEY first (free key: https://enterno.io/en/register).
set -euo pipefail
: "${ENTERNO_API_KEY:?Set ENTERNO_API_KEY to your Enterno.io API key (ent_...)}"
ENDPOINT="https://enterno.io/mcp"

rpc() {
  curl -sS "$ENDPOINT" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json, text/event-stream" \
    -H "Authorization: Bearer ${ENTERNO_API_KEY}" \
    -d "$1"
  echo
}

# 1. Handshake (works without a key too)
rpc '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"curl-example","version":"1.0"}}}'

# 2. List tool names
rpc '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' | jq -r '.result.tools[].name'

# 3. Call one tool
rpc '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"check_ssl","arguments":{"host":"example.com"}}}'
