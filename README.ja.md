<h1 align="center">Enterno.io Website Diagnostics</h1>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <b>日本語</b> ·
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
  <b>AI エージェントのための Web サイト・ドメイン診断スキル。</b><br>
  「サイトが落ちているのはなぜ？」「公開前に example.com をチェックして」とエージェントに聞くだけで、
  生データの山ではなく、根拠と具体的な修正方法をまとめた短いレポートが返ってきます。
</p>

<p align="center">
  <a href="https://www.skills.sh/enterno-io/enterno-mcp/enterno-website-diagnostics"><img src="https://img.shields.io/badge/skills.sh-enterno--website--diagnostics-111111?style=flat-square" alt="skills.sh"></a>
  <a href="#インストール"><img src="https://img.shields.io/badge/Claude_Code-plugin-d97757?style=flat-square" alt="Claude Code plugin"></a>
  <a href="https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno"><img src="https://img.shields.io/badge/MCP_Registry-io.enterno%2Fsite--diagnostics-5b8af8?style=flat-square" alt="MCP Registry"></a>
  <img src="https://img.shields.io/badge/no_key-19_checks-34d399?style=flat-square" alt="キー不要の 19 種類のチェック">
  <img src="https://img.shields.io/badge/free_key-40%2B_MCP_tools-7c60f5?style=flat-square" alt="無料キーで 40 以上の MCP ツール">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="MIT ライセンス"></a>
</p>

---

**`enterno-website-diagnostics`** スキルは、Claude Code、Codex、Cursor などのエージェントに、公開されている
Web サイトやドメインのチェック方法と、その結果を行動に移せるレポートにまとめる方法を教えます。チェックは
Enterno.io のサーバーで実行されるため、あなたの PC や VPN からではなく、インターネットから見たサイトの状態がわかります。

