# ADR 0004: Home Assistant stays on its own low-power node

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

Home Assistant already runs as a VM on the N150 house node. With a more powerful lab node arriving, the options were to consolidate onto it, reinstall Home Assistant OS on bare metal, or leave things as they are.

## Options considered

1. **Move Home Assistant to the lab node** and retire or repurpose the N150.
2. **Reinstall Home Assistant OS bare metal** on the N150.
3. **Keep Home Assistant OS as a VM** on the N150's Proxmox.

## Decision

Keep Home Assistant OS as a VM on the house node.

## Consequences

- **Separation.** Experiments on the lab node can't take down lights, locks or automations.
- **Nothing lost to virtualization.** Home Assistant OS runs as well in a VM as on bare metal, and the VM keeps snapshots and room for small helper containers.
- **Spare capacity is put to work.** About 11 GB of free RAM hosts the Tailscale subnet router, Uptime Kuma and AdGuard Home.
- The N150 is not suitable as the main hypervisor anyway: its 16 GB of single-channel memory is the chip's ceiling.
- There are two Proxmox hosts to patch.
