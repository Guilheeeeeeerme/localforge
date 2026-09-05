# Getting started with LocalForge

LocalForge turns a fresh computer into a local OpenCode coding backend. It performs the same analysis used for the reference profile: CPU model and thread count, system memory, GPU model/VRAM class, Docker availability, NVIDIA runtime availability, disk space, and a model-size fit check.

## 1. Install

Most users should install the latest release directly:

```bash
curl -fsSL https://raw.githubusercontent.com/Guilheeeeeeerme/localforge/main/scripts/install.sh | bash && source ~/.bashrc
localforge doctor
localforge start balanced
```

The installation is self-contained in `~/.localforge`. After startup, run `opencode` from any coding directory and select the LocalForge model if a project overrides the global default.

The installer also enables Bash completion for commands and profiles (`localforge start <Tab>`).

## 2. Fork and branch (contributors)

On GitHub, fork the LocalForge repository into your account. Clone your fork, then create a hardware branch:

```bash
git clone https://github.com/<your-user>/localforge.git
cd localforge
git switch -c hardware/<short-machine-name>
```

The branch keeps your machine-specific profile isolated and gives you a clean pull request if you want to contribute it.

## 3. Analyze and create your profile

```bash
./llm init
./llm doctor
./llm profiles
```

`init` creates `profiles/custom-<hostname>/` with the detected hardware facts, model catalog, and OpenCode template. Review the generated `model.yaml`; do not claim a GPU profile unless `nvidia-smi` and Docker GPU access both work.

## 4. Start OpenCode’s local backend

```bash
./llm start balanced
./llm open
```

The first run downloads Ollama and the selected model into `data/ollama`, validates that OpenCode is installed, and configures the global OpenCode provider. Startup is detached by default. Use `localforge open` to launch OpenCode, `localforge logs` for diagnostics, and `localforge stop` when finished.

Before opening a coding repository, install OpenCode if needed and review [docs/opencode.md](docs/opencode.md) for the recommended `/models`, `/init`, Plan mode, permissions, and testing workflow.

## 5. Contribute your hardware profile

Commit only the profile and documentation changes; model blobs and generated runtime state are ignored. Include the output of `./llm doctor`, the selected model, approximate memory use, and whether GPU or CPU mode was used. Open a pull request from your hardware branch.

## Safety and privacy

The service binds to `127.0.0.1`; it is not exposed to the network. Hardware detection stays local. Never commit `.env`, `data/ollama`, credentials, or model files.
