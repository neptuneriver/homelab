# Security model

Nothing is reachable from the internet except Home Assistant, and that requires a Cloudflare sign-in first. Everything else is private on Tailscale, and AI agents are boxed into one VM that can reach one port. Cameras, entry readers and smart-home devices sit on their own networks and can't start connections to the servers.

## Threats and controls

| Threat | Controls |
| --- | --- |
| Internet scanning and exploits against exposed services | No port forwards on the router. The only public service is Home Assistant through a Cloudflare Tunnel, with Cloudflare Access in front of the login page |
| A compromised or misbehaving AI agent | Agents run in their own VM, as non-root containers with a read-only filesystem and no Linux capabilities. They never get the Docker socket. Tailscale rules let them reach only the model server's port. Snapshots allow rollback |
| A lost or stolen laptop | Tailscale key expiry stays on for personal devices. The device is removed from the Tailscale admin console immediately. FileVault protects its disk |
| A stolen drive or machine | VMs that hold personal data use LUKS encryption. The Mac mini uses FileVault |
| Phishing and password reuse | Hardware security keys (WebAuthn) on both Proxmox hosts, Cloudflare and the identity provider behind Tailscale. Where a service only offers TOTP, the secret lives on the hardware key |
| Lockout while away from home | Automatic power-on after outages, remote unlock paths for encrypted disks, the subnet router as a second way in, and smart plugs for a forced restart |
| Data loss | Weekly VM backups to a different machine, daily Home Assistant backups and Time Machine. See [backups](backups.md) |
| Malicious install scripts | Software comes from official repositories (Docker, Tailscale). Community scripts are read before they run as root |
| A hacked camera, entry reader or smart-home device | Each kind sits on its own network (VLAN). The gateway's firewall blocks them from starting connections to the servers, and cameras get no internet at all ([Phase 7](build/07-network-segmentation.md)) |
| A laptop plugged into an outdoor camera's cable | Camera ports carry only the Cameras network and block tagged VLANs, so the laptop can reach only the gateway |
| A compromised VM tagging its traffic onto another network | Server switch ports block tagged VLANs, so the frames are dropped |
| Takeover of the UniFi account | The strongest MFA the account offers, UniFi remote access optional (manage over Tailscale instead), and the official release channel only |

## Rules for every machine

- **No port forwarding** on the router, ever.
- **Tailscale on every host and VM.** Tagged servers have key expiry turned off, so they never drop off the tailnet while you are away. Personal devices keep it on.
- **SSH with keys only.** Password login is turned off once a key is installed.
- **Hardware keys everywhere they are supported**, with a second, backup key registered on every account and recovery codes stored in a password manager.
- **Agents stay contained**: their own VM, non-root containers, and never a mounted `/var/run/docker.sock`.
- **Encrypt anything holding personal data**: LUKS inside the Ubuntu VMs, FileVault on the Mac mini.
- **Updates.** Ubuntu VMs install security updates automatically. Proxmox hosts and Home Assistant are updated monthly, right after a snapshot.
- **Secrets** live in the password manager and git-ignored `.env` files, never in this repository.
- **Cameras and entry readers get no internet.** They talk only to the gateway, which records them and relays doorbell events.
- **Only uplinks and access points carry tagged VLANs.** Every other switch port is set to Block All.

## Hardware key details

- **Proxmox** supports WebAuthn, but only when the web UI is reached by hostname with a trusted certificate. Each node gets a certificate for its Tailscale name from `tailscale cert` ([script](../scripts/proxmox-tailscale-cert.sh)). Recovery keys are created before WebAuthn is turned on.
- **Home Assistant** offers TOTP but not WebAuthn, so its TOTP secret is stored on both hardware keys with Yubico Authenticator.
- **Two keys, always.** Every account gets the backup key at the same time as the primary.

## What this does not protect against

- **Someone with physical access and time.** The Proxmox host disks themselves are not encrypted. Only the guest disks are.
- **Account takeover at Tailscale or Cloudflare.** Both are trusted third parties. Hardware keys on those accounts reduce the risk.
- **Cloudflare seeing tunnel traffic.** Cloudflare terminates TLS for the tunnel, so it can see Home Assistant traffic. Admin interfaces never go through it.
- **Unpatched vulnerabilities.** Monthly patching narrows the window but does not close it.
- **A compromised gateway.** The Dream Machine Pro routes, filters and records everything, so it is the most valuable target in the house. Keep it updated and its account locked down.
- **Losing camera footage.** The gateway records to a single drive, so a failed drive loses footage, and a gateway reboot leaves a gap.
