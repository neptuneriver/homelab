#!/usr/bin/env bash
#
# Make a Proxmox (Debian) host a Tailscale subnet router for the home LAN.
# Run in the Proxmox shell as root.
#
# Usage: ./tailscale-subnet-router.sh <LAN_CIDR>
#   e.g. ./tailscale-subnet-router.sh 192.168.1.0/24
#
# Find your LAN range with: ip -4 addr show vmbr0
# Docs: https://tailscale.com/kb/1019/subnets

set -euo pipefail

LAN_CIDR="${1:-}"

if [[ -z "${LAN_CIDR}" ]]; then
  echo "Usage: $0 <LAN_CIDR>   (example: $0 192.168.1.0/24)" >&2
  exit 1
fi

if [[ ! "${LAN_CIDR}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$ ]]; then
  echo "Error: '${LAN_CIDR}' doesn't look like an IPv4 range such as 192.168.1.0/24." >&2
  exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
  echo "Error: run this as root. The Proxmox shell logs you in as root." >&2
  exit 1
fi

# 1. Install Tailscale from its official repository if it isn't installed yet.
if ! command -v tailscale >/dev/null 2>&1; then
  echo "==> Installing Tailscale"
  curl -fsSL https://tailscale.com/install.sh | sh
fi

# 2. Let the kernel forward packets between Tailscale and the LAN.
#    The file in /etc/sysctl.d keeps the setting across reboots.
echo "==> Enabling IP forwarding"
cat > /etc/sysctl.d/99-tailscale.conf <<'EOF'
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
EOF
sysctl -p /etc/sysctl.d/99-tailscale.conf

# 3. Advertise the LAN. If this node isn't logged in yet, `tailscale up` prints
#    a login URL. Open it in a browser to add the node to your tailnet.
echo "==> Advertising ${LAN_CIDR}"
if tailscale status >/dev/null 2>&1; then
  tailscale set --advertise-routes="${LAN_CIDR}"
else
  tailscale up --advertise-routes="${LAN_CIDR}"
fi

cat <<EOF

Done. Next, in the Tailscale admin console > Machines:
  1. Approve ${LAN_CIDR} for this machine (Subnets badge, or ... > Edit route settings).
  2. Disable key expiry for this machine (... > Disable key expiry).

Check what this node advertises with:
  tailscale debug prefs | grep -A3 AdvertiseRoutes
EOF
