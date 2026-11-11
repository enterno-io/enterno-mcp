# Connect the Enterno.io MCP server (optional, free)

The open API covers 19 checks with no setup. The MCP server adds the rest (40+ tools): on-page SEO audit,
AI-readiness, security grade, email deliverability and more.

| | |
|---|---|
| Endpoint | `https://enterno.io/mcp` (Streamable HTTP, JSON-RPC 2.0) |
| Auth | `Authorization: Bearer ent_...` |
| Key | Free: create an account at https://enterno.io/en/register?utm_source=agent-skill&utm_medium=skill&utm_campaign=website-diagnostics and create an API key in the dashboard |

Keep the key out of files that get committed and never paste it into the chat. Where a client can read it from an
environment variable or a secret prompt, use that; where it stores it in a user-level config file, keep that file private. Ready-made configs: `templates/` next to this file in the packaged skill, or
https://github.com/enterno-io/enterno-mcp/tree/main/examples.

## Claude Code

The user runs this in their own terminal (the key is read silently, not echoed and not saved to history):

```bash
read -rs ENTERNO_API_KEY
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

Use the default user scope: the key is then stored in plain text in the user-level `~/.claude.json`, outside any
repository. `--scope project` writes `.mcp.json` into the repository, where the key gets committed.

## Codex CLI

`~/.codex/config.toml` (template: `templates/codex-config.toml`). Codex reads the token from the environment:

```toml
[mcp_servers.enterno]
url = "https://enterno.io/mcp"
bearer_token_env_var = "ENTERNO_API_KEY"
```

Then `export ENTERNO_API_KEY=...` in the shell profile that starts Codex.

## Cursor

`~/.cursor/mcp.json` (template: `templates/cursor-mcp.json`):

```json
{
  "mcpServers": {
    "enterno": {
      "url": "https://enterno.io/mcp",
      "headers": { "Authorization": "Bearer ${env:ENTERNO_API_KEY}" }
    }
  }
}
```

## VS Code

`.vscode/mcp.json` (template: `templates/vscode-mcp.json`). VS Code asks for the key once and stores it as a secret.

## Claude Desktop

Custom connectors there sign in with OAuth and cannot send an API-key header; use the `mcp-remote` bridge
(Node.js 18+). Template: `templates/claude-desktop.json`. The key sits in that user-level file, so keep it private.

## Zed

Template: `templates/zed-settings.json`. The key sits in the user-level Zed settings file; keep it private.

## Check the connection

After restarting the client, the tools `check_http`, `check_ssl`, `check_dns` and others appear. Without a key the
server answers HTTP 401 `API key required`. Every tool works on a free key; the plan sets how
many calls a day the key gets.
