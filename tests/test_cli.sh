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

echo 'cli tests: ok'
