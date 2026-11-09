# Phase 0: Prep

**Time:** about 30 minutes · **Done when:** installers are on a USB stick, the accounts exist, and you know your LAN range.

## Accounts

- [ ] Tailscale account. The free Personal plan covers this setup, for non-commercial use.
- [ ] Cloudflare account with your domain, if Home Assistant will be published through a tunnel.
- [ ] Two hardware security keys, one primary and one backup.
- [ ] A "Homelab" folder in your password manager.

## Downloads

- [ ] Proxmox VE 9 ISO
- [ ] Ubuntu Server 26.04 LTS ISO
- [ ] Ubuntu Desktop 26.04 LTS ISO
- [ ] balenaEtcher (or `dd`) and a USB stick of 8 GB or more
- [ ] Ethernet cables for every node

## Information to collect

- **Your LAN range.** On an existing Proxmox host, run `ip -4 addr show vmbr0`. A result of `inet 192.168.1.20/24` means the LAN is `192.168.1.0/24`.
- **Addresses to reserve** in your router's DHCP settings: the house node, the lab node and the Mac mini.

## Password manager entries

Create these as you go, so nothing important lives only in your head.

| Item | Needed when |
| --- | --- |
| Proxmox root passwords and recovery keys, one set per node | Logging in from a new device, or without a hardware key |
| LUKS passphrases for docker-host and desk | Every lab node reboot |
| Mac mini admin password and FileVault recovery key | Every Mac mini reboot, or a forgotten password |
| Home Assistant owner login and backup encryption key | Restoring Home Assistant |
| Tailscale and Cloudflare recovery codes | Losing a hardware key |
| SSH key passphrase | Setting up a new laptop |
| UniFi account login and MFA recovery codes | Changing DHCP reservations, networks and firewall rules |

Next: [Phase 1: House node](01-house-node.md)
