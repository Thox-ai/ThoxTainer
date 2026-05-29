# Fork History & Relationship to Apple Container

## Overview

**ThoxTainer** is a downstream fork of Apple's open source [container](https://github.com/apple/container) project (and its companion library [containerization](https://github.com/apple/containerization)).

We deeply respect the original work. Apple's per-container lightweight virtual machine architecture (built on Virtualization.framework + an optimized Linux kernel + `vminitd`) is one of the most elegant and secure ways to run Linux workloads on Apple silicon.

Our goal is **not** to compete with or replace the upstream project. Instead, we are extending it to power **ThoxOS** — a family of minimal, secure, purpose-built embedded Linux distributions (ThoxOS Mini, ThoxOS Air, ThoxOS Edge, and custom variants) for AI edge devices, robotics, industrial systems, and sovereign compute.

## What We Changed

### Naming & Branding
- CLI binary and primary command renamed from `container` → **`thox`**
- Project name: `ThoxTainer`
- Library package: `ThoxContainerization`
- Reverse domain identifiers updated to `ai.thox.*` (in progress)

### Documentation & Positioning
- Added clear fork notices everywhere
- Created ThoxOS-specific documentation (`THOXOS.md`, `KERNEL_GUIDE.md`, `ARCHITECTURE.md`, etc.)
- Updated all user-facing examples to use `thox`

### Build & Development
- `Package.swift` now references the sibling local `ThoxContainerization` by default for rapid kernel iteration
- Added ThoxOS kernel profile support (work in progress)

### What We Have **Not** Changed (Yet)
- Core architecture (lightweight per-VM containers)
- Most internal library names (`Containerization`, `ContainerCommands`, etc.)
- The majority of the original source code and comments

We intentionally kept the internal surface similar to make it easier to contribute improvements back upstream and to perform periodic rebases.

## Contribution Philosophy

| Type of Change                        | Recommended Destination          | Notes |
|---------------------------------------|----------------------------------|-------|
| Bug fixes in core VM / runtime        | Upstream (Apple) + ThoxTainer    | We will forward-port or send PRs |
| New OCI / container features          | Upstream first                   | Then pull into ThoxTainer |
| ThoxOS-specific kernel configs        | This repo (`ThoxContainerization/kernel/`) | e.g. `config-ThoxOS-Mini` |
| `vminitd` extensions for Thox control plane | This repo                     | Attestation, model serving, fleet mgmt |
| `thox os` commands & ThoxOS tooling   | This repo                        | `thox os build`, `thox kernel`, etc. |
| Branding, docs, marketing             | This repo                        | — |

We will actively send high-quality, generally useful patches upstream to Apple.

## Repository Layout (Thox Fork)

```
/Volumes/VibeStore/
├── ThoxTainer/                 ← This repo (CLI, services, installers)
│   └── docs/
│       ├── THOXOS.md
│       ├── FORK.md             ← You are here
│       ├── KERNEL_GUIDE.md
│       └── ...
└── ThoxContainerization/       ← Core library + kernel (sibling repo)
    └── kernel/
        ├── config-arm64        ← Upstream baseline
        ├── config-ThoxOS-Mini  ← (planned)
        └── config-ThoxOS-Air   ← (planned)
```

## License

All original Apple code remains under the Apache 2.0 license.

New code contributed under the ThoxTainer / ThoxContainerization repositories (ThoxOS kernel profiles, custom vminitd extensions, `thox os` tooling, documentation, etc.) is also Apache 2.0 unless otherwise noted in individual files.

See [NOTICE.md](../NOTICE.md) for full attribution.

## Questions?

- General ThoxOS / ThoxTainer questions: team@thox.ai
- Upstream contributions: Open issues/PRs on Apple's repositories and mention `@thox-ai` if relevant.

We are grateful to Apple for open-sourcing this excellent foundation.
