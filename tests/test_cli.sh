#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

profiles=$($ROOT/llm profiles)
grep -qx 'balanced' <<<"$profiles"
grep -qx 'light' <<<"$profiles"
grep -qx 'cpu-safe' <<<"$profiles"

completion=$($ROOT/llm complete)
grep -q 'balanced' <<<"$completion"

doctor=$($ROOT/llm doctor)
grep -q 'Hardware profile:' <<<"$doctor"

for command in install init start configure open stop status logs doctor profiles complete clean reinstall uninstall prune; do
  help=$($ROOT/llm "$command" --help)
  grep -q "Usage: localforge $command" <<<"$help"
done
grep -qx 'balanced' <<<"$($ROOT/llm complete profiles)"

echo 'cli tests: ok'
