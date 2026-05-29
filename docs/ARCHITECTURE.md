# ThoxTainer Architecture

This document explains how ThoxTainer and ThoxOS are built on top of Apple's lightweight container VM model.

## Core Philosophy

Apple's original insight (preserved and extended in ThoxTainer):

> **Each Linux container should run inside its own dedicated, minimal virtual machine.**

This gives you:
- Strong isolation (VM boundary instead of just namespaces/cgroups)
- Excellent security properties on Apple silicon
- Very fast boot times (< 1 second possible with optimized kernels)
- Reasonable memory overhead compared to traditional VMs

ThoxTainer adds the ability to treat these lightweight VMs as first-class **embedded operating system images** (ThoxOS Mini, Air, etc.).

## High-Level Layers

```
macOS Host
├── ThoxTainer (thox CLI + background services)
│   ├── ContainerCommands
│   ├── ContainerAPIService
│   └── ...
│
├── ThoxContainerization (Swift library)
│   ├── Containerization (high-level APIs)
│   ├── vminitd (init inside the VM)
│   └── Kernel images (customizable)
│
└── Virtualization.framework (Apple)
    └── Lightweight VM per container / ThoxOS instance
        └── Custom Linux kernel (ThoxOS profile)
            └── vminitd (gRPC over vsock)
                └── Workload (OCI container or native ThoxOS binary)
```

## Key Components

### 1. ThoxTainer CLI (`thox`)

The user-facing tool. Currently mostly inherits behavior from the Apple `container` CLI, with the command renamed to `thox`.

Planned ThoxOS-specific subcommands:
- `thox os build`
- `thox os run`
- `thox kernel`
- `thox attest`

### 2. ThoxContainerization

The heart of the system. This is where most ThoxOS-specific innovation will happen.

Notable pieces:
- `Sources/Containerization/LinuxContainer.swift`
- `kernel/` directory — home of all ThoxOS kernel configs
- `vminitd/` — the tiny init system that runs first inside every VM

### 3. vminitd

A minimal init written in Swift that speaks gRPC over vsock.

Responsibilities:
- Receive configuration from the host
- Set up networking, mounts, cgroups
- Spawn the actual container process or ThoxOS service
- Stream logs, signals, and exit status back to the host

ThoxOS will extend `vminitd` with:
- Attestation hooks
- Model registry integration
- Secure update mechanisms
- Hardware sensor / actuator passthrough for robotics/edge use cases

### 4. The Kernel

This is the biggest area of differentiation for ThoxOS.

Upstream provides a single, well-tuned `config-arm64`.

ThoxOS will maintain a family of profiles:

| Profile            | Goal                              | Size Target | Key Customizations                     |
|--------------------|-----------------------------------|-------------|----------------------------------------|
| `config-ThoxOS-Mini` | Ultra-minimal AI edge            | < 20MB     | No USB, minimal FS, strong crypto only |
| `config-ThoxOS-Air`  | Air-gapped / high-security       | < 30MB     | No network drivers by default, audit   |
| `config-ThoxOS-Edge` | Real-time robotics / industrial  | Variable   | PREEMPT_RT, CAN, deterministic timers  |
| `config-ThoxOS-Custom` | Your exact requirements        | —          | Whatever you need                      |

See [KERNEL_GUIDE.md](./KERNEL_GUIDE.md) for how to create and build these.

## Networking Model

Each ThoxOS / container VM gets its own virtual network interface with a dedicated IP (no port forwarding dance required in most cases).

This model is inherited directly from Apple and works extremely well for both development and production edge deployments.

## Security Model (Current + Future)

**Today (inherited):**
- VM-level isolation
- Read-only rootfs options
- vsock for host-guest communication (no TCP surface)

**ThoxOS additions (roadmap):**
- Measured boot + remote attestation
- Signed kernel + initrd + rootfs
- SEP-backed key storage for update signing
- Runtime integrity monitoring inside vminitd
- Optional TPM 2.0 / fTPM emulation for virtualized environments

## Why Not Just Use Docker Desktop / Lima / Colima?

| Property                    | Docker Desktop / Lima | ThoxTainer + ThoxOS |
|----------------------------|-----------------------|---------------------|
| Isolation boundary         | Usually one shared VM | One VM per container / OS instance |
| Boot time                  | Seconds               | Sub-second possible |
| Memory overhead            | High                  | Very low            |
| Kernel customization       | Difficult             | First-class goal    |
| Apple silicon optimization | Good                  | Excellent (native)  |
| Embedded / air-gapped use  | Not designed for it   | Primary use case    |

## Development Workflow (Recommended)

1. Work on kernel changes in `ThoxContainerization/kernel/`
2. Build the kernel
3. Use the resulting `vmlinux` from `ThoxTainer` (via future `thox kernel use` or manual flags)
4. Iterate on vminitd or host-side tooling in parallel
5. Rebase periodically against Apple's upstream

## Further Reading

- Apple's original [technical overview](https://github.com/apple/container/blob/main/docs/technical-overview.md)
- `ThoxContainerization/kernel/README.md`
- [KERNEL_GUIDE.md](./KERNEL_GUIDE.md) in this repo
- Source: `ThoxContainerization/Sources/Containerization/LinuxContainer.swift`

This architecture gives us the best of both worlds: world-class VM isolation from Apple + deep customizability needed for real embedded Linux products.
