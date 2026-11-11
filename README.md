# Enterno.io MCP server

> **Website diagnostics for AI agents.** Let Claude, Cursor, VS Code, Zed or any MCP client run HTTP, DNS,
> SSL/TLS, WHOIS, redirect, security-header, email, SEO and AI-readiness checks on any public website.

[![enterno.io](https://img.shields.io/badge/docs-enterno.io-5b8af8)](https://enterno.io/en/mcp-server)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)

This repository is the public showcase for the hosted Enterno.io MCP server: how to connect it, what it can do,
and ready-made client configs. The server itself is a hosted service run by [enterno.io](https://enterno.io);
its source code is not part of this repository.

## At a glance

| | |
|---|---|
| Endpoint | `https://enterno.io/mcp` |
| Transport | Streamable HTTP (JSON-RPC 2.0), protocol version `2024-11-05` |
| Authentication | API key: `Authorization: Bearer ent_…` or `X-API-Key: ent_…` |
| API key | Free — create an account at <https://enterno.io/en/register>, then create a key in the dashboard |
| Tools | <!-- tools:count -->49 tools (server card, 2026-11-11)<!-- /tools:count --> — full list in [TOOLS.md](TOOLS.md) |
| Discovery | [`/.well-known/mcp.json`](https://enterno.io/.well-known/mcp.json), [`/.well-known/mcp/server-card.json`](https://enterno.io/.well-known/mcp/server-card.json) |
| Documentation | <https://enterno.io/en/mcp-server> |

The `initialize` handshake is open. `tools/list` and `tools/call` need a key; without one the server answers
HTTP 401 `API key required`.

## What it can do

- **HTTP** — status, response headers and timing, redirect chains, HTTP/2 and HTTP/3, mixed content
- **DNS and domains** — DNS records, propagation across resolvers, MX, WHOIS, subdomains from Certificate
  Transparency logs, reverse IP, ASN
- **TLS** — certificate chain, protocol, cipher, SAN list, expiry
- **Security** — security-header grade (A+ to F), CSP, CORS, cookie flags
- **Email** — SPF, DKIM, DMARC, MX, SMTP banner and STARTTLS, raw header parsing
- **Network** — ping, traceroute, IP geolocation
- **SEO and AI readiness** — on-page SEO audit, structured data, Open Graph preview, robots.txt, PageSpeed,
  AI-crawler readiness, technology and CMS detection
- **Your account** — read-only access to the assets your Enterno.io account observes and their recent events

Requests to private, loopback and internal addresses are refused.

## Plans and limits

- The key is free. Tool calls count against your plan's daily API request allowance; the numbers per plan
  are on <https://enterno.io/en/pricing>.
- Some tools need a paid plan. The MCP page marks them **Pro+**: on 2026-10-20 these were `check_speed`,
  `check_subdomain_enum`, `check_traceroute`, `check_email`, `plane_assets`, `plane_events` and `plane_asset`.
  The page is the authoritative list.
- Rate limiting is per key (sliding window); responses carry `X-RateLimit-*` headers.

## Connect

Get a key first, then pick your client. Configs below are also in [`examples/`](examples/).
Keep the key out of files you commit: use an environment variable or the client's secret prompt.

### Claude Code

```bash
read -rs ENTERNO_API_KEY   # paste the key; it is not echoed or saved to shell history
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

This stores the key in your user-level Claude Code config. Do not add it with `--scope project`: that writes
`.mcp.json` into the repository, where it gets committed.

### Claude Desktop

Custom connectors in Claude Desktop sign in with OAuth and cannot send an API-key header, so connect through
the open-source [`mcp-remote`](https://github.com/punkpeye/mcp-remote) bridge (Node.js 18+). In
`claude_desktop_config.json` (macOS: `~/Library/Application Support/Claude/`, Windows: `%APPDATA%\Claude\`):

```json
{
  "mcpServers": {
    "enterno": {
      "command": "npx",
      "args": ["-y", "mcp-remote@0.15.1", "https://enterno.io/mcp", "--header", "Authorization:${ENTERNO_AUTH}"],
      "env": { "ENTERNO_AUTH": "Bearer ent_your_key" }
    }
  }
}
```

Restart Claude Desktop. The key sits in plain text in this user-level file, so keep the file private.
`mcp-remote` is a third-party package that sees your key; the config pins a version you can review — update it
deliberately. Its README also documents `--header-file`, which reads the header from a separate file instead of
the config.

### Codex CLI

`~/.codex/config.toml` — Codex reads the token from the environment (`export ENTERNO_API_KEY=ent_...`):

```toml
[mcp_servers.enterno]
url = "https://enterno.io/mcp"
bearer_token_env_var = "ENTERNO_API_KEY"
```

### Cursor

`~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (project). Cursor reads `${env:NAME}` from your environment:

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

### VS Code

`.vscode/mcp.json` — VS Code asks for the key once and stores it as a secret:

```json
{
  "inputs": [
    { "type": "promptString", "id": "enterno-api-key", "description": "Enterno.io API key (ent_…)", "password": true }
  ],
  "servers": {
    "enterno": {
      "type": "http",
      "url": "https://enterno.io/mcp",
      "headers": { "Authorization": "Bearer ${input:enterno-api-key}" }
    }
  }
}
```

### Zed

Your **user** `settings.json` (`~/.config/zed/settings.json`) → `context_servers`. Never put the key in a
project's `.zed/settings.json` — that file is usually committed.

```json
{
  "context_servers": {
    "enterno": {
      "url": "https://enterno.io/mcp",
      "headers": { "Authorization": "Bearer ent_your_key" }
    }
  }
}
```

### Any client / curl

```bash
curl -s https://enterno.io/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ENTERNO_API_KEY" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"check_ssl","arguments":{"host":"example.com"}}}'
```

More in [`examples/curl.sh`](examples/curl.sh).

## Agent skill

[`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/SKILL.md) teaches an agent when and how
to run these checks and how to turn them into a report: "is the site down", pre-launch and post-migration
checklists, security headers and cookies, email deliverability, certificate expiry. It works with no key through
the open API (19 checks) and uses the MCP server when it is connected.

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

## Example prompts

- "Is example.com reachable? Check its HTTP status and response time."
- "When does the TLS certificate of github.com expire, and which cipher does it negotiate?"
- "Grade the security headers of my site and tell me which headers are missing."
- "Do SPF, DKIM and DMARC for example.org look correct?"

## No key? Use the Open API

For quick scripts there is a keyless HTTP API at `https://enterno.io/api/open/` (plain text, JSON or CSV,
per-IP limits). See <https://enterno.io/en/api-docs>.

## Keeping TOOLS.md current

[TOOLS.md](TOOLS.md) is generated from the public server card, not written by hand:

```bash
scripts/update-tools.sh   # needs bash, curl, jq
```

## Support

Questions and bug reports: open an issue here or write via <https://enterno.io/en/contact>.

## License

The documentation and examples in this repository are MIT-licensed — see [LICENSE](LICENSE).
The Enterno.io service is proprietary and has a free tier.
