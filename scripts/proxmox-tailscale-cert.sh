#!/usr/bin/env bash
#
# Request a trusted TLS certificate for this Proxmox host's Tailscale name and
# install it for the web UI. WebAuthn (hardware security keys) needs a hostname
# and a trusted certificate, and this provides both.
#
# Prerequisites:
#   - Tailscale installed and logged in on this host
#   - MagicDNS and HTTPS certificates enabled in the Tailscale admin console (DNS page)
#
# Certificates last 90 days. Run this weekly from cron to keep it current:
#   0 4 * * 1 root /root/scripts/proxmox-tailscale-cert.sh >> /var/log/tailscale-cert.log 2>&1
#
# Based on: https://tailscale.com/kb/1133/proxmox

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Error: run this as root." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  apt-get update -qq
  apt-get install -y -qq jq
fi

CERT_DIR="/etc/tailscale-certs"
mkdir -p "${CERT_DIR}"
chmod 700 "${CERT_DIR}"
cd "${CERT_DIR}" || exit 1

# This node's MagicDNS name without the trailing dot, e.g. pve-lab.example-tailnet.ts.net
NAME="$(tailscale status --json | jq -r '.Self.DNSName | rtrimstr(".")')"

if [[ -z "${NAME}" || "${NAME}" == "null" ]]; then
  echo "Error: couldn't read this node's Tailscale name. Is MagicDNS enabled?" >&2
  exit 1
fi

# Writes ${NAME}.crt and ${NAME}.key into the current directory.
tailscale cert "${NAME}"
pvenode cert set "${NAME}.crt" "${NAME}.key" --force --restart

echo "Installed a certificate for ${NAME}. Open https://${NAME}:8006"
