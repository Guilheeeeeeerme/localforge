#!/usr/bin/env bash
set -euo pipefail

REPOSITORY=Guilheeeeeeerme/localforge
SOURCE_ROOT=
RELEASE_REF=${LOCALFORGE_REF:-main}

die() { echo "error: $*" >&2; exit 1; }

while [ "$#" -gt 0 ]; do
  case "$1" in
    --source) SOURCE_ROOT=${2:?missing source path}; shift 2 ;;
    --ref) RELEASE_REF=${2:?missing Git ref}; shift 2 ;;
    *) die "unknown installer option: $1" ;;
  esac
done

temporary=$(mktemp -d)
cleanup() { rm -rf "$temporary"; }
trap cleanup EXIT

if [ -z "$SOURCE_ROOT" ]; then
  tag=${LOCALFORGE_RELEASE_TAG:-}
  archive=${LOCALFORGE_RELEASE_ARCHIVE:-}
  if [ -n "$tag" ] && [ -n "$archive" ]; then
    curl -fsSL "$archive" -o "$temporary/localforge.tar.gz"
    if [ -n "${LOCALFORGE_RELEASE_SHA256:-}" ]; then
      printf '%s  %s\n' "$LOCALFORGE_RELEASE_SHA256" "$temporary/localforge.tar.gz" | sha256sum -c - >/dev/null
    fi
    tar -xzf "$temporary/localforge.tar.gz" -C "$temporary"
    SOURCE_ROOT=$(find "$temporary" -mindepth 1 -maxdepth 1 -type d -name 'localforge-*' -print -quit)
  else
    command -v git >/dev/null || die 'Git is required to install the development branch'
    git clone --depth 1 --branch "$RELEASE_REF" "https://github.com/$REPOSITORY.git" "$temporary/localforge"
    SOURCE_ROOT="$temporary/localforge"
  fi
fi

[ -f "$SOURCE_ROOT/llm" ] || die "LocalForge source is missing llm"
[ -f "$SOURCE_ROOT/compose.yaml" ] || die "LocalForge source is missing compose.yaml"

target="$HOME/.localforge"
staging="$HOME/.localforge.new.$$"
backup="$HOME/.localforge.backup.$$"
mkdir -p "$HOME/.local" "$HOME/.local/bin"
rm -rf "$staging"
mkdir -p "$staging"

if [ -d "$target" ]; then
  cp -a "$target/." "$staging/"
fi
tar -C "$SOURCE_ROOT" --exclude=.git --exclude=.serena --exclude=data --exclude=logs --exclude=.hardware-profile -cf - . | tar -C "$staging" -xf -
if [ -f "$SOURCE_ROOT/.hardware-profile" ] && [ ! -f "$staging/.hardware-profile" ]; then
  source_profile=$(cat "$SOURCE_ROOT/.hardware-profile")
  if [ -f "$SOURCE_ROOT/$source_profile/model.yaml" ]; then
    cp "$SOURCE_ROOT/.hardware-profile" "$staging/.hardware-profile"
  fi
fi

if [ -d "$target" ]; then
  mv "$target" "$backup"
  if ! mv "$staging" "$target"; then
    mv "$backup" "$target"
    die "could not replace the existing LocalForge installation"
  fi
  rm -rf "$backup"
else
  mv "$staging" "$target"
fi
chmod +x "$target/llm" "$target/start" "$target/stop" "$target/scripts/install.sh" "$target/scripts/opencode_config.py"

cat > "$HOME/.local/bin/localforge" <<'EOF'
#!/usr/bin/env bash
exec "$HOME/.localforge/llm" "$@"
EOF
chmod +x "$HOME/.local/bin/localforge"

bashrc="$HOME/.bashrc"
touch "$bashrc"
sed -i '/^# >>> localforge >>>$/,/^# <<< localforge <<</d' "$bashrc"
cat >> "$bashrc" <<'EOF'
# >>> localforge >>>
export PATH="$HOME/.local/bin:$PATH"
alias localforge="$HOME/.local/bin/localforge"
source "$HOME/.localforge/scripts/complete.sh"
# <<< localforge <<<
EOF

echo "LocalForge installed at $target"
echo "Run: source ~/.bashrc && localforge start"
