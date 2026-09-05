# LocalForge

LocalForge is a hardware-aware local coding assistant launcher. It analyzes a computer, chooses a model that fits its CPU/RAM/GPU budget, runs Ollama in Docker, and wires the result into OpenCode without requiring users to hand-author provider configuration.

The repository contains a validated profile for an Intel i7-13620H laptop with 32GB RAM and an RTX 3050 6GB GPU. The same flow can create a custom profile for another computer.

## Install

For normal use, copy and paste this single command. It clones the current GitHub branch, installs LocalForge, updates Bash, and activates the command in your current terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/Guilheeeeeeerme/localforge/main/scripts/install.sh | bash && source ~/.bashrc
localforge start balanced
```

The installer places LocalForge and its runtime in `~/.localforge`, adds the `localforge` Bash alias and `~/.local/bin` launcher, and configures OpenCode globally after the first successful `start`. You can then run `opencode` from any project; LocalForge's selected model is the default unless that project overrides it. Tagged release installers remain available from GitHub Releases once releases are published.

Bash completion is installed automatically: type `localforge <Tab>` for commands and `localforge start <Tab>` (or `configure`/`reinstall`) for `balanced`, `light`, and `cpu-safe` profiles.

To remove LocalForge while retaining downloaded models, run `localforge uninstall`. Use `localforge uninstall --purge` to remove model data too.

## Contributing

Contributors should clone the repository and can install the checked-out source locally with `./llm install`.

```bash
./llm init
./llm doctor
./llm start balanced
./llm open
./llm status
./llm stop
```

Read [GETTING_STARTED.md](GETTING_STARTED.md) before first use. Use `./start [balanced|light|cpu-safe]` and `./stop` as aliases. `./llm start` now validates OpenCode, starts Ollama, pulls the model, and configures the project-local `opencode.json`; `./llm open` launches OpenCode with that configuration.

Enable Bash completion for the profile argument with `source scripts/complete.sh`.

`clean` removes project containers. `reinstall [profile]` recreates them, pulls the selected model if needed, and regenerates the OpenCode configuration while retaining cached models. `reinstall --force [profile]` deletes the model cache first, then performs a complete model/runtime/OpenCode rebuild. `uninstall` removes containers, the LocalForge launcher/Bash block, and LocalForge-owned OpenCode settings while preserving model data; `uninstall --purge` also deletes downloaded models after confirmation (`uninstall --purge --force` skips the prompt). `prune` removes stopped project containers/orphans. Review `docs/troubleshooting.md` before changing host GPU drivers.

## Supported computers

| Hardware class | Profile | Model policy | Status |
| --- | --- | --- | --- |
| NVIDIA GPU with 6GB VRAM, 16GB+ RAM | `balanced` | Qwen2.5-Coder 7B | Validated on RTX 3050 6GB |
| NVIDIA GPU with 4GB+ VRAM, 8GB+ RAM | `light` | Qwen2.5-Coder 3B | Best-effort compatible |
| CPU-only, 16GB+ RAM | `cpu-safe` | Qwen2.5-Coder 3B | CPU fallback |

Other machines should run `./llm init`; the generated profile records the detected hardware, becomes the active local profile, and is intended to be contributed back as a new profile.

## Requirements

- Linux, Bash, Git, curl, and Docker Engine with the Compose plugin.
- OpenCode installed locally. The official installer is `curl -fsSL https://opencode.ai/install | bash`; npm users can use `npm install -g opencode-ai`.
- NVIDIA proprietary drivers and NVIDIA Container Toolkit are optional. Without them, LocalForge uses CPU mode.
- At least 8GB free disk for the light profile; reserve 12GB or more for the balanced profile and Docker layers.

Run `./llm doctor` before starting. It reports missing tools, daemon/socket permissions, GPU availability, and the local endpoint. LocalForge does not silently install kernel drivers or change system-wide Docker permissions.

## After `./llm start`

From any project, run `opencode`. LocalForge registers its selected model in OpenCode's global configuration; a project-level `opencode.json` can override it. In the TUI:

1. Run `/models` and select the `ollama` model shown by LocalForge.
2. Run `/init` once so OpenCode creates or updates that project’s `AGENTS.md`; review and commit it.
3. Use `Tab` to enter Plan mode for non-trivial work, review the plan, then switch back to Build mode.
4. Ask focused questions with file references (the `@` picker), run tests after changes, and inspect the diff before committing.
5. Use `/undo` or `/redo` when iterating; do not grant broad tool permissions without reviewing the command.

When finished, leave the model available for quick reuse or run `./llm stop`. The service is local-only at `http://127.0.0.1:11434`; do not expose that port publicly.
