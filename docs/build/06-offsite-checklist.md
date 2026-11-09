# Phase 6: Offsite checklist

**Time:** about 30 minutes · **Done when:** every box below is checked.

Run this from outside your home network, for example with the laptop on a phone hotspot. Testing from home Wi-Fi proves very little, because the laptop can reach everything directly.

- [ ] Open both Proxmox web UIs by their Tailscale names and log in with a hardware key
- [ ] SSH into docker-host
- [ ] Open a remote desktop session to desk
- [ ] Screen Share to the Mac mini
- [ ] Open the Home Assistant app over Tailscale, and Home Assistant in a browser through Cloudflare Access
- [ ] Reboot the lab node from the laptop, then unlock docker-host and desk from their Proxmox consoles
- [ ] Reboot the Mac mini, then unlock FileVault over SSH through the subnet route
- [ ] Unplug the lab node's power, plug it back in, and confirm it boots by itself
- [ ] Stop an agent on purpose and confirm the Uptime Kuma alert reaches your phone
- [ ] Restore one VM backup to a new VM ID with its network disconnected, confirm it boots, then delete it
- [ ] Open the UniFi Protect app and watch a live camera

When everything passes, the setup is ready to be relied on away from home. Keep [recovery](../recovery.md) bookmarked.

Next: [Phase 7: Network segmentation](07-network-segmentation.md)
