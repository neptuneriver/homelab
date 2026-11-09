# ADR 0001: Remote-first, headless nodes

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

Day-to-day work happens on a laptop, often away from home. Three always-on machines need to be set up and run: a house node, a lab node and an AI node. Keeping a monitor and keyboard on each, or needing to be home to fix them, would defeat the point.

## Options considered

1. A desktop on each machine, used locally.
2. Every machine headless, managed from the laptop over a private network.

## Decision

Every node runs headless and is managed from the laptop over Tailscale, using SSH, the Proxmox web UIs, RDP and Screen Sharing. The one desktop environment lives in a VM that is reached by RDP.

## Consequences

- No monitors or keyboards to keep around, and the same workflow from anywhere.
- Remote recovery has to be designed in: automatic power-on after outages, remote unlock for encrypted disks, a second network path in, and smart plugs for a forced restart.
- Operating systems that must be used at the machine are out ([ADR 0003](0003-qubes-os-rejected.md)).
