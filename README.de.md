<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt-BR.md">Português</a> ·
  <b>Deutsch</b> ·
  <a href="README.fr.md">Français</a>
</p>

<p align="center">
  <img src="agensi/logo-512.png" alt="Enterno.io" width="96" height="96">
</p>

<p align="center">
  <b>Website- und Domain-Diagnose für KI-Agenten.</b><br>
  Fragen Sie Ihren Agenten „Warum ist meine Website down?“ oder „Prüfe example.com vor dem Launch“ – und erhalten
  Sie einen kurzen Bericht mit Belegen und konkreten Korrekturen statt eines Bergs von Rohdaten.
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#installation"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="19 Prüfungen ohne Schlüssel">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="Über 40 MCP-Tools mit kostenlosem Schlüssel">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="MIT-Lizenz"></a>
</p>

---

Der Skill **`enterno-website-diagnostics`** bringt Claude Code, Codex, Cursor und anderen Agenten bei, eine
öffentliche Website oder Domain zu prüfen und die Ergebnisse in einen Bericht zu verwandeln, mit dem man arbeiten
kann. Die Prüfungen laufen auf den Servern von Enterno.io – die Website wird so gesehen, wie das Internet sie sieht,
nicht von Ihrem Laptop oder VPN aus.

Er funktioniert sofort nach der Installation: **19 Prüfungen brauchen weder Konto noch Schlüssel**. Verbinden Sie
den gehosteten [Enterno.io-MCP-Server](#mcp-server-verbinden) mit einem kostenlosen Schlüssel, und der Agent erhält
**über 40 Tools**, darunter ein On-Page-SEO-Audit, KI-Bereitschaft, eine vollständige Sicherheitsnote von A+ bis F
und E-Mail-Zustellbarkeit.

## Inhalt

- [Installation](#installation)
- [Was Sie fragen können](#was-sie-fragen-können)
- [Echtes Beispiel](#echtes-beispiel)
- [Was geprüft wird](#was-geprüft-wird)
- [Eingebaute Abläufe](#eingebaute-abläufe)
- [MCP-Server verbinden](#mcp-server-verbinden)
- [Tarife und Limits](#tarife-und-limits)
- [Sicherheit und Datenschutz](#sicherheit-und-datenschutz)
- [FAQ](#faq)

## Installation

**Jeder Agent, den die skills CLI unterstützt** (Claude Code, Codex, Cursor, Gemini CLI und weitere):

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Claude-Code-Plugin** – das Repository ist zugleich ein Plugin-Marketplace:

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**Manuell** – kopieren Sie [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) in den
Skills-Ordner Ihres Agenten, z. B. `~/.claude/skills/` bei Claude Code.

Die 19 offenen Prüfungen brauchen keine Konfiguration. Für den vollen Funktionsumfang
[verbinden Sie den MCP-Server](#mcp-server-verbinden).

## Was Sie fragen können

- „example.com lädt nicht. Finde heraus, welche Schicht ausfällt: DNS, TLS, HTTP oder Weiterleitungen.“
- „Geh die Pre-Launch-Checkliste für shop.example.com durch.“
- „Wir haben gestern das DNS umgezogen – sehen alle Resolver schon die Änderung?“
- „Wann laufen die Zertifikate dieser fünf Domains ab, und wie gut ist ihr TLS-Setup?“
- „Bewerte die Sicherheits-Header und Cookies meiner Website und sag mir genau, was ich ergänzen muss.“
- „Warum landen unsere E-Mails im Spam? Prüfe MX, SPF, DKIM und DMARC.“
- „Blockiert meine robots.txt KI-Crawler? Sind die strukturierten Daten gültig?“

## Echtes Beispiel

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

Echter Lauf vom 11. November 2026, Open-API-Modus, 5 Anfragen. Die Frage war auf Englisch, deshalb ist auch der
Bericht auf Englisch; fragen Sie auf Deutsch, kommt der Bericht auf Deutsch.

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

## Was geprüft wird

| Bereich | Ohne Schlüssel (Open API) | Mit kostenlosem Schlüssel (MCP-Server) |
|---|---|---|
| HTTP | Statuscode, Antwort-Header, Weiterleitungskette, HTTP/2 und HTTP/3, Auflösen von Kurzlinks | + Mixed Content, finale URL, Wayback-Verlauf |
| TLS | Zertifikat, Kette, SAN, Ablaufdatum, Protokolle, TLS-Note | gleich |
| DNS und Domains | Einträge, Verbreitung über öffentliche Resolver, MX, DKIM, WHOIS, ASN, IP-Daten | + SPF/DKIM/DMARC in einer Prüfung, Reverse-IP, Subdomains aus CT-Logs |
| Sicherheit | Note der Sicherheits-Header (aus `headers`), Content-Security-Policy, CORS, Cookie-Flags | + vollständige Sicherheitsnote von A+ bis F |
| E-Mail | MX mit SMTP-Banner, DKIM | + vollständiges Audit (SPF, DMARC, BIMI, MTA-STS), STARTTLS-Test, Header-Analyse |
| SEO und KI | robots.txt mit KI-Crawler-Regeln, strukturierte Daten, Open Graph | + On-Page-SEO-Audit, KI-Bereitschaft, Technologie- und CMS-Erkennung, PageSpeed |
| Netzwerk | ping | + Traceroute |
| Ihr Konto | — | Monitore (auflisten, anlegen, pausieren), beobachtete Assets und Ereignisse |

Vollständige Tool-Liste: [TOOLS.md](TOOLS.md). Referenz der
Open API: [open-api.md](skills/enterno-website-diagnostics/references/open-api.md).

## Eingebaute Abläufe

Der Skill enthält Schritt-für-Schritt-Abläufe, damit der Agent die richtigen Prüfungen in der richtigen Reihenfolge
ausführt:

- **„Ist die Website down?“** – geht HTTP → DNS → ping → TLS durch und nennt die erste ausfallende Schicht mit Beleg.
- **Checkliste vor dem Launch / nach der Migration** – DNS, Verbreitung, Zertifikatsabdeckung für www und die
  Hauptdomain, Weiterleitungen, Sicherheits- und Cache-Header, HTTP/2 und HTTP/3, robots.txt, strukturierte Daten.
- **Sicherheits-Header und Cookies** – was fehlt, warum es wichtig ist, welcher Header genau hinzukommt.
- **E-Mail-Zustellbarkeit** – MX mit SMTP-Banner, SPF und DMARC aus dem DNS, DKIM per Selektor; das
  vollständige Audit über den MCP-Server.
- **Zertifikatsablauf über viele Domains** – eine Tabelle, die nächsten Termine zuerst.

Jeder Bericht hat dieselbe Form: ein einzeiliges Fazit, eine Befundtabelle (Schweregrad, Befund, Beleg, Korrektur)
und eine ehrliche Liste dessen, was nicht geprüft wurde.

## MCP-Server verbinden

Der Skill nutzt den MCP-Server automatisch, sobald dessen Tools verfügbar sind.

| | |
|---|---|
| Endpunkt | `https://enterno.io/mcp` |
| Transport | Streamable HTTP (JSON-RPC 2.0), Protokollversion `2024-11-05` |
| Authentifizierung | API-Schlüssel: `Authorization: Bearer ent_…` oder `X-API-Key: ent_…` |
| Schlüssel | Kostenlos – Konto unter <https://enterno.io/en/register> anlegen, dann im Dashboard einen Schlüssel erstellen |
| Registry | `io.enterno/site-diagnostics` in der [offiziellen MCP Registry](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno) |
| Dokumentation | <https://enterno.io/en/mcp-server> |

Der `initialize`-Handshake ist offen, `tools/list` und `tools/call` brauchen einen Schlüssel: Ohne ihn antwortet
der Server mit HTTP 401 `API key required`.

Claude Code:

```bash
read -rs ENTERNO_API_KEY   # Schlüssel einfügen: wird weder angezeigt noch im Verlauf gespeichert
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

Der Schlüssel wird in der Benutzerkonfiguration von Claude Code gespeichert. Fügen Sie ihn nicht mit
`--scope project` hinzu: Dann landet er in `.mcp.json` im Repository und damit in einem Commit.

Konfigurationen für Claude Desktop, Codex CLI, Cursor, VS Code und Zed finden Sie im
[englischen README](README.md#connect-the-mcp-server) und im Ordner [`examples/`](examples/). Bewahren Sie den
Schlüssel in einer Umgebungsvariable oder im Secret-Speicher des Clients auf, nicht in Projektdateien.

## Tarife und Limits

- **Open API** – ohne Schlüssel, 10 bis 30 Anfragen pro Minute je Tool und IP. Ein vollständiges Audit einer
  Website braucht rund 15 Anfragen. Klartext, JSON oder CSV: `https://enterno.io/api/open/<tool>?q=<target>`
  ([Dokumentation](https://enterno.io/en/api-docs)).
- **MCP-Server** – der Schlüssel ist kostenlos. Tool-Aufrufe zählen gegen das tägliche API-Kontingent Ihres Tarifs;
  die Zahlen je Tarif stehen unter <https://enterno.io/en/pricing>. Alle Tools
  funktionieren mit einem kostenlosen Schlüssel: Der Tarif bestimmt, wie viele Aufrufe pro Tag möglich sind, nicht welche Tools.
- Das Ratenlimit gilt pro Schlüssel (Sliding Window); Antworten enthalten `X-RateLimit-*`-Header.

## Sicherheit und Datenschutz

- Geprüft werden nur die Hosts, die Sie nennen. Der Skill crawlt nicht darüber hinaus und sondiert keine Ports oder
  Subdomains auf eigene Faust.
- Anfragen an private, Loopback- und interne Adressen lehnt der Server ab.
- Der Skill fordert Sie nie auf, einen Schlüssel in den Chat einzufügen, und schreibt ihn nie in Projektdateien.
- Es werden keine lokalen Dateien gelesen oder gesendet; der Skill enthält keine Skripte, nur Anweisungen und
  Referenzdokumente. Konfigurationsbeispiele für jeden Client liegen in [`examples/`](examples/).

## FAQ

**Brauche ich ein Konto?** Für die 19 offenen Prüfungen nicht. Ein kostenloses Konto liefert den API-Schlüssel für
die MCP-Tools.

**Mit welchen Agenten funktioniert er?** Mit jedem Agenten, der HTTP-Anfragen senden oder MCP-Tools nutzen kann:
Claude Code, Claude Desktop, Codex CLI, Cursor, VS Code, Zed, Gemini CLI und weiteren.

**Von wo laufen die Prüfungen?** Von den Servern von Enterno.io – das Ergebnis hängt also nicht von Ihrem Netzwerk,
VPN oder DNS-Cache ab.

**In welcher Sprache kommt der Bericht?** In der Sprache, in der Sie fragen.

**Ist der MCP-Server Open Source?** Nein. Dieses Repository enthält den Skill, die Dokumentation und die
Client-Konfigurationen; der Server ist ein gehosteter Dienst von [enterno.io](https://enterno.io) mit kostenlosem Tarif.

## Support

Fragen und Fehlerberichte: [Issue eröffnen](https://github.com/enterno-io/enterno-mcp/issues) oder über
<https://enterno.io/en/contact> schreiben.

## Lizenz

Skill, Dokumentation und Beispiele in diesem Repository stehen unter der MIT-Lizenz – siehe [LICENSE](LICENSE).
Der Dienst Enterno.io ist proprietär und hat einen kostenlosen Tarif.
