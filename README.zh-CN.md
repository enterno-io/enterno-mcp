<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <b>简体中文</b> ·
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
  <b>为 AI 智能体打造的网站与域名诊断技能。</b><br>
  问你的智能体"我的网站为什么打不开？"或"上线前检查一下 example.com"，
  得到一份附带证据和具体修复方法的简短报告，而不是一堆原始数据。
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#安装"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="无需密钥的 19 项检查">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="免费密钥可用 40+ 个 MCP 工具">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="MIT 许可证"></a>
</p>

---

**`enterno-website-diagnostics`** 技能教会 Claude Code、Codex、Cursor 等智能体如何检查公开的网站或域名，
并把结果整理成可以直接采取行动的报告。检查在 Enterno.io 的服务器上运行，因此看到的是公网视角下的网站，
而不是你的电脑或 VPN 视角。

安装后即可使用：**19 项检查无需注册、无需密钥**。使用免费密钥连接托管的
[Enterno.io MCP 服务器](#连接-mcp-服务器)后，智能体可获得 **40 多个工具**，包括页面 SEO 审计、
AI 就绪度评估、A+ 到 F 的完整安全评级以及邮件送达率检查。

## 目录

- [安装](#安装)
- [可以这样问](#可以这样问)
- [实际效果](#实际效果)
- [检查内容](#检查内容)
- [内置流程](#内置流程)
- [连接 MCP 服务器](#连接-mcp-服务器)
- [套餐与限额](#套餐与限额)
- [安全与隐私](#安全与隐私)
- [常见问题](#常见问题)

## 安装

**支持 skills CLI 的任意智能体**（Claude Code、Codex、Cursor、Gemini CLI 等）：

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Claude Code 插件** —— 本仓库同时也是一个插件市场：

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**Codex、Gemini CLI、GitHub Copilot CLI 和 Cursor** —— 同一个仓库也是它们的插件
（Agent Plugins 标准和 Gemini CLI 扩展）：

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

**手动安装** —— 将 [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) 复制到智能体的
技能目录，例如 Claude Code 的 `~/.claude/skills/`。

19 项开放检查无需任何配置。如需完整工具集，请连接 MCP 服务器，见[连接 MCP 服务器](#连接-mcp-服务器)。

## 可以这样问

- "example.com 打不开了，帮我找出是哪一层出了问题：DNS、TLS、HTTP 还是重定向。"
- "对 shop.example.com 做一次上线前检查。"
- "我们昨天迁移了 DNS，所有解析器都已经生效了吗？"
- "这五个域名的证书什么时候过期？TLS 配置怎么样？"
- "评估我网站的安全响应头和 Cookie，并告诉我具体要加什么。"
- "为什么我们的邮件进了垃圾箱？检查 MX、SPF、DKIM 和 DMARC。"
- "我的 robots.txt 是否屏蔽了 AI 爬虫？结构化数据是否有效？"

## 实际效果

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

2026 年 11 月 11 日的真实运行记录，开放 API 模式，共 5 次请求。原始请求是英文的，所以报告也是英文；
用中文提问，报告就会是中文。

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

## 检查内容

| 领域 | 无需密钥（开放 API） | 免费密钥（MCP 服务器） |
|---|---|---|
| HTTP | 状态码、响应头、重定向链、HTTP/2 与 HTTP/3、短链接展开 | + 混合内容、最终地址解析、Wayback 历史 |
| TLS | 证书、证书链、SAN、到期时间、协议、TLS 评级 | 相同 |
| DNS 与域名 | 记录、公共解析器传播情况、MX、DKIM、WHOIS、ASN、IP 信息 | + 一次性检查 SPF/DKIM/DMARC、反向 IP、CT 日志中的子域名 |
| 安全 | 安全响应头评级（来自 `headers`）、Content-Security-Policy、CORS、Cookie 标志 | + A+ 到 F 的完整安全评级 |
| 邮件 | 带 SMTP 横幅的 MX、DKIM | + 完整审计（SPF、DMARC、BIMI、MTA-STS）、STARTTLS 测试、邮件头解析 |
| SEO 与 AI | 含 AI 爬虫策略的 robots.txt、结构化数据、Open Graph | + 页面 SEO 审计、AI 就绪度评级、技术与 CMS 识别、PageSpeed |
| 网络 | ping | + 路由追踪 |
| 你的账户 | — | 监控（列表、创建、暂停）、观测的资产与事件 |

完整工具列表见 [TOOLS.md](TOOLS.md)，开放 API 参考见
[open-api.md](skills/enterno-website-diagnostics/references/open-api.md)。

## 内置流程

技能内置分步操作手册，智能体会按正确的顺序运行正确的检查：

- **"网站为什么打不开？"** —— 依次检查 HTTP → DNS → ping → TLS，指出第一个出错的层并给出证据。
- **上线前 / 迁移后检查清单** —— DNS、记录传播、证书是否覆盖 www 与主域名、重定向、安全与缓存响应头、
  HTTP/2 与 HTTP/3、robots.txt、结构化数据。
- **安全响应头与 Cookie** —— 缺少什么、为什么重要、具体要加哪个响应头。
- **邮件送达率** —— 带 SMTP 横幅的 MX、从 DNS 读取 SPF 和 DMARC、按选择器检查 DKIM；完整审计通过 MCP 服务器完成。
- **多个域名的证书到期时间** —— 一张表，最早到期的排在最前。

每份报告结构相同：一句话结论、问题表（严重程度、问题、证据、修复方法），以及如实列出未检查的项目。

## 连接 MCP 服务器

当 MCP 服务器的工具可用时，技能会自动使用它。

| | |
|---|---|
| 地址 | `https://enterno.io/mcp` |
| 传输 | Streamable HTTP（JSON-RPC 2.0），协议版本 `2024-11-05` |
| 认证 | API 密钥：`Authorization: Bearer ent_…` 或 `X-API-Key: ent_…` |
| 密钥 | 免费 —— 在 <https://enterno.io/en/register> 注册，然后在控制台创建密钥 |
| 注册表 | [官方 MCP Registry](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno) 中的 `io.enterno/site-diagnostics` |
| 文档 | <https://enterno.io/en/mcp-server> |

`initialize` 握手是开放的，但 `tools/list` 和 `tools/call` 需要密钥；没有密钥时服务器返回
HTTP 401 `API key required`。

Claude Code：

```bash
read -rs ENTERNO_API_KEY   # 粘贴密钥：不会显示，也不会写入命令历史
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

密钥保存在 Claude Code 的用户级配置中。不要使用 `--scope project` 添加：那样会把密钥写进仓库里的
`.mcp.json` 并被提交。

Claude Desktop、Codex CLI、Cursor、VS Code 和 Zed 的配置见[英文 README](README.md#connect-the-mcp-server)
和 [`examples/`](examples/) 目录。请把密钥放在环境变量或客户端的密钥存储中，不要写进项目文件。

## 套餐与限额

- **开放 API** —— 无需密钥，每个工具每个 IP 每分钟 10 到 30 次请求。完整检查一个网站约需 15 次请求。
  支持纯文本、JSON 或 CSV：`https://enterno.io/api/open/<tool>?q=<target>`（[文档](https://enterno.io/en/api-docs)）。
- **MCP 服务器** —— 密钥免费。工具调用计入你套餐的每日 API 额度，各套餐额度见 <https://enterno.io/en/pricing>。
  所有工具都可以用免费密钥调用：套餐只影响每天的调用次数，不限制可用的工具。
- 速率限制按密钥计算（滑动窗口），响应中包含 `X-RateLimit-*` 响应头。

## 安全与隐私

- 只检查你指定的主机。技能不会越界抓取，也不会自行探测端口和子域名。
- 服务器会拒绝对私有、回环和内部地址的请求。
- 技能从不要求你把密钥粘贴到对话中，也不会把密钥写入项目文件。
- 不读取或发送任何本地文件；技能不包含脚本，只有说明和参考资料。各客户端的配置示例在 [`examples/`](examples/) 目录中。

## 常见问题

**需要注册账户吗？** 19 项开放检查不需要。免费账户可获得用于 MCP 工具的 API 密钥。

**支持哪些智能体？** 任何能发送 HTTP 请求或调用 MCP 工具的智能体：Claude Code、Claude Desktop、Codex CLI、
Cursor、VS Code、Zed、Gemini CLI 等。

**检查在哪里运行？** 在 Enterno.io 的服务器上，因此结果不受你的网络、VPN 或 DNS 缓存影响。

**报告使用什么语言？** 你用什么语言提问，报告就用什么语言。

**MCP 服务器开源吗？** 不开源。本仓库包含技能、文档和客户端配置；服务器是 [enterno.io](https://enterno.io)
提供的托管服务，有免费套餐。

## 支持

问题与缺陷反馈：[提交 issue](https://github.com/enterno-io/enterno-mcp/issues) 或通过
<https://enterno.io/en/contact> 联系我们。

## 许可证

本仓库中的技能、文档和示例采用 MIT 许可证，见 [LICENSE](LICENSE)。Enterno.io 服务为专有服务，提供免费套餐。
