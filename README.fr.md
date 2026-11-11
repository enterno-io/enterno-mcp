<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt-BR.md">Português</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <b>Français</b>
</p>

<p align="center">
  <img src="agensi/logo-512.png" alt="Enterno.io" width="96" height="96">
</p>

<p align="center">
  <b>Diagnostic de sites web et de domaines pour les agents IA.</b><br>
  Demandez à votre agent « pourquoi mon site est-il en panne ? » ou « vérifie example.com avant le lancement » et
  recevez un rapport court avec des preuves et des correctifs concrets, pas une montagne de données brutes.
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#installation"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="19 vérifications sans clé">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="Plus de 40 outils MCP avec une clé gratuite">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="Licence MIT"></a>
</p>

---

La skill **`enterno-website-diagnostics`** apprend à Claude Code, Codex, Cursor et à d'autres agents à vérifier un
site web ou un domaine public et à transformer les résultats en un rapport directement exploitable. Les vérifications
s'exécutent sur les serveurs d'Enterno.io : le site est vu comme Internet le voit, et non depuis votre portable ou
votre VPN.

Elle fonctionne dès l'installation : **19 vérifications ne demandent ni compte ni clé**. Connectez le
[serveur MCP d'Enterno.io](#connecter-le-serveur-mcp) avec une clé gratuite, et l'agent dispose de **plus de 40
outils**, dont un audit SEO de page, l'évaluation de la préparation à l'IA, une note de sécurité complète de A+ à F
et la délivrabilité des e-mails.

## Sommaire

- [Installation](#installation)
- [Ce que vous pouvez demander](#ce-que-vous-pouvez-demander)
- [Exemple réel](#exemple-réel)
- [Ce qui est vérifié](#ce-qui-est-vérifié)
- [Scénarios intégrés](#scénarios-intégrés)
- [Connecter le serveur MCP](#connecter-le-serveur-mcp)
- [Offres et limites](#offres-et-limites)
- [Sécurité et confidentialité](#sécurité-et-confidentialité)
- [FAQ](#faq)

## Installation

**Tout agent pris en charge par la CLI skills** (Claude Code, Codex, Cursor, Gemini CLI et d'autres) :

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Plugin Claude Code** — le dépôt est aussi une marketplace de plugins :

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**Codex, Gemini CLI, GitHub Copilot CLI et Cursor** — le même dépôt sert aussi de plugin pour eux
(standard Agent Plugins et extension Gemini CLI) :

```bash
# Codex
codex plugin marketplace add enterno-io/enterno-mcp
codex plugin add enterno-website-diagnostics@enterno-io

# Gemini CLI
gemini extensions install https://github.com/enterno-io/enterno-mcp

# GitHub Copilot CLI
copilot plugin install enterno-io/enterno-mcp

# Cursor
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics -a cursor
```

**À la main** — copiez [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) dans le dossier
des skills de votre agent, par exemple `~/.claude/skills/` pour Claude Code.

Les 19 vérifications ouvertes ne demandent aucune configuration. Pour l'ensemble des outils,
[connectez le serveur MCP](#connecter-le-serveur-mcp).

## Ce que vous pouvez demander

- « example.com ne répond plus. Trouve quelle couche échoue : DNS, TLS, HTTP ou redirections. »
- « Passe la checklist d'avant lancement pour shop.example.com. »
- « Nous avons migré le DNS hier : tous les résolveurs voient-ils le changement ? »
- « Quand expirent les certificats de ces cinq domaines, et leur configuration TLS est-elle bonne ? »
- « Note les en-têtes de sécurité et les cookies de mon site et dis-moi exactement quoi ajouter. »
- « Pourquoi nos e-mails arrivent-ils en spam ? Vérifie MX, SPF, DKIM et DMARC. »
- « Mon robots.txt bloque-t-il les robots d'IA ? Les données structurées sont-elles valides ? »

## Exemple réel

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

Exécution réelle du 11 novembre 2026, mode API ouverte, 5 requêtes. La question était en anglais, donc le rapport
aussi ; posez-la en français et le rapport sera en français.

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

## Ce qui est vérifié

| Domaine | Sans clé (API ouverte) | Avec une clé gratuite (serveur MCP) |
|---|---|---|
| HTTP | code de statut, en-têtes de réponse, chaîne de redirections, HTTP/2 et HTTP/3, développement des liens courts | + contenu mixte, URL finale, historique Wayback |
| TLS | certificat, chaîne, SAN, expiration, protocoles, note TLS | identique |
| DNS et domaines | enregistrements, propagation sur les résolveurs publics, MX, DKIM, WHOIS, ASN, données IP | + SPF/DKIM/DMARC en une vérification, IP inverse, sous-domaines issus des journaux CT |
| Sécurité | note des en-têtes de sécurité (via `headers`), Content-Security-Policy, CORS, attributs des cookies | + note de sécurité complète de A+ à F |
| E-mail | MX avec bannière SMTP, DKIM | + audit complet (SPF, DMARC, BIMI, MTA-STS), test STARTTLS, analyse d'en-têtes |
| SEO et IA | robots.txt avec la politique pour les robots d'IA, données structurées, Open Graph | + audit SEO de page, préparation à l'IA, détection des technologies et du CMS, PageSpeed |
| Réseau | ping | + traceroute |
| Votre compte | — | moniteurs (liste, création, pause), actifs observés et événements |

Liste complète des outils : [TOOLS.md](TOOLS.md). Référence de l'API
ouverte : [open-api.md](skills/enterno-website-diagnostics/references/open-api.md).

## Scénarios intégrés

La skill contient des procédures pas à pas : l'agent lance les bonnes vérifications dans le bon ordre.

- **« Le site est-il en panne ? »** — parcourt HTTP → DNS → ping → TLS et désigne la première couche défaillante,
  preuve à l'appui.
- **Checklist avant lancement / après migration** — DNS, propagation, couverture du certificat pour www et le domaine
  principal, redirections, en-têtes de sécurité et de cache, HTTP/2 et HTTP/3, robots.txt, données structurées.
- **En-têtes de sécurité et cookies** — ce qui manque, pourquoi c'est important, l'en-tête exact à ajouter.
- **Délivrabilité des e-mails** — MX avec bannière SMTP, SPF et DMARC depuis le DNS, DKIM par sélecteur ; l'audit
  complet passe par le serveur MCP.
- **Expiration des certificats sur de nombreux domaines** — un seul tableau, les plus proches en premier.

Chaque rapport suit la même forme : un verdict en une ligne, un tableau des constats (gravité, constat, preuve,
correctif) et une liste honnête de ce qui n'a pas été vérifié.

## Connecter le serveur MCP

La skill utilise automatiquement le serveur MCP lorsque ses outils sont disponibles.

| | |
|---|---|
| Point d'accès | `https://enterno.io/mcp` |
| Transport | Streamable HTTP (JSON-RPC 2.0), version du protocole `2024-11-05` |
| Authentification | Clé d'API : `Authorization: Bearer ent_…` ou `X-API-Key: ent_…` |
| Clé | Gratuite — créez un compte sur <https://enterno.io/en/register>, puis une clé dans le tableau de bord |
| Registre | `io.enterno/site-diagnostics` dans le [MCP Registry officiel](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno) |
| Documentation | <https://enterno.io/en/mcp-server> |

La négociation `initialize` est ouverte, mais `tools/list` et `tools/call` exigent une clé : sans elle, le serveur
répond HTTP 401 `API key required`.

Claude Code :

```bash
read -rs ENTERNO_API_KEY   # collez la clé : elle ne s'affiche pas et n'entre pas dans l'historique
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

La clé est enregistrée dans la configuration utilisateur de Claude Code. Ne l'ajoutez pas avec `--scope project` :
elle serait écrite dans `.mcp.json` à l'intérieur du dépôt et finirait dans un commit.

Les configurations pour Claude Desktop, Codex CLI, Cursor, VS Code et Zed se trouvent dans le
[README en anglais](README.md#connect-the-mcp-server) et dans le dossier [`examples/`](examples/). Conservez la clé
dans une variable d'environnement ou dans le coffre à secrets du client, pas dans les fichiers du projet.

## Offres et limites

- **API ouverte** — sans clé, de 10 à 30 requêtes par minute par outil et par IP. Un audit complet d'un site prend
  environ 15 requêtes. Texte brut, JSON ou CSV : `https://enterno.io/api/open/<tool>?q=<target>`
  ([documentation](https://enterno.io/en/api-docs)).
- **Serveur MCP** — la clé est gratuite. Les appels d'outils sont décomptés du quota d'API quotidien de votre offre ;
  les chiffres par offre sont sur <https://enterno.io/en/pricing>. Tous les
  outils fonctionnent avec une clé gratuite : l'offre change le nombre d'appels par jour, pas les outils disponibles.
- La limite de débit s'applique par clé (fenêtre glissante) ; les réponses portent des en-têtes `X-RateLimit-*`.

## Sécurité et confidentialité

- Seuls les hôtes que vous indiquez sont vérifiés. La skill n'explore rien au-delà et ne sonde ni ports ni
  sous-domaines de sa propre initiative.
- Le serveur refuse les requêtes vers les adresses privées, de bouclage et internes.
- La skill ne vous demande jamais de coller une clé dans la conversation et ne l'écrit jamais dans les fichiers du
  projet.
- Aucun fichier local n'est lu ni envoyé ; la skill ne contient aucun script, seulement des instructions et une
  documentation de référence. Les exemples de configuration de chaque client sont dans [`examples/`](examples/).

## FAQ

**Faut-il un compte ?** Pas pour les 19 vérifications ouvertes. Un compte gratuit fournit la clé d'API pour les
outils MCP.

**Avec quels agents fonctionne-t-elle ?** Avec tout agent capable d'envoyer des requêtes HTTP ou d'utiliser des
outils MCP : Claude Code, Claude Desktop, Codex CLI, Cursor, VS Code, Zed, Gemini CLI et d'autres.

**D'où partent les vérifications ?** Des serveurs d'Enterno.io : le résultat ne dépend ni de votre réseau, ni de
votre VPN, ni de votre cache DNS.

**Dans quelle langue est le rapport ?** Dans la langue de votre question.

**Le serveur MCP est-il open source ?** Non. Ce dépôt contient la skill, la documentation et les configurations des
clients ; le serveur est un service hébergé par [enterno.io](https://enterno.io), avec une offre gratuite.

## Support

Questions et rapports de bugs : [ouvrez une issue](https://github.com/enterno-io/enterno-mcp/issues) ou écrivez via
<https://enterno.io/en/contact>.

## Licence

La skill, la documentation et les exemples de ce dépôt sont sous licence MIT — voir [LICENSE](LICENSE).
Le service Enterno.io est propriétaire et propose une offre gratuite.
