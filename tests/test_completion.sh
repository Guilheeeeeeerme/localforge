#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
source "$ROOT/scripts/complete.sh"

COMP_WORDS=("$ROOT/llm" start '')
COMP_CWORD=2
_localforge_complete
printf '%s\n' "${COMPREPLY[@]}" | grep -qx 'balanced'
printf '%s\n' "${COMPREPLY[@]}" | grep -qx 'cpu-safe'

COMP_WORDS=("$ROOT/llm" '')
COMP_CWORD=1
_localforge_complete
printf '%s\n' "${COMPREPLY[@]}" | grep -qx 'start'
printf '%s\n' "${COMPREPLY[@]}" | grep -qx 'uninstall'

echo 'completion tests: ok'
