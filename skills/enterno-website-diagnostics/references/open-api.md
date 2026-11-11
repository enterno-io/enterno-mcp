# Enterno.io open API (no key)

```
GET https://enterno.io/api/open/<tool>?q=<target>[&format=json|text|csv][&extra=...]
```

- No key, no signup, GET only. Limits are per tool and per IP, 10 to 30 requests a minute (on 2026-11-11:
  `propagation`, `robots` 10; `redirects`, `protocol` 15; `cors`, `schema` 20; `dns`, `ssl`, `headers`, `csp`,
  `cookie` 30). Read `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` (Unix seconds);
  HTTP 429 means wait until the reset.
- `format=json` for parsing, `format=text` for a flat `key: value` view that is easy to quote.
- An error may come back with HTTP 200 as `{"error": "..."}`. Treat it as a failed check. Success markers differ
  (`status: ok`, `status: success` or none), so test for `error`, not for `status`.
- Private, loopback and internal targets are refused.
- The live list is at `GET https://enterno.io/api/open/` (plain text).

| Tool | What it returns | Target `q` | Extra parameters |
|---|---|---|---|
| `headers` | Response headers per hop (`blocks[].headers[]`), timing per phase, security and cache grades | URL | |
| `dns` | DNS records, CAA, DNSSEC, `dmarc` (`found`, `policy`, `raw`) of the domain | domain | `types=` e.g. `A,AAAA,MX,TXT,NS,CNAME,SOA` |
| `ssl` | TLS certificate: subject, issuer, validity, days left, SAN list, chain, protocols, grade; can take 20 s | host | `port=` (default 443) |
| `ip` | IP geolocation and network | IP or host | |
| `ping` | ICMP reachability, min/avg/max, loss | host | |
| `whois` | Registrar, creation and expiry dates, name servers, status flags | domain | |
| `mx` | Mail exchangers with priority and SMTP banner | domain | |
| `asn` | ASN, network owner, country, announced prefixes, risk level | IP, host or `AS<number>` | |
| `dkim` | DKIM public key for a selector | domain | `selector=` |
| `propagation` | One record type across public resolvers worldwide, with TTL and stale flags | domain | |
| `http-status` | Status code, final URL, redirect count, server, content type | URL | |
| `redirects` | Every hop of the redirect chain with status, target, purpose and verdict | URL | `max=` |
| `csp` | Content-Security-Policy parsed per directive, with a grade | URL | |
| `cors` | CORS policy for an origin, preflight result, findings and a grade | URL | `origin=` |
| `cookie` | Cookies with `Secure`, `HttpOnly`, `SameSite`, lifetime, trackers, and a grade | URL | |
| `robots` | robots.txt rules, sitemaps and their health, AI-crawler policy; `test_url` checks one URL for Googlebot | domain | `test_url=` |
| `schema` | Structured data (JSON-LD, microdata), Open Graph and Twitter cards, rich-result eligibility | URL | |
| `protocol` | HTTP version (1.1, 2, 3) and TLS negotiation; the `bench` timings are noisy, do not rely on them | URL | |
| `url-expand` | Where a short link leads | URL | |

Not in the open API (MCP server, free key): on-page SEO audit, AI-readiness, the full security grade
(the `headers` grade covers headers only),
SPF/DKIM/DMARC in one check, SMTP STARTTLS test, PageSpeed, technology and CMS detection,
mixed content, Wayback history, reverse IP. See `mcp-tools.md` and `setup.md`.
