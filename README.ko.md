<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <b>한국어</b> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt-BR.md">Português</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a>
</p>

<p align="center">
  <img src="agensi/logo-512.png" alt="Enterno.io" width="96" height="96">
</p>

<p align="center">
  <b>AI 에이전트를 위한 웹사이트·도메인 진단 스킬.</b><br>
  에이전트에게 "사이트가 왜 안 열리지?" 또는 "출시 전에 example.com 점검해 줘"라고 물어보세요.
  원시 데이터 더미가 아니라 근거와 구체적인 해결 방법이 담긴 짧은 보고서를 받게 됩니다.
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#설치"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="키 없이 19가지 점검">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="무료 키로 40개 이상의 MCP 도구">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="MIT 라이선스"></a>
</p>

---

**`enterno-website-diagnostics`** 스킬은 Claude Code, Codex, Cursor 등의 에이전트에게 공개 웹사이트나 도메인을
점검하는 방법과, 그 결과를 바로 조치할 수 있는 보고서로 정리하는 방법을 알려 줍니다. 점검은 Enterno.io 서버에서
실행되므로 내 노트북이나 VPN이 아니라 인터넷에서 보이는 그대로의 사이트를 확인합니다.

설치하자마자 동작합니다. **19가지 점검은 계정도 키도 필요 없습니다**. 무료 키로 호스팅형
[Enterno.io MCP 서버](#mcp-서버-연결)에 연결하면 페이지 SEO 감사, AI 준비도, A+부터 F까지의 종합 보안 등급,
이메일 전달성 점검 등 **40개 이상의 도구**를 쓸 수 있습니다.

## 목차

- [설치](#설치)
- [이렇게 물어보세요](#이렇게-물어보세요)
- [실행 예시](#실행-예시)
- [점검 항목](#점검-항목)
- [내장 레시피](#내장-레시피)
- [MCP 서버 연결](#mcp-서버-연결)
- [요금제와 한도](#요금제와-한도)
- [보안과 개인정보](#보안과-개인정보)
- [자주 묻는 질문](#자주-묻는-질문)

## 설치

**skills CLI를 지원하는 모든 에이전트** (Claude Code, Codex, Cursor, Gemini CLI 등):

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Claude Code 플러그인** — 이 저장소는 플러그인 마켓플레이스이기도 합니다:

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**Codex, Gemini CLI, GitHub Copilot CLI, Cursor** — 같은 저장소가 이 도구들의 플러그인이기도 합니다
(Agent Plugins 표준과 Gemini CLI 확장):

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

**수동 설치** — [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) 폴더를 에이전트의
스킬 폴더(예: Claude Code는 `~/.claude/skills/`)에 복사합니다.

19가지 공개 점검은 별도 설정이 필요 없습니다. 전체 도구를 쓰려면 [MCP 서버를 연결](#mcp-서버-연결)하세요.

## 이렇게 물어보세요

- "example.com이 안 열려. DNS, TLS, HTTP, 리디렉션 중 어디가 문제인지 찾아 줘."
- "shop.example.com 출시 전 체크리스트를 돌려 줘."
- "어제 DNS를 옮겼어. 모든 리졸버에 반영됐어?"
- "이 다섯 도메인의 인증서는 언제 만료되고, TLS 설정은 괜찮아?"
- "내 사이트의 보안 헤더와 쿠키를 평가하고 정확히 무엇을 추가해야 하는지 알려 줘."
- "우리 메일이 왜 스팸함으로 가지? MX, SPF, DKIM, DMARC를 확인해 줘."
- "robots.txt가 AI 크롤러를 막고 있나? 구조화된 데이터는 올바른가?"

## 실행 예시

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

2026년 11월 11일 실제 실행 결과입니다 (공개 API 모드, 요청 5회). 질문이 영어였기 때문에 보고서도 영어입니다.
한국어로 물어보면 보고서도 한국어로 나옵니다.

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

## 점검 항목

| 분야 | 키 없이 (공개 API) | 무료 키 (MCP 서버) |
|---|---|---|
| HTTP | 상태 코드, 응답 헤더, 리디렉션 체인, HTTP/2·HTTP/3, 단축 URL 풀기 | + 혼합 콘텐츠, 최종 URL 확인, Wayback 기록 |
| TLS | 인증서, 체인, SAN, 만료일, 프로토콜, TLS 등급 | 동일 |
| DNS와 도메인 | 레코드, 공개 리졸버 전파 상태, MX, DKIM, WHOIS, ASN, IP 정보 | + SPF/DKIM/DMARC 일괄 점검, 역방향 IP, CT 로그 기반 서브도메인 |
| 보안 | 보안 헤더 등급(`headers` 기준), Content-Security-Policy, CORS, 쿠키 플래그 | + A+~F 종합 보안 등급 |
| 이메일 | SMTP 배너를 포함한 MX, DKIM | + 종합 감사(SPF, DMARC, BIMI, MTA-STS), STARTTLS 테스트, 메일 헤더 분석 |
| SEO와 AI | AI 크롤러 정책을 포함한 robots.txt, 구조화된 데이터, Open Graph | + 페이지 SEO 감사, AI 준비도 등급, 기술·CMS 탐지, PageSpeed |
| 네트워크 | ping | + traceroute |
| 내 계정 | — | 모니터(목록, 생성, 일시 중지), 관찰 중인 자산과 이벤트 |

전체 도구 목록은 [TOOLS.md](TOOLS.md), 공개 API 참고 자료는
[open-api.md](skills/enterno-website-diagnostics/references/open-api.md)를 보세요.

## 내장 레시피

스킬에는 단계별 플레이북이 들어 있어 에이전트가 올바른 점검을 올바른 순서로 실행합니다.

- **"사이트가 다운됐나?"** — HTTP → DNS → ping → TLS 순으로 확인하고, 처음 실패한 계층과 근거를 알려 줍니다.
- **출시 전 / 이전 후 체크리스트** — DNS, 레코드 전파, www와 apex의 인증서 적용 범위, 리디렉션, 보안·캐시 헤더,
  HTTP/2·HTTP/3, robots.txt, 구조화된 데이터.
- **보안 헤더와 쿠키** — 무엇이 빠졌는지, 왜 중요한지, 정확히 어떤 헤더를 추가해야 하는지.
- **이메일 전달성** — SMTP 배너를 포함한 MX, DNS의 SPF와 DMARC, 셀렉터별 DKIM. 종합 감사는 MCP 서버로 합니다.
- **여러 도메인의 인증서 만료** — 만료가 가까운 순서로 하나의 표에.

모든 보고서는 같은 형식입니다: 한 줄 결론, 발견 사항 표(심각도, 내용, 근거, 해결 방법), 그리고 점검하지 못한
항목의 솔직한 목록.

## MCP 서버 연결

MCP 서버의 도구를 쓸 수 있으면 스킬이 자동으로 사용합니다.

| | |
|---|---|
| 엔드포인트 | `https://enterno.io/mcp` |
| 전송 방식 | Streamable HTTP (JSON-RPC 2.0), 프로토콜 버전 `2024-11-05` |
| 인증 | API 키: `Authorization: Bearer ent_…` 또는 `X-API-Key: ent_…` |
| 키 | 무료 — <https://enterno.io/en/register>에서 가입한 뒤 대시보드에서 키를 생성 |
| 레지스트리 | [공식 MCP Registry](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno)의 `io.enterno/site-diagnostics` |
| 문서 | <https://enterno.io/en/mcp-server> |

`initialize` 핸드셰이크는 열려 있지만 `tools/list`와 `tools/call`에는 키가 필요합니다. 키가 없으면 서버가
HTTP 401 `API key required`로 응답합니다.

Claude Code:

```bash
read -rs ENTERNO_API_KEY   # 키를 붙여 넣으세요. 화면에 표시되지 않고 명령 기록에도 남지 않습니다
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

키는 Claude Code의 사용자 설정에 저장됩니다. `--scope project`로 추가하지 마세요. 저장소 안의 `.mcp.json`에
기록되어 커밋됩니다.

Claude Desktop, Codex CLI, Cursor, VS Code, Zed 설정은 [영어 README](README.md#connect-the-mcp-server)와
[`examples/`](examples/) 폴더에 있습니다. 키는 프로젝트 파일이 아니라 환경 변수나 클라이언트의 비밀 저장소에
보관하세요.

## 요금제와 한도

- **공개 API** — 키 없이, 도구별·IP별로 분당 10~30회 요청. 사이트 하나를 종합 점검하는 데 약 15회가 듭니다.
  일반 텍스트, JSON, CSV 지원: `https://enterno.io/api/open/<tool>?q=<target>`
  ([문서](https://enterno.io/en/api-docs)).
- **MCP 서버** — 키는 무료입니다. 도구 호출은 요금제의 일일 API 한도에서 차감되며, 요금제별 한도는
  <https://enterno.io/en/pricing>에 있습니다. 모든 도구는
  무료 키로 사용할 수 있으며, 요금제에 따라 달라지는 것은 하루 호출 횟수뿐입니다.
- 속도 제한은 키 단위(슬라이딩 윈도우)이며 응답에 `X-RateLimit-*` 헤더가 포함됩니다.

## 보안과 개인정보

- 지정한 호스트만 점검합니다. 그 밖으로 크롤링하거나 포트·서브도메인을 임의로 탐색하지 않습니다.
- 사설, 루프백, 내부 주소에 대한 요청은 서버가 거부합니다.
- 스킬은 채팅에 키를 붙여 넣으라고 요구하지 않으며, 프로젝트 파일에 키를 기록하지 않습니다.
- 로컬 파일을 읽거나 전송하지 않습니다. 스킬에는 스크립트가 없고 설명과 참고 자료만 있습니다.
  클라이언트별 설정 예시는 [`examples/`](examples/) 폴더에 있습니다.

## 자주 묻는 질문

**계정이 필요한가요?** 19가지 공개 점검에는 필요 없습니다. 무료 계정을 만들면 MCP 도구용 API 키를 받을 수 있습니다.

**어떤 에이전트에서 동작하나요?** HTTP 요청을 보내거나 MCP 도구를 쓸 수 있는 모든 에이전트: Claude Code,
Claude Desktop, Codex CLI, Cursor, VS Code, Zed, Gemini CLI 등.

**점검은 어디에서 실행되나요?** Enterno.io 서버에서 실행되므로 결과가 내 네트워크, VPN, DNS 캐시에 좌우되지 않습니다.

**보고서는 어떤 언어로 나오나요?** 질문한 언어로 나옵니다.

**MCP 서버는 오픈 소스인가요?** 아닙니다. 이 저장소에는 스킬, 문서, 클라이언트 설정이 있으며, 서버는
[enterno.io](https://enterno.io)가 운영하는 호스팅 서비스로 무료 요금제가 있습니다.

## 지원

질문과 버그 신고: [issue 등록](https://github.com/enterno-io/enterno-mcp/issues) 또는
<https://enterno.io/en/contact>.

## 라이선스

이 저장소의 스킬, 문서, 예제는 MIT 라이선스입니다([LICENSE](LICENSE) 참고). Enterno.io 서비스는 독점
서비스이며 무료 요금제가 있습니다.
