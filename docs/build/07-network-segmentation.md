# Phase 7: Network segmentation

**Time:** about 2 hours · **Done when:** every device is on its planned network, and the [offsite checklist](06-offsite-checklist.md) passes again.

Start only after Phase 6 passes, so you know the setup worked before the network changed. The networks, firewall rules and switch port settings are in the [network plan](../network.md#network-plan). The servers stay on the default network, so no server address, DHCP reservation or Tailscale route changes.

## Before you start

- **Download a backup of the UniFi console.** Step 4 may migrate the firewall, and only a backup from before the migration undoes it.
- **Work from a wired port on the default network.** A wrong setting on the port or Wi-Fi network you are using cuts you off mid-change.

## Steps

1. **Create the networks.** In Settings > Networks, add Trusted, IoT, Cameras and Guest with the VLAN IDs from the plan.
2. **Create the Wi-Fi networks.** Point the main Wi-Fi at Trusted. Add an IoT Wi-Fi that allows WPA2 and 2.4 GHz for older devices, and a Guest Wi-Fi with client isolation.
3. **Lock down the switch ports.** Set the ports for the cameras, doorbells, entry readers and the Access Hub to the Cameras network, with Tagged VLAN Management set to Block All. Set the server ports to Block All as well. Only the uplink and the access point ports keep Allow All.
4. **Add the firewall rules.** If UniFi offers to migrate to the zone-based firewall, accept. Then create zones for IoT, Cameras and Guest under Settings > Policy Engine > Zones (the menu has moved between versions), and add the rules from the plan. Log blocked traffic for the first week.
5. **Keep casting working.** Turn on Multicast DNS (mDNS) for Trusted and IoT, so phones can still find TVs and speakers.
6. **Move the devices.** Reconnect each Wi-Fi device to its new network, then check any Home Assistant integration that uses a device's IP address. A device that pushes to Home Assistant needs the narrow IoT rule from the plan.
7. **Leave Tailscale alone.** The house node's route still covers the default network. To reach another network remotely, advertise its subnet too and allow it in the firewall.
8. **Rerun the [offsite checklist](06-offsite-checklist.md).**

Back to the [build order](../../README.md#build-order)
