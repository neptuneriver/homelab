# Architecture

Four nodes, each with one job. The laptop manages everything over Tailscale, the house node keeps the home running, the lab node runs experiments and agents, and the Mac mini serves local AI models.

## Nodes and responsibilities

### Laptop: control center

Manages every other node over Tailscale: SSH, the Proxmox web UIs, RDP to the desktop VM and Screen Sharing to the Mac mini. Tailscale key expiry stays **on** for the laptop, because it leaves the house and has the broadest access.

### House node (`pve-house`): Intel N150, Proxmox VE

The boring, always-on box. Its only job is to keep the house running, whatever happens in the lab.

| Workload | Type | vCPU | RAM | Notes |
| --- | --- | --- | --- | --- |
| Home Assistant OS | VM | 2 | 4 GB | Official minimum is 2 vCPU and 2 GB. Add cores only for local voice or camera detection |
| cloudflared | Home Assistant add-on | | | Publishes Home Assistant and nothing else |
| Tailscale | Host | | | Subnet router for the LAN, a second way in |
| Uptime Kuma | LXC | 1 | 512 MB | Watches every node and alerts a phone |
| AdGuard Home | LXC | 1 | 512 MB | Optional, network-wide DNS filtering |

### Lab node (`pve-lab`): Ryzen 7 255, Proxmox VE

Where experiments happen. Snapshots make every change reversible.

| VM | OS | vCPU | RAM | Disk | Encrypted | Job |
| --- | --- | --- | --- | --- | --- | --- |
| docker-host | Ubuntu Server 26.04 | 6 | 10 GB | 250 GB | Yes, LUKS | Agent containers |
| desk | Ubuntu Desktop 26.04 | 4 | 8 GB | 120 GB | Yes, LUKS | Remote desktop workspace |
| sandbox | Ubuntu Server 26.04 | 4 | 4 GB | 60 GB | No | Throwaway tests, rolled back after each one |
| whonix-gw + whonix-ws (optional) | Whonix 18 | 1 + 2 | 1 + 2 GB | 20 + 40 GB | No | Tor-only browsing |

The host keeps about 3 GB, and the three core VMs use 22 GB, so 25 of 32 GB are committed. The rest is room for Whonix or a test VM. vCPUs are shared, so a total above the 16 hardware threads is fine.

### AI node (`mac-mini`): Apple M6, macOS

Runs local models for the agents. Of its 32 GB of unified memory, roughly 22 GB is practical for model weights and context, which fits 30B-class models at 4-bit. It also hosts the SMB share that both Proxmox nodes back up to.

## Network and access

- **Tailscale tailnet.** Every node, every VM and every personal device joins. Admin traffic never crosses the public internet unencrypted, and nothing listens on the router's WAN side.
- **Subnet router.** The house node advertises the LAN. Personal devices can then reach LAN-only addresses from anywhere, which the Home Assistant app and the Mac mini's pre-boot unlock both rely on.
- **Cloudflare Tunnel.** The only inbound path from the internet. It publishes Home Assistant alone, and Cloudflare Access requires a sign-in before the request reaches it.
- **UniFi gateway.** The Dream Machine Pro routes and firewalls all traffic, records the cameras and runs door access. Servers stay on the default network, while trusted devices, smart-home devices, cameras and guests each get their own ([network plan](network.md#network-plan)).

### Access rules

The full policy, with tests that run on every save, is in [`tailscale/policy.hujson`](../tailscale/policy.hujson).

| Source | Can reach |
| --- | --- |
| Personal devices (`autogroup:member`) | Everything, including the LAN through the subnet route |
| `tag:agents` (docker-host, sandbox) | `tag:llm` on port 11434 only |
| `tag:server` (Proxmox hosts, desk) | Nothing. Servers do not start connections |
| `tag:llm` (Mac mini) | Nothing |

### Traffic flows

| From | To | Port | Path | Purpose |
| --- | --- | --- | --- | --- |
| Laptop | Proxmox hosts | 8006 | Tailscale | Web UI |
| Laptop | docker-host, sandbox | 22 | Tailscale | SSH |
| Laptop | desk | 3389 | Tailscale | RDP |
| Laptop | Mac mini | 22, 5900 | Tailscale | SSH, Screen Sharing |
| Laptop | LAN addresses | Various | Tailscale subnet route | Home Assistant app, pre-boot FileVault unlock |
| docker-host | Mac mini | 11434 | Tailscale, ACL-restricted | Model inference |
| Internet | Home Assistant | 443 | Cloudflare Tunnel + Access | Remote browser access |
| Proxmox hosts | Mac mini | 445 | LAN | Weekly backups over SMB |
| Uptime Kuma | All nodes | Various | LAN | Monitoring |
| Home Assistant | UniFi gateway | Various | Default network | Protect and Access integrations: cameras, doorbell events, unlocking |
| Home Assistant | Smart-home devices | Various | Firewall rule, default network to IoT | Device control |
| Cameras, doorbells, readers and the Access Hub | UniFi gateway | Various | Cameras network | Recording and door access |

## Naming

| Thing | Convention |
| --- | --- |
| Proxmox hosts | `pve-<role>`: `pve-house`, `pve-lab` |
| VMs | By job: `docker-host`, `desk`, `sandbox` |
| Tailscale tags | `tag:server`, `tag:agents`, `tag:llm` |

Tailscale HTTPS certificates publish machine names in public Certificate Transparency logs, so names stay generic.
