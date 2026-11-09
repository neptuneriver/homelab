# ADR 0005: Tailscale for all private access

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

Every node has to be managed from anywhere without exposing admin interfaces to the internet.

## Options considered

1. **Port forwarding.** Simple, but it exposes services to constant internet scanning.
2. **Self-hosted WireGuard.** No third party, but it needs an open port, key management and dynamic DNS.
3. **Tailscale.** A WireGuard mesh with identity-based access rules, and no open ports.
4. **Cloudflare Tunnel for everything.** No open ports, but Cloudflare decrypts the traffic, and SSH and RDP are awkward through it.

## Decision

Tailscale runs on every node, every VM and every personal device. The house node also acts as a subnet router for the LAN.

## Consequences

- No ports open on the router, and traffic is encrypted end to end between devices.
- Access rules are per device and tag. Agent VMs can reach only the model server's port ([policy](../../tailscale/policy.hujson)).
- The subnet router gives a second path in when a node's own Tailscale is down, and reaches LAN-only devices.
- The free Personal plan covers this setup, for non-commercial use.
- It depends on Tailscale's coordination service.
- Key expiry needs a deliberate choice per device: off for servers, on for laptops and phones.
- HTTPS certificates publish machine names in public Certificate Transparency logs.
