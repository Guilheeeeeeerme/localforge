# OpenCode workflow

LocalForge updates the global `~/.config/opencode/opencode.json` after the first successful start. Its dedicated `localforge` provider uses Ollama’s OpenAI-compatible `/v1` endpoint, so it is available from every project. A project-level `opencode.json` can still override the global default.

Install OpenCode with the official installer:

```bash
curl -fsSL https://opencode.ai/install | bash
```

Then, from the code repository you want to modify:

```bash
opencode
```

Recommended first session:

```text
/models
/init
```

Choose the LocalForge/Ollama model in `/models`. `/init` asks OpenCode to inspect the repository and create `AGENTS.md`; review that file and commit it to the project. Use Plan mode (`Tab`) before multi-file changes, ask for tests, and inspect the diff before accepting edits. Use `@path/to/file` references to constrain context and `/undo` if a change is not what you intended.

Local models have finite context and may be slower than hosted models. Keep requests focused, provide acceptance criteria, and ask OpenCode to run the smallest relevant test command rather than an unbounded test suite.
