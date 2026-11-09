# Phase 3: Lab VMs

**Time:** about 2 hours · **Done when:** docker-host and desk are running, reachable over Tailscale, and have a clean snapshot.

| VM | ID | OS | vCPU | RAM | Disk | Encrypted |
| --- | --- | --- | --- | --- | --- | --- |
| docker-host | 101 | Ubuntu Server 26.04 | 6 | 10 GB | 250 GB | Yes |
| desk | 102 | Ubuntu Desktop 26.04 | 4 | 8 GB | 120 GB | Yes |
| sandbox | 103 | Ubuntu Server 26.04 | 4 | 4 GB | 60 GB | No |

## 1. Upload the ISOs

In the web UI, go to local > ISO Images and upload both Ubuntu ISOs, or use Download from URL.

## 2. Create the VMs

[`proxmox/create-vms.sh`](../../proxmox/create-vms.sh) creates all three VMs with the same settings. Review the IDs, storage and ISO names at the top, then run it in the node's shell. It applies:

- q35 machine type with OVMF (UEFI) firmware and an EFI disk
- CPU type `host`
- VirtIO SCSI single controller, with discard, SSD emulation and an IO thread on the disk
- VirtIO network on `vmbr0`
- QEMU guest agent enabled, and start at boot

## 3. Install Ubuntu

Encrypt docker-host and desk. In the installer's storage step, choose LVM with encryption (LUKS), and store each passphrase in your password manager. After any reboot, open the VM's **Console** in the Proxmox web UI and type the passphrase. That works from anywhere over Tailscale.

sandbox holds nothing personal, so skip encryption there.

## 4. Bootstrap each VM

Add your SSH public key to the VM first. Then, as your normal user (not with `sudo`), run [`scripts/ubuntu-vm-bootstrap.sh`](../../scripts/ubuntu-vm-bootstrap.sh). It:

- installs the QEMU guest agent
- turns on automatic security updates
- installs Tailscale and prints its login URL
- turns off SSH password login, but only if a key is already installed

## 5. Install Docker on docker-host

[`scripts/install-docker.sh`](../../scripts/install-docker.sh) installs Docker Engine and the Compose plugin from Docker's official repository. Start every agent from [`docker/agent-template`](../../docker/agent-template/), which enforces the container rules:

- runs as a non-root user, with a read-only root filesystem and all Linux capabilities dropped
- never mounts `/var/run/docker.sock`, which is root on the host

## 6. Set up remote desktop on desk

In Settings > System > Remote Desktop, turn on **Remote Login** and set its RDP username and password. On the laptop, connect with Microsoft's free Windows App to desk's Tailscale address. Remote Login opens Ubuntu's login screen in a new session, so no monitor is needed.

## 7. Snapshot everything

For each VM, go to Snapshots > Take Snapshot and name it `clean-install`. Roll sandbox back to it after every experiment.

## Optional: Whonix

Whonix Gateway and Workstation can run as two VMs on an isolated bridge for Tor-only browsing. Whonix's KVM support is [community-maintained](https://www.whonix.org/wiki/KVM), and Proxmox is not an official platform, so expect a manual setup.

Next: [Phase 4: Mac mini](04-mac-mini.md)
