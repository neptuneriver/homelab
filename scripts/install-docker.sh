#!/usr/bin/env bash
#
# Install Docker Engine and the Compose plugin on Ubuntu from Docker's official
# repository. Run as your normal user. It uses sudo.
#
# Docs: https://docs.docker.com/engine/install/ubuntu/

set -euo pipefail

echo "==> Removing conflicting packages, if any"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y "${pkg}" >/dev/null 2>&1 || true
done

echo "==> Adding Docker's apt repository"
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# shellcheck disable=SC1091
CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-${VERSION_CODENAME}}")"
sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${CODENAME}
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "==> Installing Docker Engine"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Testing"
sudo docker run --rm hello-world

cat <<'EOF'

Docker is installed. Two notes:
  - Adding a user to the "docker" group is equivalent to giving it root.
    Do it only for your own admin account, and only if you accept that.
  - Start each agent from docker/agent-template in this repo.
EOF
