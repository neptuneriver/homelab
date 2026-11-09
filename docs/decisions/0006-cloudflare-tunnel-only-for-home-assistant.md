# ADR 0006: Cloudflare Tunnel only for Home Assistant, behind Access

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

Home Assistant was already published through a Cloudflare Tunnel, which some integrations need and which allows browser access without a VPN. A tunnel avoids open ports, but on its own it leaves the Home Assistant login page reachable by anyone on the internet.

## Options considered

1. Remove the tunnel and use only Tailscale.
2. Keep the tunnel as it is.
3. Keep the tunnel and put Cloudflare Access in front of it.

## Decision

Keep the tunnel for Home Assistant only, and require a Cloudflare Access sign-in before any request reaches it. Admin interfaces such as Proxmox, SSH and RDP never go through Cloudflare.

## Consequences

- Attackers can't reach the Home Assistant login page without passing Cloudflare's identity check first. Cloudflare Access is free for up to 50 users.
- Cloudflare terminates TLS, so it can see Home Assistant traffic.
- The Home Assistant phone app can't complete the Access sign-in redirect, so the app connects over Tailscale instead.
