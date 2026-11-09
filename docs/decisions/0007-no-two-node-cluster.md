# ADR 0007: No two-node Proxmox cluster

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

With two Proxmox nodes, joining them into a cluster would give one web UI and VM migration between nodes.

## Options considered

1. A two-node cluster.
2. A two-node cluster plus a QDevice, an external third vote.
3. Two standalone nodes.

## Decision

Keep the nodes standalone.

## Consequences

- A cluster needs a majority of votes (quorum) to run VMs. With two nodes, when one is down, the survivor has only half the votes and stops its VMs, so rebooting the lab node could stop Home Assistant on the house node.
- A QDevice fixes that, but it adds a third component to run and maintain, which isn't worth it for this setup.
- There are two web UIs to open instead of one.
- Moving a VM between nodes means a backup and restore instead of a live migration.
