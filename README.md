# LocalForge

LocalForge is a hardware-aware local coding assistant launcher. It analyzes a computer, chooses a model that fits its CPU/RAM/GPU budget, runs Ollama in Docker, and wires the result into OpenCode without requiring users to hand-author provider configuration.

The repository contains a validated profile for an Intel i7-13620H laptop with 32GB RAM and an RTX 3050 6GB GPU. The same flow can create a custom profile for another computer.

```bash
./llm init
./llm doctor
./llm start balanced
./llm status
./llm stop
```

Read [GETTING_STARTED.md](GETTING_STARTED.md) before first use. Use `./start [balanced|light|cpu-safe]` and `./stop` as aliases. After startup, OpenCode uses the generated project-local `opencode.json` and Ollama at `http://127.0.0.1:11434/v1`.

Enable Bash completion for the profile argument with `source scripts/complete.sh`.

`clean` removes project containers, `reinstall` recreates them while retaining models, and `prune` removes stopped project containers/orphans. Review `docs/troubleshooting.md` before changing host GPU drivers.

## Supported computers

| Hardware class | Profile | Model policy | Status |
| --- | --- | --- | --- |
| NVIDIA GPU with 6GB VRAM, 16GB+ RAM | `balanced` | Qwen2.5-Coder 7B | Validated on RTX 3050 6GB |
| NVIDIA GPU with 4GB+ VRAM, 8GB+ RAM | `light` | Qwen2.5-Coder 3B | Best-effort compatible |
| CPU-only, 16GB+ RAM | `cpu-safe` | Qwen2.5-Coder 3B | CPU fallback |

Other machines should run `./llm init`; the generated profile records the detected hardware, becomes the active local profile, and is intended to be contributed back as a new profile.
