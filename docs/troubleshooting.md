# Troubleshooting

- Run `./llm doctor` first.
- If Docker is missing, install Docker Engine and the Compose plugin using your distribution’s official instructions.
- If NVIDIA acceleration is unavailable, verify the proprietary driver with `nvidia-smi` and install/configure NVIDIA Container Toolkit. The runner intentionally does not modify kernel drivers.
- If startup times out, run `./llm logs`; model downloads can take several minutes on the first run.
- If OpenCode cannot see the model, confirm `curl http://127.0.0.1:11434/v1/models` and regenerate `opencode.json` with `./llm start balanced`.
