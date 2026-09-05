#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

export HOME="$TMP/home"
export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$HOME/.config/opencode"
printf '%s\n' '{"autoupdate":false,"provider":{"other":{"name":"Other"}}}' > "$HOME/.config/opencode/opencode.json"

"$ROOT/llm" install

test -x "$HOME/.localforge/llm"
test -x "$HOME/.local/bin/localforge"
grep -Fqx '# >>> localforge >>>' "$HOME/.bashrc"
grep -Fq 'source "$HOME/.localforge/scripts/complete.sh"' "$HOME/.bashrc"
grep -Fq '"other"' "$HOME/.config/opencode/opencode.json"
bash "$ROOT/scripts/install.sh" --source "$ROOT"
test -z "$(find "$HOME/.localforge" -maxdepth 1 -name '.localforge.new.*' -print -quit)"

mkdir "$TMP/bin"
cat > "$TMP/bin/docker" <<'EOF'
#!/usr/bin/env bash
if [ "$1" = info ]; then exit 0; fi
exit 0
EOF
cat > "$TMP/bin/curl" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' '{}'
EOF
cat > "$TMP/bin/opencode" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' 'opencode test'
EOF
chmod +x "$TMP/bin/docker" "$TMP/bin/curl" "$TMP/bin/opencode"
PATH="$TMP/bin:$PATH" bash --noprofile --norc -c "shopt -s expand_aliases; source '$HOME/.bashrc'; eval 'localforge start light'"
grep -Fq '"localforge"' "$HOME/.config/opencode/opencode.json"
grep -Fq '"model": "localforge/qwen2.5-coder:3b"' "$HOME/.config/opencode/opencode.json"
python3 "$ROOT/scripts/opencode_config.py" apply --model test-reasoning --profile test --base-url http://127.0.0.1:11434/v1 --reasoning-variants low,high >/dev/null
python3 -c "import json; d=json.load(open('$HOME/.config/opencode/opencode.json')); assert set(d['provider']['localforge']['models']['test-reasoning']['variants']) == {'low', 'high'}"

"$HOME/.local/bin/localforge" uninstall --force
test ! -e "$HOME/.local/bin/localforge"
test ! -e "$HOME/.localforge/llm"
test -d "$HOME/.localforge/data/ollama"
! grep -Fq '# >>> localforge >>>' "$HOME/.bashrc"
! grep -Fq '"localforge"' "$HOME/.config/opencode/opencode.json"

echo 'install tests: ok'
