# ADR 0010: Ubuntu 26.04 LTS for the VMs

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

The lab VMs need a Linux distribution that runs Docker and AI tooling reliably for years, with as little hands-on maintenance as possible.

## Options considered

1. **Fedora.** SELinux enforcing by default and faster updates, but a new release to upgrade to roughly every year, and SELinux labels often get in the way of Docker volume mounts.
2. **Ubuntu 26.04 LTS.** Officially supported by Docker, assumed by most AI tooling guides, and given five years of free security updates.

## Decision

Use Ubuntu 26.04 LTS for docker-host, desk and sandbox.

## Consequences

- Copy-paste instructions from Docker and AI projects generally work as written.
- No major OS upgrade is needed for years, which suits always-on VMs.
- AppArmor is less granular than SELinux. Docker still applies its default AppArmor profile to every container, and that is combined with non-root containers, automatic security updates and LUKS.
