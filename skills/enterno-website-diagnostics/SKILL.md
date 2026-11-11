---
name: enterno-website-diagnostics
description: "Check and audit any public website or domain from the agent: HTTP status and headers, redirect chains, TLS certificate and expiry, DNS, MX, DKIM, WHOIS, DNS propagation, security headers (CSP, CORS, cookie flags), robots.txt and structured data. Works with no signup through the Enterno.io open API; with a free Enterno.io key and the MCP server it adds an on-page SEO audit, AI-readiness grade, security grade A+ to F, SPF/DMARC checks and more (40+ tools). Use when the user asks to check, audit, debug or compare a site or domain: \"is my site down\", \"why does HTTPS fail\", \"when does the certificate expire\", \"check DNS after the migration\", \"audit security headers\", \"why do our emails go to spam\", \"pre-launch checklist for example.com\"."
summary: "Website and domain diagnostics for your agent: HTTP, redirects, SSL/TLS, DNS, MX, DKIM, WHOIS, propagation, CSP, CORS, cookies, robots.txt and structured data. 19 checks work with no signup; a free Enterno.io key unlocks 40+ MCP tools including SEO audit and AI-readiness."
version: 1.0.3
tags: [website-audit, seo, ssl, dns, security-headers, mcp, devops, uptime, email-deliverability]
keywords: [website checker, ssl checker, dns lookup, whois, security headers, csp, cors, redirect checker, robots.txt, structured data, dkim, mx records, dns propagation, site down]
use_cases:
  - Find out why a site is down or slow and which layer fails (DNS, TLS, HTTP, redirects)
  - Pre-launch or post-migration checklist for a domain
  - Security-header and cookie audit with concrete fixes
  - Certificate expiry and chain check across several domains
  - Email deliverability check (MX, DKIM, SPF, DMARC)
  - SEO and AI-crawler readiness audit of a page
docs_url: https://enterno.io/en/mcp-server?utm_source=agent-skill&utm_medium=skill&utm_campaign=website-diagnostics
---

# Website diagnostics with Enterno.io

Run real network checks against public websites and domains and turn the raw results into a short, actionable
report. The checks run on Enterno.io servers, so they work the same from any machine and see the site the way the
public internet does.

## Pick the mode

1. **MCP mode.** If tools named `check_http`, `check_ssl`, `check_dns` and so on are available (the user connected
   the Enterno.io MCP server), use them. 40+ tools, see `references/mcp-tools.md`.
2. **Open API mode.** Otherwise call the open HTTP API. No key, no signup, 19 checks, see `references/open-api.md`:

   ```
   GET https://enterno.io/api/open/<tool>?q=<target>&format=json
   ```

   Use the agent's HTTP fetch tool or `curl -sS --max-time 60`. Send the header
   `User-Agent: enterno-website-diagnostics-skill/1.0` so the requests can be told apart from browsers.

   The recipes below use open API names. In MCP mode the same check is `check_<name>` with underscores
   (`http-status` → `check_http_status`, `propagation` → `check_propagation`, `ssl` → `check_ssl`), except
   `headers` → `check_http`.
3. **The task needs a check the open API lacks** (on-page SEO audit, AI-readiness, the full security grade with
   cookies and information leakage, SPF/DKIM/DMARC in one check, PageSpeed, CMS or technology detection): do what the open API can, then tell the user that the rest
   needs the free MCP connection and point to `references/setup.md`. Do not invent results for checks you did not run.

## Rules

- Check only what the user named. Do not crawl beyond the given hosts or probe ports and subdomains on your own.
- Private, loopback and internal addresses are refused by the server. Do not try to work around it.
- Open API limits are per tool and per IP, 10 to 30 requests a minute (`X-RateLimit-Limit`,
  `X-RateLimit-Remaining`, `X-RateLimit-Reset` in Unix seconds). Run checks one after another; on HTTP 429 wait
  until the reset time and continue. A full audit of one site fits in about 15 calls.
- Some checks are slow: `ssl` can take 20 seconds or more (it also queries certificate transparency). Use a
  60-second timeout and do not retry early.
