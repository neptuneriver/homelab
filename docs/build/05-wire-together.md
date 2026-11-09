# Phase 5: Wire it together

**Time:** about 2 hours · **Done when:** access rules, backups and alerts are in place, and existing apps run on docker-host.

## 1. Apply the Tailscale access rules

1. In the admin console > Access controls, paste [`tailscale/policy.hujson`](../../tailscale/policy.hujson) and save. The tests at the bottom of the file must pass before the console accepts it.
2. Then tag the machines. Tags must exist in `tagOwners` before you can apply them, which is why the policy goes first.

    | Machine | Tag |
    | --- | --- |
    | pve-house, pve-lab, desk | `tag:server` |
    | docker-host, sandbox | `tag:agents` |
    | mac-mini | `tag:llm` |

3. Tagged devices get key expiry turned off by default. Confirm it on each machine.
4. Check the rules from docker-host. The first command should succeed and the second should time out:

    ```bash
    curl -s http://<mac-mini-tailscale-ip>:11434/api/tags
    nc -vz -w 3 <pve-lab-tailscale-ip> 8006
    ```

## 2. Schedule backups

Follow [backups](../backups.md).

## 3. Add monitoring

In Uptime Kuma on the house node, add:

| Monitor | Type | Target |
| --- | --- | --- |
| Lab node web UI | HTTP(s), ignore TLS errors | `https://<lab-node-lan-ip>:8006` |
| docker-host | Ping | LAN IP |
| Mac mini | Ping | LAN IP |
| Home Assistant | HTTP(s) | `http://<home-assistant-lan-ip>:8123` |
| Each agent | Push | The agent calls its push URL after every successful run |

A push monitor alerts you when an agent goes quiet, not just when a machine goes down. Send alerts to your phone through the Home Assistant app, ntfy or email.

## 4. Add a remote power button

Put the lab node and the Mac mini on smart plugs that Home Assistant controls. Turning a plug off and on forces a frozen machine to restart, so use it only as a last resort. Never put the house node on one.

## 5. Move an existing Compose app off your laptop

1. On the laptop, stop it with `docker compose down`.
2. Copy the folder, its `.env` and any bind-mounted data: `rsync -a ~/app/ <user>@docker-host:~/app/`. Export named volumes separately.
3. On docker-host, start it with `docker compose up -d` and watch `docker compose logs -f`.
4. Let one real job run end to end.
5. Keep the laptop copy stopped, not deleted, for a week.

Next: [Phase 6: Offsite checklist](06-offsite-checklist.md)
