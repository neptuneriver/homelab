# Phase 1: House node

**Time:** about 1 hour · **Done when:** Home Assistant is backed up, the subnet route is approved, and Cloudflare Access protects Home Assistant.

The house node already runs Proxmox VE with a Home Assistant OS VM. This phase hardens it and turns it into a reliable second way into the house.

## 1. Back up Home Assistant

In Home Assistant, go to Settings > System > Backups and make a full backup. Download it to your laptop and store the backup encryption key in your password manager.

## 2. Power on after outages

In the BIOS, set **Restore on AC Power Loss** (sometimes called **State After G3**) to **Power On**.

## 3. Install Tailscale as a subnet router

Find the LAN range first:

```bash
ip -4 addr show vmbr0   # "inet 192.168.1.20/24" means the LAN is 192.168.1.0/24
```

Copy [`scripts/tailscale-subnet-router.sh`](../../scripts/tailscale-subnet-router.sh) to the node and run it in the Proxmox shell with your LAN range:

```bash
./tailscale-subnet-router.sh 192.168.1.0/24
```

The first run prints a login URL. Open it on your laptop to add the node to your tailnet.

## 4. Approve the route and disable key expiry

In the Tailscale admin console, go to **Machines**:

1. The node shows a **Subnets** badge. Open the node, or its **…** menu > **Edit route settings**, check the LAN range and save.
2. From the same **…** menu, choose **Disable key expiry**.

No Subnets badge? Check what the node is advertising:

```bash
tailscale debug prefs | grep -A3 AdvertiseRoutes
```

To test, put your laptop on a phone hotspot and open `https://<house-node-lan-ip>:8006`.

## 5. Add hardware keys to Proxmox

Proxmox WebAuthn needs a hostname and a trusted certificate, which Tailscale provides. Follow [Phase 2, step 8](02-lab-node.md#8-add-hardware-security-keys) on this node too.

## 6. Put Cloudflare Access in front of Home Assistant

1. In Cloudflare Zero Trust, go to Access > Applications > Add > Self-hosted.
2. Use Home Assistant's tunnel hostname, and allow only your own identity. Ideally that identity is an account protected by your hardware key.
3. Point the Home Assistant phone app at Home Assistant's LAN address, which Tailscale reaches through the subnet route. The app can't complete the Access sign-in.
4. Home Assistant offers TOTP but not WebAuthn. Store its TOTP secret on both hardware keys with Yubico Authenticator.

## 7. Add monitoring and DNS filtering

Install Uptime Kuma, and AdGuard Home if you want network-wide DNS filtering, as small LXC containers. The [Proxmox VE Helper-Scripts](https://community-scripts.github.io/ProxmoxVE/) set each one up in a single command. Read a script before you run it, since it runs as root. Monitors get added in Phase 5.

## Sizing note

Home Assistant needs 2 vCPU and 2 GB of RAM at minimum, and 4 GB is comfortable. Add cores only for local voice control (Whisper and Piper) or camera object detection (Frigate).

Next: [Phase 2: Lab node](02-lab-node.md)
