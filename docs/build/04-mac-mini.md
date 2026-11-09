# Phase 4: Mac mini (AI node)

**Time:** about 1 hour · **Done when:** Screen Sharing works over Tailscale and Ollama answers on port 11434 from docker-host.

## 1. Initial setup

- Connect Ethernet, reserve its IP in your router, and name it `mac-mini`.
- Turn on FileVault and store the recovery key in your password manager.

## 2. Turn on remote access

In System Settings > General > Sharing, turn on **Remote Login** (SSH) and **Screen Sharing**.

## 3. Keep it on

In System Settings > Energy, turn on:

- **Prevent automatic sleeping when the display is off**
- **Start up automatically after a power failure**

## 4. Install Tailscale

Install Tailscale and sign in. From the laptop, test Screen Sharing to the Mac mini's Tailscale address.

## 5. Practice the remote FileVault unlock

On macOS 26 and later, you can [unlock FileVault over SSH before anyone logs in](https://www.jeffgeerling.com/blog/2025/you-can-finally-manage-macs-filevault-remotely-tahoe/). Tailscale isn't running at that point, so connect to the Mac's LAN IP, which the house node's subnet route makes reachable:

```bash
ssh <user>@<mac-mini-lan-ip>
```

Enter your password and wait for the session to drop while the disk mounts, then reconnect normally. Do this once at home before you rely on it.

## 6. Install Ollama

Install Ollama and pull a small model to test, then a larger one under about 20 GB.

Make it reachable only from the tailnet by binding it to the Mac's Tailscale IP:

```bash
launchctl setenv OLLAMA_HOST "100.x.y.z"   # the Mac mini's Tailscale IP
# then quit and reopen Ollama
```

Test it from docker-host:

```bash
curl http://100.x.y.z:11434/api/tags
```

`launchctl setenv` does not survive a reboot. Making the binding permanent with launchd is on the roadmap.

## 7. Set up the backup share

Create the `proxmox-backups` share on an external SSD, as described in [backups](../backups.md). Point Time Machine for both Macs at a separate drive.

Next: [Phase 5: Wire it together](05-wire-together.md)
