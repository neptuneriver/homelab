#!/usr/bin/env bash
#
# First-boot setup for an Ubuntu 26.04 VM on Proxmox.
# Run as your normal user, not with sudo. It calls sudo where needed.
#
#   - installs the QEMU guest agent, so Proxmox can see the VM's IP and shut it down cleanly
#   - turns on automatic security updates
#   - installs Tailscale and starts its login
#   - turns off SSH password login, but only if an SSH key is already installed

set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this as your normal user, not root. It uses sudo where needed." >&2
  exit 1
fi

echo "==> Updating packages"
sudo apt-get update
sudo apt-get -y full-upgrade

echo "==> Installing the QEMU guest agent and unattended-upgrades"
sudo apt-get install -y qemu-guest-agent unattended-upgrades
sudo systemctl start qemu-guest-agent

echo "==> Turning on automatic security updates"
sudo tee /etc/apt/apt.conf.d/20auto-upgrades >/dev/null <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

echo "==> Installing Tailscale"
if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi
if ! tailscale status >/dev/null 2>&1; then
  # Prints a login URL. Open it to add this VM to your tailnet.
  sudo tailscale up
fi

echo "==> Hardening SSH"
if [[ -s "${HOME}/.ssh/authorized_keys" ]]; then
  # Files in sshd_config.d are read in name order and the first value wins,
  # so the 10- prefix overrides cloud-init's 50- file.
  sudo tee /etc/ssh/sshd_config.d/10-hardening.conf >/dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
EOF
  sudo sshd -t
  if systemctl is-active --quiet ssh; then
    sudo systemctl reload ssh
  fi
  echo "SSH now accepts keys only."
else
  echo "Skipped: no keys in ${HOME}/.ssh/authorized_keys yet. Add one, then run this script again." >&2
fi

echo
echo "Done. If the upgrade installed a new kernel, reboot: sudo reboot"