インストールしてすぐに使えます。**19 種類のチェックはアカウントもキーも不要**です。無料キーでホスト型の
[Enterno.io MCP サーバー](#mcp-サーバーの接続)に接続すると、ページ単位の SEO 監査、AI 対応度、A+〜F の
総合セキュリティ評価、メール到達性チェックなど **40 以上のツール**が使えるようになります。

## 目次

- [インストール](#インストール)
- [質問の例](#質問の例)
- [実行例](#実行例)
- [チェック内容](#チェック内容)
- [組み込みのレシピ](#組み込みのレシピ)
- [MCP サーバーの接続](#mcp-サーバーの接続)
- [プランと制限](#プランと制限)
- [セキュリティとプライバシー](#セキュリティとプライバシー)
- [よくある質問](#よくある質問)

## インストール

**skills CLI に対応したエージェント**（Claude Code、Codex、Cursor、Gemini CLI など）：

```bash
npx skills add enterno-io/enterno-mcp --skill enterno-website-diagnostics
```

**Claude Code プラグイン** —— このリポジトリはプラグインマーケットプレイスとしても使えます：

```text
/plugin marketplace add enterno-io/enterno-mcp
/plugin install enterno-website-diagnostics@enterno-io
```

**手動** —— [`skills/enterno-website-diagnostics`](skills/enterno-website-diagnostics/) をエージェントの
スキルフォルダにコピーします（Claude Code の場合は `~/.claude/skills/`）。

19 種類のオープンチェックには設定は不要です。すべてのツールを使うには
[MCP サーバーを接続](#mcp-サーバーの接続)してください。

## 質問の例

- 「example.com が開かない。DNS、TLS、HTTP、リダイレクトのどこで止まっているか調べて」
- 「shop.example.com の公開前チェックリストを実行して」
- 「昨日 DNS を移行した。すべてのリゾルバに反映された？」
- 「この 5 つのドメインの証明書はいつ切れる？TLS の設定は十分？」
- 「サイトのセキュリティヘッダーと Cookie を評価して、何を追加すべきか具体的に教えて」
- 「メールが迷惑メールに入るのはなぜ？MX、SPF、DKIM、DMARC を確認して」
- 「robots.txt が AI クローラーをブロックしていない？構造化データは正しい？」

## 実行例

> Check when the certificates of github.com, wikipedia.org and example.com expire and how good their TLS setup is.
> Then grade github.com's security headers and cookies.

2026 年 11 月 11 日の実際の実行結果です（オープン API モード、リクエスト 5 回）。質問が英語だったため
レポートも英語です。日本語で質問すれば、レポートも日本語になります。

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

## チェック内容

| 分野 | キー不要（オープン API） | 無料キー（MCP サーバー） |
|---|---|---|
| HTTP | ステータス、レスポンスヘッダー、リダイレクトチェーン、HTTP/2・HTTP/3、短縮 URL の展開 | + 混在コンテンツ、最終 URL の解決、Wayback 履歴 |
| TLS | 証明書、チェーン、SAN、有効期限、プロトコル、TLS 評価 | 同じ |
| DNS とドメイン | レコード、公開リゾルバへの浸透、MX、DKIM、WHOIS、ASN、IP 情報 | + SPF/DKIM/DMARC の一括チェック、逆引き IP、CT ログからのサブドメイン |
| セキュリティ | セキュリティヘッダー評価（`headers` から）、Content-Security-Policy、CORS、Cookie フラグ | + A+〜F の総合セキュリティ評価 |
| メール | SMTP バナー付きの MX、DKIM | + 総合監査（SPF、DMARC、BIMI、MTA-STS）、STARTTLS テスト、メールヘッダー解析 |
| SEO と AI | AI クローラー向けルールを含む robots.txt、構造化データ、Open Graph | + ページ SEO 監査、AI 対応度評価、技術・CMS の検出、PageSpeed |
| ネットワーク | ping | + traceroute |
| アカウント | — | 監視（一覧、作成、一時停止）、監視中のアセットとイベント |

ツール一覧は [TOOLS.md](TOOLS.md)、オープン API のリファレンスは
[open-api.md](skills/enterno-website-diagnostics/references/open-api.md) を参照してください。

## 組み込みのレシピ

スキルには手順書が含まれているため、エージェントは正しいチェックを正しい順序で実行します。

- **「サイトが落ちている？」** —— HTTP → DNS → ping → TLS の順に調べ、最初に失敗した層と根拠を示します。
- **公開前・移行後のチェックリスト** —— DNS、レコードの浸透、www と apex の証明書カバー、リダイレクト、
  セキュリティ・キャッシュヘッダー、HTTP/2・HTTP/3、robots.txt、構造化データ。
- **セキュリティヘッダーと Cookie** —— 何が足りないか、なぜ重要か、追加すべき正確なヘッダー。
- **メール到達性** —— SMTP バナー付きの MX、DNS からの SPF と DMARC、セレクター指定の DKIM。総合監査は
  MCP サーバーで行います。
- **複数ドメインの証明書期限** —— 期限の近い順に 1 つの表で。

レポートは常に同じ構成です：1 行の結論、指摘事項の表（重要度、内容、根拠、修正方法）、そしてチェック
できなかった項目の正直な一覧。

## MCP サーバーの接続

MCP サーバーのツールが使える場合、スキルは自動的にそれを利用します。

| | |
|---|---|
| エンドポイント | `https://enterno.io/mcp` |
| トランスポート | Streamable HTTP（JSON-RPC 2.0）、プロトコルバージョン `2024-11-05` |
| 認証 | API キー：`Authorization: Bearer ent_…` または `X-API-Key: ent_…` |
| キー | 無料 —— <https://enterno.io/en/register> で登録し、ダッシュボードでキーを作成 |
| レジストリ | [公式 MCP Registry](https://registry.modelcontextprotocol.io/v0/servers?search=io.enterno) の `io.enterno/site-diagnostics` |
| ドキュメント | <https://enterno.io/en/mcp-server> |

`initialize` ハンドシェイクは公開されていますが、`tools/list` と `tools/call` にはキーが必要です。キーがないと
サーバーは HTTP 401 `API key required` を返します。

Claude Code：

```bash
read -rs ENTERNO_API_KEY   # キーを貼り付けます（表示されず、履歴にも残りません）
claude mcp add --transport http enterno https://enterno.io/mcp \
  --header "Authorization: Bearer $ENTERNO_API_KEY"
```

キーは Claude Code のユーザー設定に保存されます。`--scope project` では追加しないでください。リポジトリ内の
`.mcp.json` に書き込まれ、コミットされてしまいます。

Claude Desktop、Codex CLI、Cursor、VS Code、Zed の設定は[英語版 README](README.md#connect-the-mcp-server) と
[`examples/`](examples/) フォルダにあります。キーはプロジェクトのファイルではなく、環境変数やクライアントの
シークレットストアに保存してください。

## プランと制限

- **オープン API** —— キー不要。ツールごと・IP ごとに毎分 10〜30 リクエスト。1 サイトの総合チェックは約
  15 リクエストです。プレーンテキスト、JSON、CSV に対応：`https://enterno.io/api/open/<tool>?q=<target>`
  （[ドキュメント](https://enterno.io/en/api-docs)）。
- **MCP サーバー** —— キーは無料。ツール呼び出しはプランの 1 日あたりの API 枠を消費します。プランごとの枠は
  <https://enterno.io/en/pricing> を参照してください。すべてのツールは
  無料キーで使えます。プランで変わるのは 1 日の呼び出し回数で、使えるツールは変わりません。
- レート制限はキー単位（スライディングウィンドウ）で、レスポンスに `X-RateLimit-*` ヘッダーが付きます。

## セキュリティとプライバシー

- チェックするのは指定したホストだけです。それ以上のクロールや、ポート・サブドメインの探索は行いません。
- プライベート、ループバック、内部アドレスへのリクエストはサーバーが拒否します。
- スキルがチャットにキーを貼るよう求めることはなく、プロジェクトのファイルにキーを書き込むこともありません。
- ローカルファイルを読み取ったり送信したりしません。スクリプトは含まれず、説明とリファレンスのみです。
  クライアントごとの設定例は [`examples/`](examples/) にあります。

## よくある質問

**アカウントは必要？** 19 種類のオープンチェックには不要です。無料アカウントで MCP ツール用の API キーが
手に入ります。

**どのエージェントで動く？** HTTP リクエストを送れるか MCP ツールを使えるエージェントなら動きます：
Claude Code、Claude Desktop、Codex CLI、Cursor、VS Code、Zed、Gemini CLI など。

**チェックはどこで実行される？** Enterno.io のサーバー上です。結果はあなたのネットワーク、VPN、DNS キャッシュに
左右されません。

**レポートの言語は？** 質問した言語でレポートが作られます。

**MCP サーバーはオープンソース？** いいえ。このリポジトリにはスキル、ドキュメント、クライアント設定が含まれます。
サーバーは [enterno.io](https://enterno.io) が運営するホスト型サービスで、無料プランがあります。

## サポート

質問やバグ報告は [issue](https://github.com/enterno-io/enterno-mcp/issues) または
<https://enterno.io/en/contact> からお送りください。

## ライセンス

このリポジトリのスキル、ドキュメント、サンプルは MIT ライセンスです（[LICENSE](LICENSE) を参照）。
Enterno.io のサービスはプロプライエタリで、無料プランがあります。
