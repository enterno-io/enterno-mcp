<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <b>Español</b> ·
  <a href="README.pt-BR.md">Português</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a>
</p>

<p align="center">
  <img src="agensi/logo-512.png" alt="Enterno.io" width="96" height="96">
</p>

<p align="center">
  <b>Diagnóstico de sitios web y dominios para agentes de IA.</b><br>
  Pregunta a tu agente «¿por qué no carga mi sitio?» o «revisa example.com antes del lanzamiento» y recibe un
  informe breve con evidencias y correcciones concretas, no un montón de datos en bruto.
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#instalación"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="19 comprobaciones sin clave">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="Más de 40 herramientas MCP con clave gratuita">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="Licencia MIT"></a>
</p>

---

La skill **`enterno-website-diagnostics`** enseña a Claude Code, Codex, Cursor y otros agentes a revisar un sitio
web o dominio público y a convertir los resultados en un informe con el que se puede actuar. Las comprobaciones se
ejecutan en los servidores de Enterno.io, así que el sitio se ve como lo ve internet, no desde tu portátil o tu VPN.

Funciona en cuanto la instalas: **19 comprobaciones no requieren cuenta ni clave**. Conecta el
[servidor MCP de Enterno.io](#conectar-el-servidor-mcp) con una clave gratuita y el agente obtiene **más de 40
herramientas**, entre ellas auditoría SEO de página, preparación para IA, una calificación de seguridad completa de
A+ a F y entregabilidad del correo.

## Contenido

- [Instalación](#instalación)
- [Qué puedes preguntar](#qué-puedes-preguntar)
- [Ejemplo real](#ejemplo-real)
- [Qué comprueba](#qué-comprueba)
- [Recetas incluidas](#recetas-incluidas)
- [Conectar el servidor MCP](#conectar-el-servidor-mcp)
- [Planes y límites](#planes-y-límites)
- [Seguridad y privacidad](#seguridad-y-privacidad)
- [Preguntas frecuentes](#preguntas-frecuentes)

## Instalación

**Cualquier agente compatible con skills CLI** (Claude Code, Codex, Cursor, Gemini CLI y otros):

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Plugin de Claude Code**: el repositorio también es un marketplace de plugins:

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**Codex, Gemini CLI, GitHub Copilot CLI y Cursor**: el mismo repositorio también es un plugin para ellos
(estándar Agent Plugins y extensión de Gemini CLI):

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

**A mano**: copia [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) en la carpeta de
skills de tu agente, por ejemplo `~/.claude/skills/` en Claude Code.

Las 19 comprobaciones abiertas no necesitan configuración. Para el conjunto completo,
[conecta el servidor MCP](#conectar-el-servidor-mcp).

## Qué puedes preguntar

- «example.com no carga. Encuentra qué capa falla: DNS, TLS, HTTP o redirecciones».
- «Pasa la lista de comprobación previa al lanzamiento de shop.example.com».
- «Ayer migramos el DNS: ¿todos los resolvers ya ven el cambio?»
- «¿Cuándo caducan los certificados de estos cinco dominios y qué tal está su TLS?»
- «Evalúa las cabeceras de seguridad y las cookies de mi sitio y dime exactamente qué añadir».
- «¿Por qué nuestros correos llegan a spam? Revisa MX, SPF, DKIM y DMARC».
- «¿Mi robots.txt bloquea a los rastreadores de IA? ¿Son válidos los datos estructurados?»

## Ejemplo real

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

Ejecución real del 11 de noviembre de 2026, modo API abierta, 5 peticiones. La pregunta se hizo en inglés, por eso
el informe está en inglés; pregunta en español y el informe saldrá en español.

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

## Qué comprueba

| Área | Sin clave (API abierta) | Con clave gratuita (servidor MCP) |
|---|---|---|
| HTTP | código de estado, cabeceras, cadena de redirecciones, HTTP/2 y HTTP/3, expansión de enlaces cortos | + contenido mixto, URL final, historial en Wayback |
| TLS | certificado, cadena, SAN, caducidad, protocolos, calificación TLS | igual |
| DNS y dominios | registros, propagación en resolvers públicos, MX, DKIM, WHOIS, ASN, datos de IP | + SPF/DKIM/DMARC en una sola comprobación, IP inversa, subdominios de los registros CT |
| Seguridad | calificación de cabeceras de seguridad (de `headers`), Content-Security-Policy, CORS, atributos de cookies | + calificación de seguridad completa de A+ a F |
| Correo | MX con banner SMTP, DKIM | + auditoría completa (SPF, DMARC, BIMI, MTA-STS), prueba de STARTTLS, análisis de cabeceras |
| SEO e IA | robots.txt con la política para rastreadores de IA, datos estructurados, Open Graph | + auditoría SEO de página, preparación para IA, detección de tecnologías y CMS, PageSpeed |
| Red | ping | + traceroute |
| Tu cuenta | — | monitores (listar, crear, pausar), activos observados y eventos |

Lista completa de herramientas: [TOOLS.md](TOOLS.md). Referencia de la
API abierta: [open-api.md](skills/enterno-website-diagnostics/references/open-api.md).

## Recetas incluidas

La skill incluye guías paso a paso, así que el agente ejecuta las comprobaciones correctas en el orden correcto:

- **«¿Se ha caído el sitio?»**: recorre HTTP → DNS → ping → TLS e indica la primera capa que falla, con evidencia.
- **Lista previa al lanzamiento / tras la migración**: DNS, propagación, cobertura del certificado para www y el
  dominio raíz, redirecciones, cabeceras de seguridad y caché, HTTP/2 y HTTP/3, robots.txt, datos estructurados.
- **Cabeceras de seguridad y cookies**: qué falta, por qué importa y la cabecera exacta que hay que añadir.
- **Entregabilidad del correo**: MX con banner SMTP, SPF y DMARC desde el DNS, DKIM por selector; la auditoría
  completa, con el servidor MCP.
- **Caducidad de certificados en muchos dominios**: una sola tabla, los más próximos primero.

Todos los informes tienen la misma forma: un veredicto en una línea, una tabla de hallazgos (gravedad, hallazgo,
evidencia, corrección) y una lista honesta de lo que no se comprobó.

## Conectar el servidor MCP

La skill usa el servidor MCP automáticamente cuando sus herramientas están disponibles.

| | |
|---|---|
| Endpoint | `https://enterno.io/mcp` |
| Transporte | Streamable HTTP (JSON-RPC 2.0), versión de protocolo `2024-11-05` |
| Autenticación | Clave de API: `Authorization: Bearer ent_…` o `X-API-Key: ent_…` |
| Clave | Gratuita: crea una cuenta en <https://enterno.io/en/register> y genera una clave en el panel |
| Registro | `io.enterno/site-diagnostics` en el [MCP Registry oficial](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno) |
| Documentación | <https://enterno.io/en/mcp-server> |

El handshake `initialize` es abierto, pero `tools/list` y `tools/call` requieren clave: sin ella el servidor
responde HTTP 401 `API key required`.

Claude Code:

```bash
read -rs ENTERNO_API_KEY   # pega la clave: no se muestra ni se guarda en el historial
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

La clave se guarda en la configuración de usuario de Claude Code. No la añadas con `--scope project`: eso escribe
`.mcp.json` dentro del repositorio y acaba en un commit.

Las configuraciones para Claude Desktop, Codex CLI, Cursor, VS Code y Zed están en el
[README en inglés](README.md#connect-the-mcp-server) y en la carpeta [`examples/`](examples/). Guarda la clave en
una variable de entorno o en el almacén de secretos del cliente, no en archivos del proyecto.

## Planes y límites

- **API abierta**: sin clave, de 10 a 30 peticiones por minuto por herramienta y por IP. Una auditoría completa de
  un sitio son unas 15 peticiones. Texto plano, JSON o CSV: `https://enterno.io/api/open/<tool>?q=<target>`
  ([documentación](https://enterno.io/en/api-docs)).
- **Servidor MCP**: la clave es gratuita. Las llamadas cuentan contra el cupo diario de API de tu plan; los números
  por plan están en <https://enterno.io/en/pricing>. Todas las
  herramientas funcionan con una clave gratuita: el plan cambia cuántas llamadas al día tienes, no qué herramientas puedes usar.
- El límite de frecuencia es por clave (ventana deslizante); las respuestas incluyen cabeceras `X-RateLimit-*`.

## Seguridad y privacidad

- Solo se comprueban los hosts que indicas. La skill no rastrea más allá ni sondea puertos o subdominios por su cuenta.
- El servidor rechaza las peticiones a direcciones privadas, de loopback e internas.
- La skill nunca te pide pegar una clave en el chat ni la escribe en archivos del proyecto.
- No se leen ni se envían archivos locales; la skill no incluye scripts, solo instrucciones y documentación de
  referencia. Los ejemplos de configuración de cada cliente están en [`examples/`](examples/).

## Preguntas frecuentes

**¿Necesito una cuenta?** No para las 19 comprobaciones abiertas. Una cuenta gratuita te da la clave de API para las
herramientas MCP.

**¿Con qué agentes funciona?** Con cualquier agente que pueda hacer peticiones HTTP o usar herramientas MCP:
Claude Code, Claude Desktop, Codex CLI, Cursor, VS Code, Zed, Gemini CLI y otros.

**¿Desde dónde se ejecutan las comprobaciones?** Desde los servidores de Enterno.io, así que el resultado no depende
de tu red, tu VPN ni tu caché DNS.

**¿En qué idioma sale el informe?** En el idioma en que preguntes.

**¿El servidor MCP es de código abierto?** No. Este repositorio contiene la skill, la documentación y las
configuraciones de cliente; el servidor es un servicio alojado de [enterno.io](https://enterno.io) con plan gratuito.

## Soporte

Preguntas y errores: [abre un issue](https://github.com/enterno-io/enterno-mcp/issues) o escribe desde
<https://enterno.io/en/contact>.

## Licencia

La skill, la documentación y los ejemplos de este repositorio tienen licencia MIT; consulta [LICENSE](LICENSE).
El servicio Enterno.io es propietario y tiene un plan gratuito.
