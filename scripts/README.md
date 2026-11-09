# Scripts

Small, single-purpose setup scripts. Read each one before running it.

| Script | Run on | As | What it does |
| --- | --- | --- | --- |
| [`tailscale-subnet-router.sh`](tailscale-subnet-router.sh) | House node | root | Installs Tailscale, enables IP forwarding and advertises the LAN |
| [`proxmox-tailscale-cert.sh`](proxmox-tailscale-cert.sh) | Each Proxmox node | root | Installs a trusted certificate for the node's Tailscale name, which WebAuthn needs |
| [`ubuntu-vm-bootstrap.sh`](ubuntu-vm-bootstrap.sh) | Each Ubuntu VM | Your user | Guest agent, automatic security updates, Tailscale, SSH key-only login |
| [`install-docker.sh`](install-docker.sh) | docker-host | Your user | Docker Engine and Compose from Docker's official repository |
| [`../proxmox/create-vms.sh`](../proxmox/create-vms.sh) | Lab node | root | Creates docker-host, desk and sandbox with consistent settings |

All scripts use `set -euo pipefail`, so they stop at the first error. They are checked with [ShellCheck](https://www.shellcheck.net/) on every push.
