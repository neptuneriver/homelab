# Recovery runbooks

What to do when something goes wrong, especially from outside the house.

## After a power outage

Every node powers itself back on. Then:

1. **House node.** Home Assistant starts automatically. Confirm it in Uptime Kuma or the Home Assistant app.
2. **Lab node.** The encrypted VMs stop at a passphrase prompt. Open `https://pve-lab.<tailnet>.ts.net:8006`, select docker-host > Console, and type its passphrase. Repeat for desk.
3. **Mac mini.** FileVault waits for a password, and Tailscale isn't running yet. Connect to the Mac's LAN IP, which the house node's subnet route makes reachable over Tailscale:

    ```bash
    ssh <user>@<mac-mini-lan-ip>
    ```

    Enter the password. The session drops while the disk mounts. Reconnect, confirm Ollama is running, then test it:

    ```bash
    curl http://<mac-mini-tailscale-ip>:11434/api/tags
    ```

## A node is frozen

1. Try the Proxmox web UI or SSH first.
2. If neither responds, turn the node's smart plug off in the Home Assistant app, wait 10 seconds, and turn it back on.
3. Follow [After a power outage](#after-a-power-outage) for that node.

The house node is never on a smart plug, because it runs Home Assistant.

## Tailscale is down on one node

Reach the node at its LAN IP through the house node's subnet route, for example `ssh <user>@<lab-node-lan-ip>`. Then check and restart Tailscale:

```bash
tailscale status
systemctl restart tailscaled
```

WebAuthn does not work when Proxmox is opened by IP address. Use SSH, or log in to the web UI with a recovery key.

## Lost a hardware key

1. Sign in with the backup key.
2. Remove the lost key from both Proxmox hosts (Datacenter > Permissions > Two Factor), from Cloudflare, and from the identity provider you use for Tailscale.
3. Order a replacement. Register it everywhere as the new backup, and add the Home Assistant TOTP secret to it.

## Lost laptop or phone

1. Remove the device in the Tailscale admin console > Machines.
2. Delete its SSH public key from `~/.ssh/authorized_keys` on every VM.
3. Sign out its sessions at Cloudflare and at your identity provider.

## Restore a VM from backup

In the web UI, open the `proxmox-backups` storage > Backups, select a backup and choose Restore. Or use the shell:

```bash
qmrestore /mnt/pve/proxmox-backups/dump/vzdump-qemu-101-<timestamp>.vma.zst 901 --storage local-lvm
```

For a **test** restore, use a new VM ID (like 901) and disconnect its network before the first boot (Hardware > Network Device > Disconnect). The copy has the same Tailscale identity and IP as the original, and the two would conflict.

## Restore Home Assistant

1. Create a fresh Home Assistant OS VM. The [Proxmox VE Helper-Scripts](https://community-scripts.github.io/ProxmoxVE/) include one.
2. During onboarding, choose to restore from a backup, upload the backup file and enter the backup encryption key.
