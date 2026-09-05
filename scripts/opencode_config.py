#!/usr/bin/env python3
"""Merge or remove the LocalForge-owned OpenCode provider."""

import argparse
import json
import os
import re
import shutil
import sys
from pathlib import Path


PROVIDER_ID = "localforge"


def strip_json_comments(value: str) -> str:
    result = []
    index = 0
    quoted = False
    escaped = False
    while index < len(value):
        char = value[index]
        if quoted:
            result.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                quoted = False
            index += 1
            continue
        if char == '"':
            quoted = True
            result.append(char)
            index += 1
        elif value.startswith("//", index):
            newline = value.find("\n", index)
            index = len(value) if newline == -1 else newline
        elif value.startswith("/*", index):
            end = value.find("*/", index + 2)
            if end == -1:
                raise ValueError("unterminated JSONC comment")
            index = end + 2
        else:
            result.append(char)
            index += 1
    return re.sub(r",\s*([}\]])", r"\1", "".join(result))


def config_path() -> Path:
    base = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "opencode"
    json_path = base / "opencode.json"
    jsonc_path = base / "opencode.jsonc"
    if json_path.exists():
        return json_path
    if jsonc_path.exists():
        return jsonc_path
    return json_path


def load(path: Path) -> dict:
    if not path.exists():
        return {}
    parsed = json.loads(strip_json_comments(path.read_text()))
    if not isinstance(parsed, dict):
        raise ValueError("global OpenCode config must be a JSON object")
    return parsed


def backup(path: Path) -> None:
    if path.exists():
        backup_path = path.with_suffix(path.suffix + ".bak-localforge")
        if not backup_path.exists():
            shutil.copy2(path, backup_path)


def write(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(value, indent=2) + "\n")
    temporary.replace(path)


def apply(args: argparse.Namespace) -> None:
    path = config_path()
    config = load(path)
    backup(path)
    providers = config.setdefault("provider", {})
    providers[PROVIDER_ID] = {
        "npm": "@ai-sdk/openai-compatible",
        "name": "LocalForge (local)",
        "options": {"baseURL": args.base_url},
        "models": {args.model: {"name": f"{args.model} ({args.profile})"}},
    }
    config["model"] = f"{PROVIDER_ID}/{args.model}"
    write(path, config)
    print(f"OpenCode configured globally at {path} for {args.model} ({args.profile})")


def remove(_: argparse.Namespace) -> None:
    path = config_path()
    if not path.exists():
        return
    config = load(path)
    providers = config.get("provider")
    removed_models = []
    if isinstance(providers, dict):
        provider = providers.pop(PROVIDER_ID, None)
        if isinstance(provider, dict):
            models = provider.get("models", {})
            if isinstance(models, dict):
                removed_models = [f"{PROVIDER_ID}/{model}" for model in models]
        if not providers:
            config.pop("provider", None)
    if config.get("model") in removed_models:
        config.pop("model")
    write(path, config)


def main() -> None:
    parser = argparse.ArgumentParser()
    actions = parser.add_subparsers(dest="action", required=True)
    apply_parser = actions.add_parser("apply")
    apply_parser.add_argument("--model", required=True)
    apply_parser.add_argument("--profile", required=True)
    apply_parser.add_argument("--base-url", required=True)
    actions.add_parser("remove")
    args = parser.parse_args()
    try:
        {"apply": apply, "remove": remove}[args.action](args)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"error: cannot update OpenCode configuration: {error}", file=sys.stderr)
        raise SystemExit(1)


if __name__ == "__main__":
    main()
