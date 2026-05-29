# Changelog — ThoxTainer

All notable changes to this fork will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) (while still in 0.x).

---

## [Unreleased]

### Added

- Initial fork of Apple's `container` project as **ThoxTainer**
- CLI binary renamed from `container` → `thox`
- Sibling repository `ThoxContainerization` (fork of `apple/containerization`)
- Comprehensive documentation:
  - `docs/FORK.md` — fork philosophy and contribution policy
  - `docs/GETTING_STARTED.md`
  - `docs/ARCHITECTURE.md`
  - `docs/KERNEL_GUIDE.md` — the heart of ThoxOS kernel customization
  - `docs/ROADMAP.md`
  - `docs/THOXOS.md`
- Updated `README.md`, `BUILDING.md`, `NOTICE.md`, and `Makefile` for Thox branding
- Git remotes configured with `upstream` pointing at Apple and `origin` at `thox-ai`
- `Package.swift` wired to local `ThoxContainerization` for fast development
- User scripts renamed (`update-thox.sh`, `uninstall-thox.sh`)
- First successful build of the `thox` product after fork changes

### Changed

- All user-facing documentation and examples now use `thox` instead of `container`
- Logger labels and some internal identifiers updated to `ai.thox.*`
- Build system updated to support the new binary name while maintaining back-compat symlinks during transition

---

## [0.1.0] — Planned

- First public release of ThoxTainer + initial `config-ThoxOS-Mini` kernel
- `thox kernel` and `thox os` command families (MVP)
- Signed kernel support
- Public documentation site

---

## Upstream History

This project is a fork of:

- https://github.com/apple/container (main CLI and services)
- https://github.com/apple/containerization (core library and kernel)

All changes prior to the fork date are credited to Apple Inc. and the original project authors under the Apache 2.0 license.

See [NOTICE.md](NOTICE.md) and [docs/FORK.md](docs/FORK.md) for full details.

---

[Unreleased]: https://github.com/thox-ai/ThoxTainer/compare/v0.1.0...HEAD
