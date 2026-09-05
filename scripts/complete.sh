#!/usr/bin/env bash
_llm_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local opts
  opts=$("${COMP_WORDS[0]}" complete 2>/dev/null || true)
  COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}
complete -F _llm_complete ./llm
