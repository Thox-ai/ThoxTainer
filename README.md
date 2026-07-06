<!-- thox-badges -->
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue?style=flat-square&labelColor=09090b)](LICENSE)
[![THOX.ai](https://img.shields.io/badge/THOX.ai-portfolio-0a0a0a?style=flat-square&labelColor=09090b)](https://thox.ai)
[![Status](https://img.shields.io/badge/status-active-brightgreen?style=flat-square&labelColor=09090b)](https://github.com/Thox-ai/ThoxTainer)
[![Release](https://img.shields.io/github/v/release/Thox-ai/ThoxTainer?style=flat-square&labelColor=09090b&logo=github)](https://github.com/Thox-ai/ThoxTainer/releases)
[![Last Commit](https://img.shields.io/github/last-commit/Thox-ai/ThoxTainer?style=flat-square&labelColor=09090b)](https://github.com/Thox-ai/ThoxTainer/commits/main)
[![Issues](https://img.shields.io/github/issues/Thox-ai/ThoxTainer?style=flat-square&labelColor=09090b)](https://github.com/Thox-ai/ThoxTainer/issues)
<!-- /thox-badges -->
<h1>
  <img alt="ThoxTainer logo" src="./assets/Containerization-Logo.png" width="70" valign="middle">
  &nbsp;ThoxTainer
</h1>

> **Fork Notice**: ThoxTainer is a fork of [Apple's `container`](https://github.com/apple/container) project, originally created for running Linux containers as lightweight VMs on Apple silicon Macs. We have renamed and extended it under the Thox.ai ecosystem to power **ThoxOS** — a family of minimal, secure, embedded Linux distributions (ThoxOS Mini, ThoxOS Air, and more) purpose-built for AI edge devices, robotics, and sovereign compute.

**ThoxTainer** is a tool for creating and running Linux containers as lightweight virtual machines on your Mac. It's written in Swift, and optimized for Apple silicon. It forms the foundation for building, packaging, and running ThoxOS kernels and minimal VMs with strong isolation.

The tool consumes and produces [OCI-compatible container images](https://github.com/opencontainers/image-spec), so you can pull and run images from any standard container registry. You can push images that you build to those registries as well.

ThoxTainer uses the [ThoxContainerization](../ThoxContainerization) (forked from Apple's Containerization) Swift package for low-level container, image, kernel, and process management.

![introductory movie showing some basic commands](./docs/assets/landing-movie.gif)

## ThoxOS Vision

ThoxTainer + ThoxContainerization enables the ThoxOS line of embedded Linux systems:

- **ThoxOS Mini** — Ultra-minimal kernel + init for secure AI inference edges
- **ThoxOS Air** — Lightweight air-gapped / offline-first variant
- **ThoxOS Custom** — Tailored kernels for robotics, medical, defense, and industrial use cases

We customize the Linux kernel (see `ThoxContainerization/kernel/`), vminitd, and VM runtime specifically for these workloads while preserving OCI compatibility and the excellent fast-boot lightweight VM model from Apple.

See [docs/THOXOS.md](./docs/THOXOS.md) for the full vision.

**Next Step**: If you want to start packaging real ThoxOS family projects as images right now, read the new practical guide:

→ **[docs/QUICKSTART-THOXOS-FAMILY.md](./docs/QUICKSTART-THOXOS-FAMILY.md)**

It covers workflows for:
- thoxos-mini-mobile
- thoxos-companion
- thoxos-mini-portable
- thox-agentic-os (ThoxAOS)
- thoxos-desktop

## Get started

### Requirements

You need a Mac with Apple silicon (M-series) and macOS 26+ to run **thox**. To build from source, see the [BUILDING](./BUILDING.md) document.

ThoxTainer is currently in active development as a fork. Pre-built signed installers for ThoxTainer will be provided via Thox.ai releases (not Apple' s). For now, build from source.

### Quick Start (from source)

```bash
# In this repo
make all
# Then run directly or install
./.build/release/thox --help
```

Start the system service (note: service/launchd names still reference container during early fork porting):

```bash
thox system start
```

> **Note on installation**: The original `container system start` / install scripts and launchd plists use `com.apple.container` identifiers. We are adapting these for `ai.thox.thoxtainer` in subsequent work. See `scripts/` and `Sources/ContainerPlugin/`.

### Development & Custom Kernels

For ThoxOS kernel development:

```bash
cd ../ThoxContainerization
make fetch-default-kernel   # or build custom ThoxOS kernels
make all
```

See the kernel customization guide in `ThoxContainerization/kernel/README.md`.

## Next steps

- Take [a guided tour](./docs/tutorial.md) (adapted from original) by building, running, and publishing a simple web server image with `thox`.
- Learn how to [use various ThoxTainer features](./docs/how-to.md).
- Read the [technical overview](./docs/technical-overview.md) (original design preserved).
- Browse the [full command reference](./docs/command-reference.md) (commands now under `thox`).
- [Build from source](./BUILDING.md).
- Explore ThoxOS kernel work in the sibling [ThoxContainerization](../ThoxContainerization) repo.

## Documentation

| Document                    | Purpose                                                                 |
|-----------------------------|-------------------------------------------------------------------------|
| [FORK.md](./docs/FORK.md)   | Fork philosophy, what changed, contribution policy vs upstream Apple   |
| [GETTING_STARTED.md](./docs/GETTING_STARTED.md) | Step-by-step guide from zero to first custom kernel                |
| [ARCHITECTURE.md](./docs/ARCHITECTURE.md) | Deep technical overview of the VM model + ThoxOS layers           |
| [KERNEL_GUIDE.md](./docs/KERNEL_GUIDE.md) | **Most important** — how to create ThoxOS Mini / Air / Custom kernels |
| [QUICKSTART-THOXOS-FAMILY.md](./docs/QUICKSTART-THOXOS-FAMILY.md) | **Next step** — Use ThoxTainer to build images for thoxos-mini-mobile, thoxos-companion, thoxos-mini-portable, thox-agentic-os, and thoxos-desktop |
| [THOXOS.md](./docs/THOXOS.md) | Vision for ThoxOS Mini, Air, Edge, and Custom product line         |
| [ROADMAP.md](./docs/ROADMAP.md) | Current status and future plans                                    |
| [BUILDING.md](./BUILDING.md) | How to build ThoxTainer and ThoxContainerization from source       |
| [CHANGELOG.md](./CHANGELOG.md) | Notable changes in this fork                                       |

Original Apple documentation (tutorial, how-to, command reference, etc.) is still present in `docs/` and remains useful, with the main difference being that the command is now `thox` instead of `container`.

## Contributing to ThoxTainer

ThoxTainer is developed as part of the Thox.ai / NeuralQuantum.ai ecosystem. 

- For ThoxOS-specific features (new kernels, vminitd extensions, ThoxOS Mini/Air build pipelines), contribute here or in ThoxContainerization.
- Upstream improvements that benefit the original model should be contributed back to https://github.com/apple/container where appropriate.
- See [CONTRIBUTING.md](./CONTRIBUTING.md) and the original guide in the Containerization fork.

## Project Status

This is an early-stage fork. We are preserving the excellent per-container lightweight VM architecture from Apple while adding ThoxOS-specific kernel profiles, embedded tooling, and AI/edge optimizations. Stability guarantees follow the upstream until we stabilize our 1.0 line.

## Fork Notice and Legal

ThoxTainer is a fork of Apple's `container` project, extended by Thox.ai LLC to
power ThoxOS (ThoxOS Mini, ThoxOS Air, and custom embedded Linux distributions).
Apple's original Apache 2.0 license and copyrights are preserved in
[LICENSE](LICENSE) and [NOTICE.md](NOTICE.md).

THOX-specific contributions (ThoxOS kernels, custom vminitd, ThoxOS build
tooling, branding, and extensions) are:

Copyright (c) 2026 Thox.ai LLC. All rights reserved.

Thox.ai LLC is an independent Texas limited liability company.

- **Tommy Xaypanya** - Chief Technology Officer (CTO)
- **Craig Ross** - Chief Executive Officer (CEO)

Licensed under the [Apache License, Version 2.0](LICENSE).