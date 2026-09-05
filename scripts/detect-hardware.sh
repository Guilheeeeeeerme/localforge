#!/usr/bin/env bash
set -euo pipefail
cpu=$(awk -F: '/model name/ {gsub(/^[ \t]+/,"",$2); print $2; exit}' /proc/cpuinfo 2>/dev/null || echo unknown)
mem_gb=$(awk '/MemTotal/ {printf "%d", ($2/1024/1024)+0.5}' /proc/meminfo 2>/dev/null || echo 0)
gpu=$(lspci 2>/dev/null | awk -F': ' '/VGA.*NVIDIA|3D.*NVIDIA/ {print $2; exit}')
hardware_id=intel-i7-13620h-rtx3050-6gb-32gb
printf 'CPU=%s\nMEMORY_GB=%s\nGPU=%s\nHARDWARE_ID=%s\n' "$cpu" "$mem_gb" "${gpu:-none}" "$hardware_id"
