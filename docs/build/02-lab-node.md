# Phase 2: Lab node

**Time:** 1 to 1.5 hours · **Done when:** the Proxmox web UI opens at the node's Tailscale name and asks for a hardware key.

Proxmox VE replaces the preinstalled Windows on the lab node's 1 TB drive. After this phase, it never needs a monitor again.

## 1. Check the hardware first

Boot the preinstalled OS once and confirm the RAM and storage match your order, while a return is still easy.

## 2. Set the BIOS

| Setting | Value |
| --- | --- |
| SVM (AMD virtualization) | On |
| IOMMU | On |
| Restore on AC Power Loss | Power On |

## 3. Make the installer

Write the Proxmox VE 9 ISO to a USB stick with balenaEtcher, then boot from it using the boot-menu key shown at startup.

## 4. Install Proxmox

- **Target disk:** the NVMe drive, with the default ext4 layout. Its LVM-thin storage (`local-lvm`) supports VM snapshots.
- **Hostname:** `pve-lab`
- **Network:** a static IP, or a DHCP reservation on your router
- **Root password:** straight into your password manager

## 5. Log in from the laptop

Browse to `https://<lab-node-ip>:8006` and log in as root. The certificate warning is expected until step 8.

## 6. Switch to the free update repositories

Under the node > Updates > Repositories, add the **No-Subscription** repository and disable the two **Enterprise** ones. Then run Updates > Upgrade and reboot.

## 7. Install Tailscale

```bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up
```

Open the login URL it prints. In the admin console, disable key expiry for the node, then check that the web UI opens at the node's Tailscale address.

## 8. Add hardware security keys

WebAuthn only works on a hostname, not an IP address, and browsers expect a trusted certificate. Tailscale provides both.

1. In the Tailscale admin console > DNS, enable MagicDNS and HTTPS certificates. Certificate names are published in public Certificate Transparency logs.
2. Run [`scripts/proxmox-tailscale-cert.sh`](../../scripts/proxmox-tailscale-cert.sh) on the node. It requests a certificate for the node's tailnet name and installs it for the web UI.
3. From now on, open Proxmox at `https://pve-lab.<tailnet>.ts.net:8006`.
4. Under Datacenter > Options > WebAuthn Settings, set the ID and origin to that name.
5. Under Datacenter > Permissions > Two Factor, add **Recovery Keys** first and store them in your password manager. Then add **WebAuthn** and tap your key. Repeat for the backup key.
6. Certificates last 90 days, so renew them on a schedule:

    ```cron
    # /etc/cron.d/tailscale-cert
    0 4 * * 1 root /root/scripts/proxmox-tailscale-cert.sh >> /var/log/tailscale-cert.log 2>&1
    ```

Next: [Phase 3: Lab VMs](03-lab-vms.md)
