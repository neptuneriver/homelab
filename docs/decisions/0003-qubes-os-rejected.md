# ADR 0003: Qubes OS considered and rejected

- **Status:** Rejected
- **Date:** 2026-11-09

## Context

Qubes OS offers the strongest compartmentalization available on a desktop, with every activity in its own Xen VM and Whonix built in. Security is the top priority for this build, so Qubes was evaluated for both x86 nodes.

## Findings

- **Lab node hardware risk.** Qubes recommends Intel. The lab node's Ryzen 7 255 is a rebadged 8845HS, and community reports show this chip family crashing Xen during IOMMU setup at boot ([report 1](https://forum.qubes-os.org/t/qubes-hcl-azw-ser8-beelink-ser8/30493), [report 2](https://forum.qubes-os.org/t/notebook-compatibility-intel-intel-core-ultra-7-155h-or-amd-amd-ryzen-7-8845hs/28227)). Qubes' own requirements also note that AMD security fixes usually arrive through vendor BIOS updates.
- **No remote use, by design.** dom0 has no network access, so Qubes has to be used sitting at the machine. That conflicts with [ADR 0001](0001-remote-first-headless-nodes.md).
- **House node too small.** The Intel N150 is Intel throughout, but 16 GB is both the Qubes recommendation and the machine's ceiling, and it would have to give up Home Assistant.
- **Not a server.** Qubes is built for a person at a desk, not for always-on containers.

## Decision

No Qubes. Compartmentalization comes from Proxmox VMs, Tailscale access rules and optional Whonix VMs on the lab node.

## Revisit if

A dedicated, sit-down secure workstation becomes a goal. A small Intel machine with plenty of RAM would be the better candidate.
