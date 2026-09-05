#!/usr/bin/env bash
_localforge_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local subcommand=${COMP_WORDS[1]:-commands}
  local target=commands
  case "$subcommand" in
    start|configure|reinstall) target=profiles;;
    uninstall) target=uninstall;;
    ''|commands) target=commands;;
  esac
  local opts
  opts=$("${COMP_WORDS[0]}" complete "$target" 2>/dev/null || true)
  COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}
complete -F _localforge_complete localforge ./llm
