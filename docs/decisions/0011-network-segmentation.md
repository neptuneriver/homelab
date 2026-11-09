# ADR 0011: Segment the network with VLANs on the UniFi gateway

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

Servers, cameras, entry readers, smart-home devices and guests all shared one flat network. Cameras and smart-home devices run firmware that can't be audited and is rarely updated, and some of their cables run outdoors. On a flat network, any one of them can reach the Proxmox hosts, the agent VMs and the Mac mini directly.

## Options considered

1. Keep the flat network and rely on each device's own security.
2. Add VLANs and zone-based firewall rules on the UniFi gateway, with the servers staying on the default network.
3. The same, but move the servers to a new VLAN too.
4. Physically separate networks, with their own switches, for cameras and smart-home devices.

## Decision

Option 2. Trusted devices, smart-home devices, cameras and guests each get a VLAN, and the gateway's zone-based firewall decides what crosses between them. Switch ports that don't need tagged traffic are set to Block All. The [network plan](../network.md#network-plan) has the details.

## Consequences

- A hacked camera or smart plug can't start a connection to the servers. Cameras lose internet access entirely and talk only to the gateway.
- Traffic between networks now passes through the gateway, so the switch uplink should use the 10G SFP+ ports.
- Casting from phones to TVs needs mDNS across the trusted and IoT networks.
- Devices that push to Home Assistant need a narrow firewall exception.
- Reaching the new networks remotely needs extra Tailscale routes and firewall rules. Option 3 would also have changed every server address and the existing subnet route, and option 4 needs more hardware for little extra safety.
