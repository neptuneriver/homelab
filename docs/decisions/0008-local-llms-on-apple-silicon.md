# ADR 0008: Local LLM inference on Apple Silicon

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

Agents need a local model endpoint, for privacy and to avoid paying per token for routine work. The lab node's Radeon 780M integrated GPU isn't officially supported by AMD's ROCm stack. Ollama's [Vulkan backend](https://www.phoronix.com/news/ollama-Experimental-Vulkan) works on it, but it is experimental, shares system RAM with the VMs, and is hard to reach from inside a VM.

## Options considered

1. Run models on the lab node's CPU or iGPU.
2. Run models on a Mac mini with 32 GB of unified memory.
3. Use hosted models only.

## Decision

The Mac mini runs Ollama. Agents reach it over Tailscale on port 11434, and the access rules allow nothing else. Hosted models are still used where they make sense.

## Consequences

- Apple Silicon's unified memory lets the GPU use most of the 32 GB, which fits 30B-class models at 4-bit.
- The lab node's RAM stays free for VMs.
- There is one more machine to manage, on macOS.
- A remote unlock path is needed for FileVault after a reboot ([recovery](../recovery.md#after-a-power-outage)).
- Ollama's network binding doesn't yet survive a reboot (roadmap).