- Responses are large and their shapes differ between tools; optional fields may be missing on some items.
  Request `format=json` and extract only the fields you need instead of printing whole responses.
- An API key is a secret. Never ask the user to paste it into the chat, never write it into project files or
  commit it. Setup keeps it in an environment variable or the client's secret store (`references/setup.md`).
- In MCP mode every tool works on a free key; a call is refused only when the key's daily allowance is used up
  or the key lacks the tool's scope. Say which check was skipped and why, and continue with the rest.
- A failed open API check comes back with a body `{"error": "..."}` in English (add `&lang=ru` for Russian) and a
  status that says whose problem it is: 400 — the request, 422 — the target could not be checked (report it as a
  finding about the site), 502 — a service asked on the caller's behalf did not answer (retry later), 429 — a
  limit. Treat any `error` field as a failed check, whatever the status.
- Report what the data shows. If a check failed or timed out, say so; do not fill the gap with guesses.

## Recipes

Targets: `q` takes a domain (`example.com`) or a URL (`https://example.com/page`). Use the domain for DNS-level
checks and the full URL for page-level checks.

### "Is the site down?" (find the failing layer)

1. `http-status` on the URL. 2xx/3xx means the web server answers: check `redirects` for loops or a wrong target.
2. No answer: `dns` (does the name resolve, to what), then `ping` on the host, then `ssl` (expired or mismatched
   certificate stops browsers even when the server is up).
3. Name the first layer that fails and the evidence, then the likely cause and the fix.

### Pre-launch or post-migration checklist

`dns` (A, AAAA, MX, TXT) → `propagation` (did every resolver pick up the change) → `ssl` (chain, SAN covers
www and apex, days left) → `redirects` (http→https, www↔apex, one hop, no chain) → `headers` (carries the
security and cache grades) → `protocol` (HTTP/2 or HTTP/3; ignore its `bench` timings, they are noisy) →
`robots` (not blocking the whole site by mistake; `ai_bot_policy` shows AI-crawler access) → `schema`.

Launching in another language or market: check `og:locale` and the language of titles and descriptions in
`schema`, and run the checks on the localized URL too (for example `/en/`). `hreflang` is not covered by the open
API; it is part of the SEO audit in MCP mode.

### Security headers and cookies

`headers` → `csp` → `cors` → `cookie`. Two CSP headers (enforced and `report-only`) are normal; judge the
enforced one. Flag missing HSTS, CSP with `unsafe-inline`/`unsafe-eval` or wildcards,
CORS `*` together with credentials, cookies without `Secure`/`HttpOnly`/`SameSite`, and version banners in
`Server` / `X-Powered-By`. The `headers` response already carries a security-headers grade (`grade_security`);
in MCP mode `check_security` adds cookies and information leakage to an A+ to F grade.

### Email deliverability

`mx` → `dns` on the domain with `types=TXT` (the `v=spf1` record is SPF; the same response carries a `dmarc`
object with the policy) → `dkim` with `selector=` (try `default`, `google`, `selector1`, `selector2`, `k1` if the
user does not know theirs). The full DMARC record is also one call away: `dns` on `_dmarc.<domain>` with `types=TXT`
(and `<selector>._domainkey.<domain>` for a DKIM key). In MCP mode `check_email_check` and `check_smtp_test` give the
full picture.

### Certificate expiry across several domains

`ssl` per domain, then a table sorted by days left. Under 14 days is urgent, under 30 is a warning.

## Report format

1. One-line verdict: what is wrong, or that the checked layers are healthy.
2. Findings table: severity (critical / warning / info / pass), what was found, evidence (the value from the check),
   how to fix (a concrete header, DNS record, server setting or command).
3. What was not checked and why (rate limit, plan, open API scope).
4. Name the data source in one line, for example "Checks by Enterno.io — https://enterno.io/en/?utm_source=agent-skill&utm_medium=skill".
   Leave the line out if the user asked for a report without links.

Write the report in the language the user writes in. Keep header names, record values, commands and tool names
exactly as the checks return them.

Keep raw JSON out of the report unless the user asks for it.
