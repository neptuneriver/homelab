# Gotchas

Things that cost time during the build, so they don't cost you any.

## Tailscale

- **`tailscale up` needs a browser login.** The first run prints a login URL. The machine is not in your tailnet until you open it and sign in.
- **The subnet route has to match the real LAN.** The plan assumed `192.168.1.0/24`, and the actual network was different, so the advertised route matched nothing. Check with `ip -4 addr show vmbr0` and advertise what you see.
- **No "Subnets" badge in the admin console** means the node isn't advertising a route. Confirm with `tailscale debug prefs | grep -A3 AdvertiseRoutes`, then fix it with `tailscale set --advertise-routes=<LAN>`.
- **Key expiry is a per-device choice.** Turn it off for servers, which would otherwise drop off the tailnet while you are away. Keep it on for laptops and phones, which can be lost.
- **Define tags before you apply them.** A tag must exist in `tagOwners` before you can assign it to a machine, so paste the policy first, then tag.
- **HTTPS certificates are public.** Enabling Tailscale HTTPS publishes machine names in Certificate Transparency logs. Name machines generically.
- **MagicDNS names may not resolve inside Docker containers.** Point agents at the model server's Tailscale IP instead of its name.

## Proxmox

- **WebAuthn refuses IP addresses.** Hardware keys only work when you open the web UI by hostname, with a trusted certificate. Use the Tailscale name and `tailscale cert`, and create recovery keys before turning WebAuthn on.
- **Two-node clusters are a trap.** With two nodes and no third vote, losing one stops the VMs on the other. Keep the nodes standalone ([ADR 0007](decisions/0007-no-two-node-cluster.md)).
- **A test restore clones the VM's identity.** Disconnect the restored copy's network before the first boot so it doesn't fight the original over its IP and Tailscale identity.

## Encryption and remote reboots

- **Passphrase encryption blocks remote reboots on bare metal.** A host waiting for a disk passphrase at boot can't be reached. Encrypting inside the VMs instead means you unlock them from the Proxmox web console.
- **macOS 26 can unlock FileVault over SSH before login**, but Tailscale isn't running at that point. Go through the subnet router to the Mac's LAN IP.

## Apps and hardware

- **The Home Assistant app can't pass Cloudflare Access.** It fails at the sign-in redirect. Use the app over Tailscale and keep Access for browsers.
- **Ollama listens only on localhost by default.** `launchctl setenv OLLAMA_HOST` fixes that until the next reboot. Making it permanent is on the roadmap.
- **The OCuLink adapter costs an SSD slot.** It sits in the lab node's second M.2 slot.
- **OCuLink is not hot-swappable.** Power off before plugging in a GPU dock.

## UniFi

- **The switch's copper ports are 1 GbE.** Devices with 2.5 GbE ports, like the U7 access points, the lab node and the Mac mini, link at 1 Gbps.
- **Uplink over SFP+.** Once the networks are split, traffic between them goes through the gateway, so connect the switch to it with the 10G SFP+ ports.
- **Switch ports allow every VLAN by default.** Tagged VLAN Management starts at Allow All. Set it to Block All everywhere except the uplink and the access points.
- **The zone-based firewall migration is one-way.** Download a console backup first. Only restoring it undoes the migration.
- **Entry readers unlock only through a hub they're cabled to.** Most hub models control one door, so two doors usually means two hubs. Without a hub, a reader still works as a Protect camera and doorbell.
- **Home Assistant's UniFi integrations don't support Early Access firmware.** Keep the console on the official release channel.
- **Casting across networks needs mDNS.** Turn on Multicast DNS for the trusted and IoT networks, or phones can't find TVs and speakers.
- **Some devices push to Home Assistant.** With MQTT and some Shelly or Sonos features, the device starts the connection. Allow just those ports from IoT to Home Assistant rather than opening the whole IoT network.
