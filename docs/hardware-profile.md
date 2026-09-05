# Hardware profile

Profile identifier: `intel-i7-13620h-rtx3050-6gb-32gb`.

The profile is based on 10 physical CPU cores/16 threads, 32GiB system RAM, and a 6GiB RTX 3050 Laptop GPU. GPU mode is attempted only when `nvidia-smi` and Docker’s NVIDIA runtime both work. Otherwise Ollama runs CPU-only with the `cpu-safe` profile available explicitly.
