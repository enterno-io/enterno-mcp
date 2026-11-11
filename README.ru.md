<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <b>Русский</b> ·
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
  <b>Диагностика сайтов и доменов для ИИ-агентов.</b><br>
  Спросите агента «почему лежит сайт?» или «проверь example.com перед запуском» — и получите короткий отчет
  с доказательствами и конкретными исправлениями, а не простыню сырых данных.
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#установка"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="19 проверок без ключа">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="40+ инструментов MCP с бесплатным ключом">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="Лицензия MIT"></a>
</p>

---

Скилл **`enterno-website-diagnostics`** учит Claude Code, Codex, Cursor и других агентов проверять публичный сайт или
домен и превращать результаты в отчет, по которому можно действовать. Проверки идут с серверов Enterno.io, поэтому
сайт виден так, как его видит интернет, а не с вашего ноутбука или через VPN.

Работает сразу после установки: **19 проверок не требуют ни аккаунта, ни ключа**. Подключите
[MCP-сервер Enterno.io](#подключение-mcp-сервера) с бесплатным ключом — и у агента появится **больше 40
инструментов**: SEO-аудит страницы, готовность к ИИ-поиску, полная оценка безопасности от A+ до F и проверка
доставляемости почты.

## Содержание

- [Установка](#установка)
- [Что можно спросить](#что-можно-спросить)
- [Как это выглядит](#как-это-выглядит)
- [Что проверяется](#что-проверяется)
- [Встроенные сценарии](#встроенные-сценарии)
- [Подключение MCP-сервера](#подключение-mcp-сервера)
- [Тарифы и лимиты](#тарифы-и-лимиты)
- [Безопасность и приватность](#безопасность-и-приватность)
- [Вопросы и ответы](#вопросы-и-ответы)

## Установка

**Любой агент, который поддерживает skills CLI** (Claude Code, Codex, Cursor, Gemini CLI и другие):

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Плагин Claude Code** — репозиторий одновременно служит каталогом плагинов:

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**Вручную** — скопируйте [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) в папку
скиллов вашего агента, например `~/.claude/skills/` для Claude Code.

Для 19 открытых проверок настраивать ничего не нужно. Для полного набора подключите MCP-сервер — см.
[Подключение MCP-сервера](#подключение-mcp-сервера).

## Что можно спросить

- «Почему не открывается example.com? Найди, где обрыв: DNS, TLS, HTTP или редиректы».
- «Пройдись по чек-листу перед запуском shop.example.com».
- «Вчера перенесли DNS — все ли резолверы видят новые записи?»
- «Когда истекают сертификаты этих пяти доменов и насколько хорошо настроен TLS?»
- «Оцени заголовки безопасности и куки моего сайта и скажи, что именно добавить».
- «Почему наши письма уходят в спам? Проверь MX, SPF, DKIM и DMARC».
- «Не закрывает ли robots.txt сайт от ИИ-краулеров? Корректна ли микроразметка?»

## Как это выглядит

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

Реальный прогон 11 ноября 2026 года, режим открытого API, 5 запросов. Запрос был на английском, поэтому и отчет на
английском; спросите по-русски — отчет будет на русском.

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

## Что проверяется

| Область | Без ключа (открытый API) | С бесплатным ключом (MCP-сервер) |
|---|---|---|
| HTTP | код ответа, заголовки, цепочка редиректов, HTTP/2 и HTTP/3, раскрытие коротких ссылок | + смешанный контент, конечный адрес, история в Wayback Machine |
| TLS | сертификат, цепочка, SAN, срок действия, протоколы, оценка TLS | то же |
| DNS и домены | записи, распространение по публичным резолверам, MX, DKIM, WHOIS, ASN, данные IP | + SPF/DKIM/DMARC одной проверкой, обратный IP, поддомены из CT-логов |
| Безопасность | оценка заголовков безопасности (из `headers`), Content-Security-Policy, CORS, флаги куки | + полная оценка безопасности от A+ до F |
| Почта | MX с баннером SMTP, DKIM | + полный аудит (SPF, DMARC, BIMI, MTA-STS), проверка STARTTLS, разбор заголовков письма |
| SEO и ИИ | robots.txt с правилами для ИИ-краулеров, микроразметка, Open Graph | + SEO-аудит страницы, готовность к ИИ-поиску, определение технологий и CMS, PageSpeed |
| Сеть | ping | + трассировка |
| Ваш аккаунт | — | мониторы (список, создание, пауза), наблюдаемые активы и события |

Полный список инструментов — [TOOLS.md](TOOLS.md), справка по открытому API —
[open-api.md](skills/enterno-website-diagnostics/references/open-api.md).

## Встроенные сценарии

В скилле есть пошаговые сценарии, поэтому агент запускает нужные проверки в нужном порядке:

- **«Почему лежит сайт?»** — HTTP → DNS → ping → TLS; называет первый слой, на котором обрыв, и доказательство.
- **Чек-лист перед запуском и после переезда** — DNS, распространение записей, покрытие сертификатом www и
  основного домена, редиректы, заголовки безопасности и кэша, HTTP/2 и HTTP/3, robots.txt, микроразметка.
- **Заголовки безопасности и куки** — чего не хватает, чем это опасно, какой именно заголовок добавить.
- **Доставляемость почты** — MX с баннером SMTP, SPF и DMARC из DNS, DKIM по селектору; полный аудит — через
  MCP-сервер.
- **Сроки сертификатов по многим доменам** — одна таблица, ближайшие сроки сверху.

Каждый отчет устроен одинаково: вердикт одной строкой, таблица находок (важность, находка, доказательство,
исправление) и честный список того, что не проверялось.

## Подключение MCP-сервера

Скилл сам использует MCP-сервер, когда его инструменты доступны агенту.

| | |
|---|---|
| Адрес | `https://enterno.io/mcp` |
| Транспорт | Streamable HTTP (JSON-RPC 2.0), версия протокола `2024-11-05` |
| Авторизация | API-ключ: `Authorization: Bearer ent_…` или `X-API-Key: ent_…` |
| Ключ | Бесплатно — зарегистрируйтесь на <https://enterno.io/register> и создайте ключ в личном кабинете |
| Реестр | `io.enterno/site-diagnostics` в [официальном MCP Registry](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno) |
| Документация | <https://enterno.io/mcp-server> |

Рукопожатие `initialize` открыто, а `tools/list` и `tools/call` требуют ключ: без него сервер отвечает
HTTP 401 `API key required`.

Claude Code:

```bash
read -rs ENTERNO_API_KEY   # вставьте ключ: он не отображается и не попадает в историю команд
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

Ключ сохраняется в пользовательских настройках Claude Code. Не добавляйте его с `--scope project`: тогда он
окажется в `.mcp.json` внутри репозитория и уйдет в коммит.

Настройки для Claude Desktop, Codex CLI, Cursor, VS Code и Zed — в
[английском README](README.md#connect-the-mcp-server) и в папке [`examples/`](examples/). Храните ключ в переменной
окружения или в хранилище секретов клиента, а не в файлах проекта.

## Тарифы и лимиты

- **Открытый API** — без ключа, от 10 до 30 запросов в минуту на инструмент с одного IP. Полная проверка одного
  сайта — около 15 запросов. Ответ текстом, в JSON или CSV: `https://enterno.io/api/open/<tool>?q=<target>`
  ([документация](https://enterno.io/api-docs)).
- **MCP-сервер** — ключ бесплатный. Вызовы инструментов расходуют дневной лимит API вашего тарифа; лимиты по
  тарифам — на <https://enterno.io/pricing>. Все инструменты
  работают и на бесплатном ключе: тариф меняет число вызовов в день, а не набор инструментов.
- Лимит частоты считается по ключу (скользящее окно); в ответах есть заголовки `X-RateLimit-*`.

## Безопасность и приватность

- Проверяются только названные вами адреса. Скилл не обходит сайт дальше них и сам не сканирует порты и поддомены.
- Запросы к частным, локальным и внутренним адресам сервер отклоняет.
- Скилл никогда не просит вставить ключ в чат и не записывает его в файлы проекта.
- Локальные файлы не читаются и никуда не отправляются; в скилле нет скриптов — только инструкции и справочники.
  Примеры настроек для каждого клиента — в папке [`examples/`](examples/).

## Вопросы и ответы

**Нужен ли аккаунт?** Для 19 открытых проверок — нет. Бесплатный аккаунт дает API-ключ для инструментов MCP.

**С какими агентами работает?** С любым агентом, который умеет делать HTTP-запросы или вызывать инструменты MCP:
Claude Code, Claude Desktop, Codex CLI, Cursor, VS Code, Zed, Gemini CLI и другими.

**Откуда идут проверки?** С серверов Enterno.io, поэтому результат не зависит от вашей сети, VPN и кэша DNS.

**На каком языке будет отчет?** На том, на котором вы спрашиваете.

**Открыт ли код MCP-сервера?** Нет. В этом репозитории скилл, документация и настройки клиентов; сервер — это
облачный сервис [enterno.io](https://enterno.io) с бесплатным тарифом.

## Поддержка

Вопросы и ошибки — [в issues](https://github.com/enterno-io/enterno-mcp/issues) или через
<https://enterno.io/contact>.

## Лицензия

Скилл, документация и примеры в этом репозитории распространяются по лицензии MIT — см. [LICENSE](LICENSE).
Сервис Enterno.io проприетарный, у него есть бесплатный тариф.
