# Hardware

| Node | Model | CPU | Memory | Storage | Notable I/O |
| --- | --- | --- | --- | --- | --- |
| Laptop | MacBook | Apple Silicon | | | |
| House | Acemagic mini PC | Intel N150, 4 E-cores / 4 threads, 6 W | 16 GB, single channel | 256 GB SSD | Ethernet |
| Lab | Minisforum X1 Lite | AMD Ryzen 7 255, 8 cores / 16 threads, up to 4.9 GHz, Radeon 780M | 32 GB DDR5-5600 (2 x 16 GB SO-DIMM) | 1 TB NVMe PCIe 4.0 | 2.5 GbE, Wi-Fi 6E, USB4, OCuLink |
| AI | Mac mini (2026) | Apple M6 | 32 GB unified, 170 GB/s | Internal SSD + external SSD for backups | Ethernet |

## Notes by node

### Lab node

- Both SO-DIMM slots are filled with 16 GB sticks. Upgrading means replacing both, up to 128 GB total.
- The bundled M.2-to-OCuLink adapter occupies the second M.2 slot. Keep it installed only if an external GPU is planned. Otherwise, reclaim the slot for a second SSD.
- OCuLink is not hot-swappable. Power off before connecting or disconnecting a GPU dock.
- The Ryzen 7 255 is a rebadged Ryzen 7 8845HS (Zen 4, "Hawk Point") with no NPU. This chip family has reports of Xen IOMMU crashes at boot, one reason Qubes OS was ruled out ([ADR 0003](decisions/0003-qubes-os-rejected.md)). KVM, which Proxmox uses, runs fine.

### House node

- 16 GB is the N150's memory ceiling, and it runs single-channel. That is plenty for Home Assistant and a few small containers, not for heavy virtualization ([ADR 0004](decisions/0004-home-assistant-stays-on-house-node.md)).

### AI node

- 32 GB is the M6's maximum. A common rule of thumb is that about 70% of unified memory is usable for model weights plus context.

## Network

UniFi throughout: a Dream Machine Pro gateway, a Pro 24 PoE switch, four U7 access points, six Protect devices and an Access Hub. Models, power draw and link speeds are in [network](network.md).

## Power

- Every node powers on by itself after an outage. On the PCs, set **Restore on AC Power Loss** (sometimes **State After G3**) to **Power On** in the BIOS. On the Mac mini, turn on **Start up automatically after a power failure** in System Settings > Energy.
- The lab node and the Mac mini sit on smart plugs that Home Assistant controls, for a last-resort remote power cycle. The house node never does, since it runs Home Assistant.

## References

- [Minisforum X1 Lite](https://store.minisforum.com/products/minisforum-x1-lite)
- [Intel N150 specifications and benchmarks](https://www.notebookcheck.net/Intel-Processor-N150-Processor-Benchmarks-and-Specs.951351.0.html)
- [Ryzen 7 255 as a rebadged 8845HS](https://www.notebookcheck.net/Minisforum-launches-AMD-powered-X1-Lite-as-new-affordable-mini-PC-with-eGPU-support.1162617.0.html)
- [Mac mini M6 model sizing for local LLMs](https://www.besthub.dev/articles/mac-mini-m6-llm-guide-32gb-ram-170gb-s-bandwidth-model-sizing-software-a06ca1de1f58)
