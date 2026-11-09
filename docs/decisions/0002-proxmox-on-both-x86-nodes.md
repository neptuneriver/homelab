# ADR 0002: Proxmox VE on both x86 nodes

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

The lab node has to run AI agents in Docker, a desktop workspace and throwaway experiments, all managed remotely. The house node already runs Proxmox VE with Home Assistant in a VM.

## Options considered

1. **Ubuntu Desktop on bare metal.** The simplest option, with the GPU directly available. But everything shares one OS, and nothing is easy to roll back.
2. **Proxmox VE with VMs.** Adds a layer, but gives snapshots, isolation and remote console access.
3. **Qubes OS.** The strongest compartmentalization, but rejected in [ADR 0003](0003-qubes-os-rejected.md).

## Decision

Run Proxmox VE on both x86 nodes.

## Consequences

- **Snapshots** before any risky change, and instant rollback when an agent breaks something.
- **Isolation.** Agents run in a different VM from the personal desktop.
- **Remote unlock.** Encrypted VMs can be unlocked from the web console after a reboot, which a bare-metal LUKS host can't offer remotely.
- **One tool** to learn and patch across both nodes.
- The desktop is only available over RDP, not on a local monitor.
- The integrated GPU is harder to use from inside a VM, so local models moved to the Mac mini ([ADR 0008](0008-local-llms-on-apple-silicon.md)).
