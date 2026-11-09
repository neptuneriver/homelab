# Backups

Every VM is backed up weekly to a different machine, Home Assistant backs itself up daily, the UniFi console backs up its own settings, and both Macs use Time Machine.

| What | Tool | Destination | Frequency | Keep |
| --- | --- | --- | --- | --- |
| Home Assistant config | Home Assistant automatic backups (encrypted) | Home Assistant, plus a copy on the laptop | Daily | 7 |
| Home Assistant VM | Proxmox backup | `proxmox-backups` share on the Mac mini | Weekly | 4 |
| docker-host and desk | Proxmox backup, snapshot mode | `proxmox-backups` share on the Mac mini | Weekly | 4 |
| Laptop and Mac mini | Time Machine | Separate external drive | Hourly | Automatic |
| UniFi settings | UniFi automatic backups | UniFi cloud, plus a downloaded copy | Automatic, plus before big changes | Automatic |

## Set up the Proxmox backup target

1. On the Mac mini, create a `proxmox-backups` folder on an external SSD.
2. Create a **Sharing Only** user named `backup` that can access nothing else.
3. Share the folder over SMB to that user: System Settings > General > Sharing > File Sharing.
4. On each Proxmox host, go to Datacenter > Storage > Add > SMB/CIFS. Use the Mac mini's LAN IP, the `proxmox-backups` share and the `backup` user, with content set to backups.
5. Go to Datacenter > Backup > Add. Select the VMs, schedule it weekly, and use snapshot mode with ZSTD compression. Under Retention, keep the last 4.

## Test your restores

A backup you have never restored is a hope, not a backup. Once a month, or after any big change, restore one VM to a new VM ID, boot it, check it, then delete it. The steps are in [recovery](recovery.md#restore-a-vm-from-backup).

## Known gaps

- **No offsite copy yet.** A fire or theft at home takes everything. An encrypted cloud copy is on the roadmap.
- **Host configs are not backed up separately.** They are small and can be rebuilt from this repo.
- **Snapshots are not backups.** They live on the same disk as the VM.
- **Camera footage is not backed up.** It lives only on the gateway's single drive.
