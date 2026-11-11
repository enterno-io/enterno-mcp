#!/usr/bin/env bash
# Build the Agensi upload: dist/enterno-website-diagnostics-<version>.zip
# Layout: one top folder with SKILL.md, references/ and templates/ (configs from examples/, no shell scripts:
# the Agensi scan rejects scripts that read an environment variable and send it over the network).
# Links in the zip are tagged utm_source=agensi; the repository copy keeps utm_source=agent-skill.
# Usage: scripts/build-agensi-zip.sh   (needs bash, curl, python3; run from anywhere)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAME="enterno-website-diagnostics"
SRC="$ROOT/skills/$NAME"
VERSION="$(sed -n 's/^version: *//p' "$SRC/SKILL.md" | head -1)"
[ -n "$VERSION" ] || { echo "no version in SKILL.md frontmatter" >&2; exit 1; }

# 1. The open API table must list exactly the tools the live endpoint offers.
live="$(curl -fsS --max-time 30 https://enterno.io/api/open/ | sed -n 's/^  \([a-z][a-z0-9-]*\) .*/\1/p' | sort)"
documented="$(sed -n 's/^| `\([a-z][a-z0-9-]*\)` |.*/\1/p' "$SRC/references/open-api.md" | sort)"
if [ -z "$live" ] || [ "$live" != "$documented" ]; then
  echo "references/open-api.md is out of date with https://enterno.io/api/open/:" >&2
  diff <(echo "$documented") <(echo "$live") >&2 || true
  exit 1
fi

# 2. Stage the package.
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
PKG="$STAGE/$NAME"
mkdir -p "$PKG/references" "$PKG/templates"
cp "$SRC/SKILL.md" "$PKG/"
cp "$SRC/references/"*.md "$PKG/references/"
for f in cursor-mcp.json vscode-mcp.json claude-desktop.json zed-settings.json codex-config.toml; do
  cp "$ROOT/examples/$f" "$PKG/templates/$f"
done
cp "$ROOT/LICENSE" "$PKG/LICENSE"
# The repository header points at a generator that is not in the package.
sed -i -E '3,4c\The tool list of the Enterno.io MCP server (from its public server card).' "$PKG/references/mcp-tools.md"
find "$PKG" -type f \( -name '*.md' -o -name '*.json' -o -name '*.toml' -o -name '.env.example' \) \
  -exec sed -i 's/utm_source=agent-skill/utm_source=agensi/g' {} +

# 3. Guards: no keys, no executables, no scripts.
if grep -rIEn 'ent_[0-9a-f]{16,}' "$PKG"; then echo "possible API key in the package" >&2; exit 1; fi
if find "$PKG" -type f \( -name '*.sh' -o -perm -u+x \) | grep -q .; then
  echo "scripts or executable files in the package" >&2; exit 1
fi
grep -q '^name: ' "$PKG/SKILL.md" && grep -q '^description: ' "$PKG/SKILL.md" \
  || { echo "SKILL.md frontmatter needs name and description" >&2; exit 1; }

# 4. Zip with stable timestamps.
mkdir -p "$ROOT/dist"
OUT="$ROOT/dist/$NAME-$VERSION.zip"
rm -f "$OUT"
python3 -I - "$STAGE" "$NAME" "$OUT" <<'PY'
import os, sys, zipfile
stage, name, out = sys.argv[1:4]
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for dirpath, dirs, files in os.walk(os.path.join(stage, name)):
        dirs.sort()
        for f in sorted(files):
            path = os.path.join(dirpath, f)
            info = zipfile.ZipInfo(os.path.relpath(path, stage), date_time=(2026, 1, 1, 0, 0, 0))
            info.external_attr = 0o644 << 16
            info.compress_type = zipfile.ZIP_DEFLATED
            with open(path, "rb") as fh:
                z.writestr(info, fh.read())
PY
echo "$OUT"
python3 -I -m zipfile -l "$OUT"
