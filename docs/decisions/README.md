# Architecture decision records

Each record captures one decision: the situation, the options, what was chosen and what it costs. New decisions get the next number. A reversed decision gets a new record that supersedes the old one, rather than an edit.

| ADR | Decision | Status |
| --- | --- | --- |
| [0001](0001-remote-first-headless-nodes.md) | Remote-first, headless nodes | Accepted |
| [0002](0002-proxmox-on-both-x86-nodes.md) | Proxmox VE on both x86 nodes | Accepted |
| [0003](0003-qubes-os-rejected.md) | Qubes OS considered and rejected | Rejected |
| [0004](0004-home-assistant-stays-on-house-node.md) | Home Assistant stays on its own low-power node | Accepted |
| [0005](0005-tailscale-for-private-access.md) | Tailscale for all private access | Accepted |
| [0006](0006-cloudflare-tunnel-only-for-home-assistant.md) | Cloudflare Tunnel only for Home Assistant, behind Access | Accepted |
| [0007](0007-no-two-node-cluster.md) | No two-node Proxmox cluster | Accepted |
| [0008](0008-local-llms-on-apple-silicon.md) | Local LLM inference on Apple Silicon | Accepted |
| [0009](0009-hardware-security-keys.md) | Hardware security keys for MFA | Accepted |
| [0010](0010-ubuntu-lts-for-vms.md) | Ubuntu 26.04 LTS for the VMs | Accepted |
| [0011](0011-network-segmentation.md) | Segment the network with VLANs on the UniFi gateway | Accepted |

## Template

```markdown
# ADR NNNN: Title

- **Status:** Proposed | Accepted | Rejected | Superseded by ADR NNNN
- **Date:** YYYY-MM-DD

## Context
What situation forces a decision?

## Options considered
The realistic alternatives.

## Decision
What was chosen, in one or two sentences.

## Consequences
What gets better, what gets worse, and what to watch.
```
