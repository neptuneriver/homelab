# ADR 0009: Hardware security keys for MFA

- **Status:** Accepted
- **Date:** 2026-11-09

## Context

Every admin surface (two Proxmox hosts, Cloudflare and the identity provider behind Tailscale) needs a second factor. App-based TOTP codes can be phished. Hardware keys using WebAuthn can't, because the key checks which site is asking.

## Decision

Use hardware security keys with WebAuthn wherever a service supports it, with two keys registered on every account. Where a service only offers TOTP, as Home Assistant does, store the TOTP secret on both keys with Yubico Authenticator. Recovery codes go in the password manager.

## Consequences

- Logins resist phishing.
- **Proxmox needs extra setup.** WebAuthn only works on a hostname with a trusted certificate, so each node gets a certificate for its Tailscale name from `tailscale cert`, renewed by cron ([script](../../scripts/proxmox-tailscale-cert.sh)).
- When a node is reached by IP address, WebAuthn won't work, and login falls back to recovery keys.
- The backup key has to be registered everywhere at the same time as the primary, or losing one key becomes a lockout.
- Losing a key follows a [runbook](../recovery.md#lost-a-hardware-key).
