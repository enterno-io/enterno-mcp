# Agensi listing: Website Diagnostics

Field values for the form at https://agensi.io/dashboard/submit (docs: https://agensi.io/docs/submit-on-the-website).
Upload: `dist/enterno-website-diagnostics-<version>.zip` built by `scripts/build-agensi-zip.sh`. Logo: `logo-512.png`.

## Name (max 60)

Website Diagnostics: SSL, DNS, Headers & SEO

## Summary (max 300)

Website and domain diagnostics for your agent: HTTP, redirects, SSL/TLS, DNS, MX, DKIM, WHOIS, propagation, CSP, CORS, cookies, robots.txt and structured data. 19 checks work with no signup; a free Enterno.io key unlocks 40+ MCP tools including SEO audit and AI-readiness.

## Price

Free.

## Categories (first one decides the category page)

1. Marketing & SEO
2. Security
3. DevOps & Cloud

## Tags

website audit, ssl checker, dns, security headers, seo, uptime, email deliverability, mcp

## Use cases

- Find out why a site is down or slow and which layer fails: DNS, TLS, HTTP or redirects
- Pre-launch or post-migration checklist for a domain
- Security-header and cookie audit with concrete fixes
- Certificate expiry and TLS grade across several domains
- Email deliverability: MX, SPF, DMARC, DKIM
- SEO and AI-crawler readiness of a page

## Description (Markdown)

Ask your agent "is my site down?", "when does the certificate expire?" or "run a pre-launch check of example.com" and get a short report with evidence and concrete fixes, not a pile of raw output.

**What it checks.** HTTP status and response headers, redirect chains, SSL/TLS certificate, protocols and grade, DNS records, DNS propagation across public resolvers, MX, DKIM, SPF and DMARC policy, WHOIS, ASN and IP data, Content-Security-Policy, CORS, cookie flags, robots.txt with AI-crawler policy, structured data with Open Graph and Twitter cards, HTTP/2 and HTTP/3.

**Works right away.** The checks run on Enterno.io servers through a public API that needs no account and no key, so the skill works the moment it is installed, from any agent that can make an HTTP request. The site is seen the way the public internet sees it, not from your laptop.

**Goes further when you want it.** Connect the Enterno.io MCP server with a free API key and the agent gets 40+ tools: on-page SEO audit, AI-readiness grade, full security grade A+ to F with cookies and information leakage, full email deliverability check, technology and CMS detection and more. Ready configs for Claude Code, Codex CLI, Cursor, VS Code, Claude Desktop and Zed are included.

**Built-in recipes.** "Is the site down?" (finds the first failing layer), pre-launch and post-migration checklist, security headers and cookies, email deliverability, certificate expiry across many domains.

**Safe by design.** Only the hosts you name are checked; private and internal addresses are refused by the server; the skill never asks you to paste a key into the chat or write it into project files.

## See it in action

Request:

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is. Then grade github.com's security headers and cookies.

Result (real run, 11 Nov 2026, open API mode, 5 requests):

> **Verdict:** all three certificates are valid for at least 44 more days; example.com has a weaker TLS setup than the other two.
>
> | Severity | Finding | Evidence | How to fix |
> |---|---|---|---|
> | warning | example.com still accepts TLS 1.0 and 1.1 and sends no HSTS | TLS grade B (80/100): "TLS 1.2 (legacy enabled)" 10/20, "No HSTS" 0/10 | Disable TLS 1.0/1.1 at the edge; add `Strict-Transport-Security: max-age=31536000; includeSubDomains` |
> | info | example.com certificate renews soonest | Cloudflare TLS Issuing ECC CA 3, valid to 2026-12-26, 44 days left | Nothing to do if auto-renewal is on; re-check under 30 days |
> | pass | github.com TLS | Sectigo DV E36, valid to 2027-01-28 (77 days), grade A+ (97), TLS 1.2/1.3 only, HSTS strong | — |
> | pass | wikipedia.org TLS | Let's Encrypt YE2, valid to 2027-01-02 (52 days), grade A+ (97), TLS 1.2/1.3 only | — |
> | warning | github.com HTML is not cacheable | cache grade E (25/100): `Cache-Control` present but only `no-cache` | Expected for a logged-in app; ignore unless the page is public and static |
> | info | github.com `_octo` cookie readable by scripts | cookie grade B: `_octo` Secure, SameSite=Lax, no HttpOnly; `_gh_sess` and `logged_in` have all three flags | Add `HttpOnly` if no script needs to read it |
>
> Security headers grade for github.com: B (80/100), HSTS and HTTPS full marks.
> Not checked: SEO audit and AI-readiness (need the free MCP connection).
>
> Checks by Enterno.io

## Needs access to / Permissions

- Network: `https://enterno.io/api/open/*` (public API, no key). Requests carry `User-Agent: enterno-website-diagnostics-skill/1.0`.
- Optional: Enterno.io MCP server `https://enterno.io/mcp` with the user's own free API key (`Authorization: Bearer`), configured by the user in their agent. The key is read from an environment variable or the client's secret store.
- No local files are read or sent; no scripts run.

## Compatibility note

Any agent that can make HTTP requests (curl or a fetch tool). MCP mode: Claude Code, Codex CLI, Cursor, VS Code, Claude Desktop (via mcp-remote, Node.js 18+), Zed.

## Limitations

- Public targets only: private, loopback and internal addresses are refused.
- Open API limits are per tool, 10 to 30 requests a minute per IP; a full site audit takes about 15 requests.
- On-page SEO audit, AI-readiness, the full A+ to F security grade, PageSpeed and technology detection need the MCP connection (free key; the plan sets the daily number of calls).
- `hreflang` is not checked in open API mode.

## FAQ

**Do I need an account?** No for the 19 open checks. A free account gives the API key for the MCP tools.

**Where do the checks run?** On Enterno.io servers, so results do not depend on your network.

**Is my key safe?** The skill never asks for it in chat; setup keeps it in an environment variable or the client's secret store.

## Docs link

https://enterno.io/en/mcp-server?utm_source=agensi&utm_medium=listing&utm_campaign=website-diagnostics
