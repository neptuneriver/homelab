#!/usr/bin/env bash
#
# Create the lab node's base VMs with consistent settings.
# Run in the Proxmox shell as root. Review the variables and the VM table first.
#
# Usage: ./create-vms.sh
# Override the defaults with environment variables, for example:
#   STORAGE=local-zfs SERVER_ISO=local:iso/ubuntu-26.04.1-live-server-amd64.iso ./create-vms.sh

set -euo pipefail

STORAGE="${STORAGE:-local-lvm}"
BRIDGE="${BRIDGE:-vmbr0}"
SERVER_ISO="${SERVER_ISO:-local:iso/ubuntu-26.04-live-server-amd64.iso}"
DESKTOP_ISO="${DESKTOP_ISO:-local:iso/ubuntu-26.04-desktop-amd64.iso}"

if ! command -v qm >/dev/null 2>&1; then
  echo "Error: qm not found. Run this on the Proxmox host." >&2
  exit 1
fi

create_vm() {
  local id="$1" name="$2" cores="$3" memory_mb="$4" disk_gb="$5" iso="$6"

  if qm status "${id}" >/dev/null 2>&1; then
    echo "VM ${id} already exists. Skipping ${name}."
    return 0
  fi

  # q35 + OVMF (UEFI) with Secure Boot keys, host CPU type, VirtIO SCSI single
  # controller with an IO thread, discard for thin provisioning, guest agent on.
  qm create "${id}" \
    --name "${name}" \
    --ostype l26 \
    --machine q35 \
    --bios ovmf \
    --efidisk0 "${STORAGE}:1,efitype=4m,pre-enrolled-keys=1" \
    --cpu host \
    --sockets 1 \
    --cores "${cores}" \
    --memory "${memory_mb}" \
    --scsihw virtio-scsi-single \
    --scsi0 "${STORAGE}:${disk_gb},discard=on,ssd=1,iothread=1" \
    --net0 "virtio,bridge=${BRIDGE},firewall=1" \
    --ide2 "${iso},media=cdrom" \
    --boot "order=scsi0;ide2" \
    --agent enabled=1 \
    --onboot 1

  echo "Created ${name} (VM ${id}): ${cores} vCPU, ${memory_mb} MB RAM, ${disk_gb} GB disk."
}

#         ID   Name         vCPU  RAM (MB)  Disk (GB)  Installer
create_vm 101  docker-host  6     10240     250        "${SERVER_ISO}"
create_vm 102  desk         4     8192      120        "${DESKTOP_ISO}"
create_vm 103  sandbox      4     4096      60         "${SERVER_ISO}"

echo
echo "Next: start each VM, open its Console and install Ubuntu."
echo "Encrypt docker-host and desk during install (LVM with LUKS)."
