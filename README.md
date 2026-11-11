<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <b>English</b> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt-BR.md">Português</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a>
</p>

<p align="center">
  <img src="agensi/logo-512.png" alt="Enterno.io" width="96" height="96">
</p>

<p align="center">
  <b>Website and domain diagnostics for AI agents.</b><br>
  Ask your agent "is my site down?" or "audit example.com before launch" and get a short report
  with evidence and concrete fixes — not a pile of raw output.
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#install"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="19 checks with no key">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="40+ MCP tools with a free key">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="MIT license"></a>
</p>

---

The **`enterno-website-diagnostics` agent skill** teaches Claude Code, Codex, Cursor and other agents how to check a
public website or domain and how to turn the results into a report a person can act on. The checks run on
Enterno.io servers, so the site is seen the way the public internet sees it — not from your laptop or VPN.

It works the moment it is installed: **19 checks need no account and no key**. Connect the hosted
[Enterno.io MCP server](#connect-the-mcp-server) with a free key and the agent gets **40+ tools**, including an
on-page SEO audit, AI-readiness, a full security grade from A+ to F and email deliverability.

## Contents

- [Install](#install)
- [What you can ask](#what-you-can-ask)
- [See it in action](#see-it-in-action)
- [What it checks](#what-it-checks)
- [Built-in recipes](#built-in-recipes)
- [Connect the MCP server](#connect-the-mcp-server)
- [Plans and limits](#plans-and-limits)
- [Security and privacy](#security-and-privacy)
- [FAQ](#faq)

## Install

**Any agent supported by the skills CLI** (Claude Code, Codex, Cursor, Gemini CLI and others):

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Claude Code plugin** — the repository is also a plugin marketplace:

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**Codex, Gemini CLI, GitHub Copilot CLI and Cursor** — the same repository is a plugin for them too
(Agent Plugins standard and a Gemini CLI extension):

```bash
# Codex
codex plugin marketplace add enterno-io/enterno-mcp
codex plugin add enterno-website-diagnostics@enterno-io

# Gemini CLI
gemini extensions install https://github.com/enterno-io/enterno-mcp

# GitHub Copilot CLI
copilot plugin marketplace add enterno-io/enterno-mcp
copilot plugin install enterno-website-diagnostics@enterno-io

# Cursor
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics -a cursor
```

**By hand** — copy [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) into your agent's
skills folder, for example `~/.claude/skills/` for Claude Code.

No configuration is needed for the 19 open checks. For the full toolset, add the MCP server — see
[Connect the MCP server](#connect-the-mcp-server).

## What you can ask

- "Is example.com down? Find which layer fails: DNS, TLS, HTTP or redirects."
- "Run a pre-launch checklist for shop.example.com."
- "We moved DNS yesterday — has every resolver picked up the change?"
- "When do the certificates of these five domains expire, and how good is their TLS setup?"
- "Grade the security headers and cookies of my site and tell me exactly what to add."
- "Why do our emails go to spam? Check MX, SPF, DKIM and DMARC."
- "Is my robots.txt blocking AI crawlers? Is the structured data valid?"

## See it in action

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

Real run, 11 November 2026, open API mode, 5 requests:

> **Verdict:** all three certificates are valid for at least 44 more days; example.com has a weaker TLS setup
> than the other two.
>
> | Severity | Finding | Evidence | How to fix |
> |---|---|---|---|
> | warning | example.com still accepts TLS 1.0 and 1.1 and sends no HSTS | TLS grade B (80/100): "TLS 1.2 (legacy enabled)" 10/20, "No HSTS" 0/10 | Disable TLS 1.0/1.1 at the edge; add `Strict-Transport-Security: max-age=31536000; includeSubDomains` |
> | info | example.com certificate renews soonest | Cloudflare TLS Issuing ECC CA 3, valid to 2026-12-26, 44 days left | Nothing to do if auto-renewal is on; re-check under 30 days |
> | pass | github.com TLS | Sectigo DV E36, valid to 2027-01-28 (77 days), grade A+ (97), TLS 1.2/1.3 only, HSTS strong | — |
> | pass | wikipedia.org TLS | Let's Encrypt YE2, valid to 2027-01-02 (52 days), grade A+ (97), TLS 1.2/1.3 only | — |
> | info | github.com `_octo` cookie readable by scripts | cookie grade B: `_octo` Secure, SameSite=Lax, no HttpOnly; `_gh_sess` and `logged_in` have all three flags | Add `HttpOnly` if no script needs to read it |
>
> Security headers grade for github.com: B (80/100), HSTS and HTTPS full marks.
> Not checked: SEO audit and AI-readiness (need the free MCP connection).

## What it checks

| Area | No key (open API) | With a free key (MCP server) |
|---|---|---|
| HTTP | status, response headers, redirect chain, HTTP/2 and HTTP/3, short-link expansion | + mixed content, final URL resolution, Wayback history |
| TLS | certificate, chain, SAN, expiry, protocols, TLS grade | same |
| DNS and domains | records, propagation across public resolvers, MX, DKIM, WHOIS, ASN, IP data | + SPF/DKIM/DMARC in one check, reverse IP, subdomains from CT logs |
| Security | security-headers grade (from `headers`), Content-Security-Policy, CORS, cookie flags | + full security grade A+ to F |
| Email | MX with SMTP banner, DKIM | + full audit (SPF, DMARC, BIMI, MTA-STS), STARTTLS test, raw header parsing |
| SEO and AI | robots.txt with AI-crawler policy, structured data, Open Graph | + on-page SEO audit, AI-readiness grade, technology and CMS detection, PageSpeed |
| Network | ping | + traceroute |
| Your account | — | monitors (list, create, pause), observed assets and events |

Full tool list: [TOOLS.md](TOOLS.md). Open API reference:
[open-api.md](skills/enterno-website-diagnostics/references/open-api.md).

## Built-in recipes

The skill carries step-by-step playbooks, so the agent runs the right checks in the right order:

- **"Is the site down?"** — walks HTTP → DNS → ping → TLS and names the first layer that fails, with evidence.
- **Pre-launch / post-migration checklist** — DNS, propagation, certificate coverage of www and apex, redirects,
  security and cache headers, HTTP/2 and HTTP/3, robots.txt, structured data.
- **Security headers and cookies** — what is missing, why it matters, the exact header to add.
- **Email deliverability** — MX with SMTP banner, SPF and DMARC from DNS, DKIM by selector; the full audit
  through the MCP server.
- **Certificate expiry across many domains** — one table, soonest first.

Every report follows the same shape: a one-line verdict, a findings table (severity, finding, evidence, fix) and
an honest list of what was not checked.

## Connect the MCP server

The skill uses the MCP server automatically when its tools are available.

| | |
|---|---|
| Endpoint | `https://enterno.io/mcp` |
| Transport | Streamable HTTP (JSON-RPC 2.0), protocol version `2024-11-05` |
| Authentication | API key: `Authorization: Bearer ent_…` or `X-API-Key: ent_…` |
| API key | Free — create an account at <https://enterno.io/en/register>, then create a key in the dashboard |
| Tools | <!-- tools:count -->49 tools (server card, 2026-11-11)<!-- /tools:count --> — full list in [TOOLS.md](TOOLS.md) |
| Discovery | [`/.well-known/mcp.json`](https://enterno.io/.well-known/mcp.json), [`/.well-known/mcp/server-card.json`](https://enterno.io/.well-known/mcp/server-card.json) |
| Registry | `io.enterno/site-diagnostics` in the [official MCP Registry](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno) |
| Documentation | <https://enterno.io/en/mcp-server> |

The `initialize` handshake is open. `tools/list` and `tools/call` need a key; without one the server answers
HTTP 401 `API key required`. Keep the key out of files you commit: use an environment variable or the client's
secret prompt. Configs below are also in [`examples/`](examples/).

### Claude Code

```bash
read -rs ENTERNO_API_KEY   # paste the key; it is not echoed or saved to shell history
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

This stores the key in your user-level Claude Code config. Do not add it with `--scope project`: that writes
`.mcp.json` into the repository, where it gets committed.

<details>
<summary><b>Claude Desktop</b></summary>

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

</details>

<details>
<summary><b>Codex CLI</b></summary>

`~/.codex/config.toml` — Codex reads the token from the environment (`export ENTERNO_API_KEY=ent_...`):

```toml
[mcp_servers.enterno]
url = "https://enterno.io/mcp"
bearer_token_env_var = "ENTERNO_API_KEY"
```

</details>

<details>
<summary><b>Cursor</b></summary>

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

</details>

<details>
<summary><b>VS Code</b></summary>

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

</details>

<details>
<summary><b>Zed</b></summary>

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

</details>

<details>
<summary><b>Any client / curl</b></summary>

```bash
curl -s https://enterno.io/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ENTERNO_API_KEY" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"check_ssl","arguments":{"host":"example.com"}}}'
```

More in [`examples/curl.sh`](examples/curl.sh).

</details>

## Plans and limits

- **Open API** — no key, per tool and per IP, 10 to 30 requests a minute. A full audit of one site takes about
  15 requests. Plain text, JSON or CSV: `https://enterno.io/api/open/<tool>?q=<target>`
  ([docs](https://enterno.io/en/api-docs)).
- **MCP server** — the key is free. Tool calls count against your plan's daily API allowance; the numbers per
  plan are on <https://enterno.io/en/pricing>. Every tool works on a free key: the plan
  changes how many calls a day you get, not which tools you can call.
- Rate limiting is per key (sliding window); responses carry `X-RateLimit-*` headers.

## Security and privacy

- Only the hosts you name are checked. The skill does not crawl beyond them or probe ports and subdomains on
  its own.
- Requests to private, loopback and internal addresses are refused by the server.
- The skill never asks you to paste a key into the chat and never writes it into project files.
- No local files are read or sent, and the skill ships no scripts — only instructions and reference docs.
  Config samples for each client are in [`examples/`](examples/).

## FAQ

**Do I need an account?** Not for the 19 open checks. A free account gives the API key for the MCP tools.

**Which agents does it work with?** Any agent that can make an HTTP request or use MCP tools: Claude Code,
Claude Desktop, Codex CLI, Cursor, VS Code, Zed, Gemini CLI and others.

**Where do the checks run?** On Enterno.io servers, so results do not depend on your network, VPN or DNS cache.

**What language does the report come in?** The language you ask in.

**Is the MCP server open source?** No. This repository holds the skill, the documentation and the client
configs; the server is a hosted service run by [enterno.io](https://enterno.io) with a free tier.

## Keeping TOOLS.md current

[TOOLS.md](TOOLS.md) is generated from the public server card, not written by hand:

```bash
scripts/update-tools.sh   # needs bash, curl, jq
```

## Support

Questions and bug reports: [open an issue](https://github.com/enterno-io/enterno-mcp/issues) or write via
<https://enterno.io/en/contact>.

## License

The skill, documentation and examples in this repository are MIT-licensed — see [LICENSE](LICENSE).
The Enterno.io service is proprietary and has a free tier.
