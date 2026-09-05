# Local LLM OpenCode Runner Implementation Plan

> **For agentic workers:** Execute task-by-task with targeted verification.

**Goal:** Build a hardware-profiled Docker/Ollama runner with a simple `./llm` CLI and OpenCode integration.

**Architecture:** A POSIX shell launcher detects hardware, selects a profile, chooses GPU or CPU Compose mode, starts Ollama, pulls a pinned coding model, and renders a project-local OpenCode provider config. Model data is persisted under `data/ollama`.

**Tech Stack:** POSIX shell, Docker Compose, Ollama, OpenCode OpenAI-compatible provider, YAML/JSON metadata.

**Spec:** Approved architectural plan in the conversation.

## Global Constraints

- Linux-only, shell-first, RTK-friendly.
- Docker Compose owns runtime; CPU fallback is mandatory.
- Default model is Qwen2.5-Coder 7B; curated 3B light/CPU-safe profiles.
- Bind services to localhost and avoid broad destructive Docker operations.

### Task 1: CLI and hardware detection

Create `llm`, `start`, `stop`, `scripts/detect-hardware.sh`, `scripts/complete.sh`, and tests covering dispatch, profile resolution, autocomplete, and safe lifecycle argument handling.

### Task 2: Compose runtime and profiles

Create `compose.yaml`, `.env.example`, the hardware profile directory, model manifests, GPU/CPU overrides, persistent data/log directories, and health checks.

### Task 3: OpenCode integration and documentation

Create profile-local `opencode.json`, rendering/health scripts, model provenance docs, hardware rationale, troubleshooting, and usage examples.

### Task 4: Verification

Run shell syntax checks, Compose config validation, manifest/config parsing, mocked hardware fixtures, and non-destructive CLI checks.
