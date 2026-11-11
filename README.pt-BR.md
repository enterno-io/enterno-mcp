<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.es.md">Español</a> ·
  <b>Português</b> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a>
</p>

<p align="center">
  <img src="agensi/logo-512.png" alt="Enterno.io" width="96" height="96">
</p>

<p align="center">
  <b>Diagnóstico de sites e domínios para agentes de IA.</b><br>
  Pergunte ao seu agente "por que meu site está fora do ar?" ou "verifique example.com antes do lançamento" e
  receba um relatório curto com evidências e correções concretas, não uma pilha de dados brutos.
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#instalação"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="19 verificações sem chave">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="Mais de 40 ferramentas MCP com chave gratuita">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="Licença MIT"></a>
</p>

---

A skill **`enterno-website-diagnostics`** ensina Claude Code, Codex, Cursor e outros agentes a verificar um site ou
domínio público e a transformar os resultados em um relatório acionável. As verificações rodam nos servidores da
Enterno.io, então o site é visto como a internet o vê, e não a partir do seu notebook ou VPN.

Funciona assim que é instalada: **19 verificações não exigem conta nem chave**. Conecte o
[servidor MCP da Enterno.io](#conectar-o-servidor-mcp) com uma chave gratuita e o agente ganha **mais de 40
ferramentas**, incluindo auditoria de SEO da página, prontidão para IA, nota de segurança completa de A+ a F e
entregabilidade de e-mail.

## Conteúdo

- [Instalação](#instalação)
- [O que você pode perguntar](#o-que-você-pode-perguntar)
- [Exemplo real](#exemplo-real)
- [O que é verificado](#o-que-é-verificado)
- [Roteiros incluídos](#roteiros-incluídos)
- [Conectar o servidor MCP](#conectar-o-servidor-mcp)
- [Planos e limites](#planos-e-limites)
- [Segurança e privacidade](#segurança-e-privacidade)
- [Perguntas frequentes](#perguntas-frequentes)

## Instalação

**Qualquer agente compatível com o skills CLI** (Claude Code, Codex, Cursor, Gemini CLI e outros):

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Plugin do Claude Code** — o repositório também é um marketplace de plugins:

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**Codex, Gemini CLI, GitHub Copilot CLI e Cursor** — o mesmo repositório também é um plugin para eles
(padrão Agent Plugins e extensão do Gemini CLI):

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

**Manualmente** — copie [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) para a pasta
de skills do seu agente, por exemplo `~/.claude/skills/` no Claude Code.

As 19 verificações abertas não precisam de configuração. Para o conjunto completo,
[conecte o servidor MCP](#conectar-o-servidor-mcp).

## O que você pode perguntar

- "example.com não abre. Descubra qual camada falha: DNS, TLS, HTTP ou redirecionamentos."
- "Rode o checklist de pré-lançamento de shop.example.com."
- "Migramos o DNS ontem — todos os resolvers já enxergam a mudança?"
- "Quando vencem os certificados destes cinco domínios e como está o TLS deles?"
- "Avalie os cabeçalhos de segurança e os cookies do meu site e diga exatamente o que adicionar."
- "Por que nossos e-mails caem no spam? Verifique MX, SPF, DKIM e DMARC."
- "Meu robots.txt bloqueia crawlers de IA? Os dados estruturados são válidos?"

## Exemplo real

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

Execução real de 11 de novembro de 2026, modo API aberta, 5 requisições. A pergunta foi feita em inglês, por isso o
relatório está em inglês; pergunte em português e o relatório virá em português.

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

## O que é verificado

| Área | Sem chave (API aberta) | Com chave gratuita (servidor MCP) |
|---|---|---|
| HTTP | código de status, cabeçalhos, cadeia de redirecionamentos, HTTP/2 e HTTP/3, expansão de links curtos | + conteúdo misto, URL final, histórico no Wayback |
| TLS | certificado, cadeia, SAN, validade, protocolos, nota de TLS | igual |
| DNS e domínios | registros, propagação em resolvers públicos, MX, DKIM, WHOIS, ASN, dados de IP | + SPF/DKIM/DMARC em uma verificação, IP reverso, subdomínios dos logs de CT |
| Segurança | nota dos cabeçalhos de segurança (de `headers`), Content-Security-Policy, CORS, flags de cookies | + nota de segurança completa de A+ a F |
| E-mail | MX com banner SMTP, DKIM | + auditoria completa (SPF, DMARC, BIMI, MTA-STS), teste de STARTTLS, análise de cabeçalhos |
| SEO e IA | robots.txt com a política para crawlers de IA, dados estruturados, Open Graph | + auditoria de SEO da página, prontidão para IA, detecção de tecnologias e CMS, PageSpeed |
| Rede | ping | + traceroute |
| Sua conta | — | monitores (listar, criar, pausar), ativos observados e eventos |

Lista completa de ferramentas: [TOOLS.md](TOOLS.md). Referência da API aberta:
[open-api.md](skills/enterno-website-diagnostics/references/open-api.md).

## Roteiros incluídos

A skill traz roteiros passo a passo, então o agente executa as verificações certas na ordem certa:

- **"O site caiu?"** — percorre HTTP → DNS → ping → TLS e aponta a primeira camada que falha, com evidência.
- **Checklist pré-lançamento / pós-migração** — DNS, propagação, cobertura do certificado para www e o domínio
  raiz, redirecionamentos, cabeçalhos de segurança e cache, HTTP/2 e HTTP/3, robots.txt, dados estruturados.
- **Cabeçalhos de segurança e cookies** — o que falta, por que importa e o cabeçalho exato a adicionar.
- **Entregabilidade de e-mail** — MX com banner SMTP, SPF e DMARC a partir do DNS, DKIM por seletor; a
  auditoria completa, pelo servidor MCP.
- **Validade de certificados em vários domínios** — uma tabela, os mais próximos de vencer primeiro.

Todo relatório segue o mesmo formato: veredito em uma linha, tabela de achados (gravidade, achado, evidência,
correção) e uma lista honesta do que não foi verificado.

## Conectar o servidor MCP

A skill usa o servidor MCP automaticamente quando as ferramentas dele estão disponíveis.

| | |
|---|---|
| Endpoint | `https://enterno.io/mcp` |
| Transporte | Streamable HTTP (JSON-RPC 2.0), versão do protocolo `2024-11-05` |
| Autenticação | Chave de API: `Authorization: Bearer ent_…` ou `X-API-Key: ent_…` |
| Chave | Gratuita — crie uma conta em <https://enterno.io/en/register> e gere a chave no painel |
| Registro | `io.enterno/site-diagnostics` no [MCP Registry oficial](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno) |
| Documentação | <https://enterno.io/en/mcp-server> |

O handshake `initialize` é aberto, mas `tools/list` e `tools/call` exigem chave: sem ela o servidor responde
HTTP 401 `API key required`.

Claude Code:

```bash
read -rs ENTERNO_API_KEY   # cole a chave: ela não aparece na tela nem fica no histórico
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

A chave fica salva na configuração de usuário do Claude Code. Não a adicione com `--scope project`: isso grava
`.mcp.json` dentro do repositório, e ele acaba em um commit.

As configurações para Claude Desktop, Codex CLI, Cursor, VS Code e Zed estão no
[README em inglês](README.md#connect-the-mcp-server) e na pasta [`examples/`](examples/). Guarde a chave em uma
variável de ambiente ou no cofre de segredos do cliente, não em arquivos do projeto.

## Planos e limites

- **API aberta** — sem chave, de 10 a 30 requisições por minuto por ferramenta e por IP. Uma auditoria completa de
  um site leva cerca de 15 requisições. Texto puro, JSON ou CSV: `https://enterno.io/api/open/<tool>?q=<target>`
  ([documentação](https://enterno.io/en/api-docs)).
- **Servidor MCP** — a chave é gratuita. As chamadas contam na cota diária de API do seu plano; os números por plano
  estão em <https://enterno.io/en/pricing>. Todas as
  ferramentas funcionam com uma chave gratuita: o plano muda quantas chamadas por dia você tem, não quais ferramentas pode usar.
- O limite de frequência é por chave (janela deslizante); as respostas trazem cabeçalhos `X-RateLimit-*`.

## Segurança e privacidade

- Só são verificados os hosts que você informar. A skill não rastreia além deles nem sonda portas ou subdomínios
  por conta própria.
- O servidor recusa requisições para endereços privados, de loopback e internos.
- A skill nunca pede que você cole uma chave no chat e nunca a grava em arquivos do projeto.
- Nenhum arquivo local é lido ou enviado; a skill não traz scripts, apenas instruções e documentação de
  referência. Exemplos de configuração para cada cliente ficam em [`examples/`](examples/).

## Perguntas frequentes

**Preciso de uma conta?** Não para as 19 verificações abertas. Uma conta gratuita dá a chave de API para as
ferramentas MCP.

**Com quais agentes funciona?** Com qualquer agente que faça requisições HTTP ou use ferramentas MCP: Claude Code,
Claude Desktop, Codex CLI, Cursor, VS Code, Zed, Gemini CLI e outros.

**De onde as verificações são feitas?** Dos servidores da Enterno.io, então o resultado não depende da sua rede, VPN
ou cache de DNS.

**Em que idioma vem o relatório?** No idioma em que você perguntar.

**O servidor MCP é open source?** Não. Este repositório contém a skill, a documentação e as configurações de cliente;
o servidor é um serviço hospedado da [enterno.io](https://enterno.io) com plano gratuito.

## Suporte

Dúvidas e bugs: [abra uma issue](https://github.com/enterno-io/enterno-mcp/issues) ou escreva em
<https://enterno.io/en/contact>.

## Licença

A skill, a documentação e os exemplos deste repositório usam a licença MIT; veja [LICENSE](LICENSE).
O serviço Enterno.io é proprietário e tem um plano gratuito.
