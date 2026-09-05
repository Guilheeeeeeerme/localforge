# Model catalog

The selected default is `qwen2.5-coder:7b` (balanced). Ollama lists it at about 4.7GB with a 32K context window. The profile pins a conservative 16K context so the RTX 3050 retains headroom for the desktop and OpenCode.

The Hugging Face provenance is `Qwen/Qwen2.5-Coder-7B-Instruct-GGUF`, revision `main`, quantization `Q4_K_M`, Apache-2.0. The 3B profile is the light and CPU-safe option. Larger Qwen2.5-Coder 14B/32B and Qwen3-Coder 30B/480B are tracked as evaluated-but-not-selected because their memory footprint is unsuitable for this hardware.
