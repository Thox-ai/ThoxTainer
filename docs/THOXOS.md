# ThoxOS — Embedded Linux with ThoxTainer

ThoxTainer (this repository) + [ThoxContainerization](../ThoxContainerization) is the build and runtime foundation for the **ThoxOS** family of minimal, secure, high-performance embedded Linux distributions optimized for Apple silicon Macs and (future) other edge hardware.

## Product Line

| Product       | Target Use Case                        | Kernel Profile          | Footprint | Key Features                          |
|---------------|----------------------------------------|-------------------------|-----------|---------------------------------------|
| **ThoxOS Mini** | AI inference edges, smart sensors     | Minimal + AI accel     | < 20MB   | Fast boot (<1s), signed updates, gRPC control plane |
| **ThoxOS Air**  | Air-gapped / offline / classified     | Hardened minimal       | < 30MB   | No network by default, TPM/SEP integration, audit logging |
| **ThoxOS Edge** | Robotics, industrial, medical         | Real-time + custom I/O | Variable | PREEMPT_RT, CAN bus, deterministic scheduling |
| **ThoxOS Custom** | Sovereign / defense / research      | Fully custom           | —        | Your kernel config + ThoxTainer runtime |

## Architecture

```
macOS (host)
└── ThoxTainer (thox CLI + services)
    └── per-container lightweight VM (Virtualization.framework + Apple silicon)
        └── ThoxOS kernel (customized from containerization/kernel)
            └── vminitd (Thox extensions)
                └── containerized workload (OCI image or native ThoxOS app)
```

## Key Customizations (Roadmap)

1. **Kernel**
   - Minimal config for sub-second boot + tiny memory
   - Built-in WireGuard, modern crypto, eBPF for observability (optional)
   - Thox-specific modules for model serving, sensor fusion, secure enclaves

2. **vminitd extensions**
   - Native support for Thox model registry
   - gRPC control surface for fleet management
   - Attestation + measured boot hooks

3. **ThoxTainer enhancements**
   - `thox os build` — produce ThoxOS Mini/Air images from kernel + rootfs
   - `thox os run` — launch as privileged lightweight VM (not just container)
   - `thox kernel` subcommands for profile management and cross-compile

4. **Security & Compliance**
   - Full chain of trust from macOS host → VM → workload
   - Integration with Apple SEP / keys for signing
   - SBOM + reproducible builds

## Getting Started with ThoxOS (Developers)

```bash
# 1. Build ThoxTainer + ThoxContainerization
cd /Volumes/VibeStore/ThoxTainer
make all

cd ../ThoxContainerization
make fetch-default-kernel   # baseline
# OR customize kernel/config-ThoxOS-Mini and build your own

# 2. Experiment with custom kernel in a container/VM
# (see kernel/README.md)

# 3. Future: once `thox os` commands land
thox os create --profile mini my-edge-device
thox os build my-edge-device
thox os run my-edge-device
```

## Relationship to Upstream

- We deeply respect and preserve the brilliant design of Apple's per-VM container model.
- All improvements that are generally useful (bug fixes, performance, new OCI features) will be contributed upstream.
- ThoxOS-specific kernel configs, vminitd extensions, and fleet/orchestration features remain Thox.ai proprietary or Apache-2.0 as decided per component.

## License & Contribution

See top-level [LICENSE](../LICENSE) and [NOTICE](../NOTICE.md).

For ThoxOS work, contact the team at Thox.ai / NeuralQuantum.ai.

---

*This document is the living spec for ThoxOS. Last updated: $(date +%Y-%m-%d)*