# Agent container template

A Compose file with secure defaults for running an AI agent on docker-host. Copy the folder for each agent:

```bash
cp -r docker/agent-template ~/agents/my-agent
cd ~/agents/my-agent
cp .env.example .env            # then fill it in
mkdir -p data && sudo chown 1000:1000 data
docker compose up -d
docker compose logs -f
```

## Why each setting is there

| Setting | Protects against |
| --- | --- |
| `user: "1000:1000"` | A compromised process having root inside the container |
| `read_only: true` | Malware writing itself into the container's filesystem |
| `cap_drop: [ALL]` | Kernel-level actions such as changing network settings or mounting filesystems |
| `no-new-privileges:true` | Escalating through setuid binaries |
| One `./data` volume | The agent reading or writing anything else on the VM |
| `mem_limit`, `cpus`, `pids_limit` | A runaway agent starving the VM |
| No Docker socket | The agent taking over the host. The socket is equivalent to root |

The network boundary is enforced outside the container. Tailscale access rules let docker-host reach only the model server's port ([policy](../../tailscale/policy.hujson)).

If an image needs to write somewhere else, add a narrow `tmpfs` or volume for that path rather than turning off `read_only`.
