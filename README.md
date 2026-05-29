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

See [docs/THOXOS.md](./docs/THOXOS.md) (to be created) for the roadmap.

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

## Contributing to ThoxTainer

ThoxTainer is developed as part of the Thox.ai / NeuralQuantum.ai ecosystem. 

- For ThoxOS-specific features (new kernels, vminitd extensions, ThoxOS Mini/Air build pipelines), contribute here or in ThoxContainerization.
- Upstream improvements that benefit the original model should be contributed back to https://github.com/apple/container where appropriate.
- See [CONTRIBUTING.md](./CONTRIBUTING.md) and the original guide in the Containerization fork.

## Project Status

This is an early-stage fork. We are preserving the excellent per-container lightweight VM architecture from Apple while adding ThoxOS-specific kernel profiles, embedded tooling, and AI/edge optimizations. Stability guarantees follow the upstream until we stabilize our 1.0 line.
