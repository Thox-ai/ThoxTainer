# ThoxTainer & ThoxOS Roadmap

## Vision

Build the best platform in the world for running secure, minimal, customizable Linux workloads on Apple silicon — with a specific focus on **embedded**, **edge AI**, **air-gapped**, and **sovereign** use cases.

ThoxTainer is the tooling and runtime layer.
ThoxOS is the family of operating system images built on top of it.

## 2026 Milestones (Current Focus)

### Q2 2026 — Foundation & First Usable ThoxOS Images

- [x] Successful fork + rename of Apple's container project → ThoxTainer
- [x] Local development workflow between ThoxTainer + ThoxContainerization
- [x] Comprehensive documentation (FORK, GETTING_STARTED, ARCHITECTURE, KERNEL_GUIDE)
- [ ] First `config-ThoxOS-Mini` kernel that boots reliably in < 2 seconds
- [ ] Basic `thox kernel` subcommands (list, install, use)
- [ ] `thox os build` prototype (kernel + minimal rootfs → bootable image)
- [ ] Public GitHub repositories under `thox-ai` org with clean history

### Q3 2026 — Developer Preview

- `thox os run --profile mini`
- Signed kernel + initrd support
- First version of ThoxOS Air profile (networking disabled by default)
- vminitd extensions for basic attestation
- Documentation site + example ThoxOS Mini reference image
- Early access program for selected hardware partners (robotics, industrial, defense)

### Q4 2026 — 0.1 Release

- Stable ThoxOS Mini 0.1
- Over-the-air update framework (prototype)
- Full CLI coverage (`thox os`, `thox kernel`, `thox attest`)
- Hardware enablement guide for common edge platforms
- Public reference hardware platform (or open reference design)

## Longer-Term Direction (2027+)

- ThoxOS Edge with PREEMPT_RT and real-time networking
- Multi-architecture support (beyond arm64 Apple silicon)
- Integration with Thox.ai model registry and inference runtime
- Confidential computing features leveraging Apple silicon capabilities
- Fleet management and zero-touch provisioning for ThoxOS devices
- Formal verification / high-assurance configurations for regulated industries

## Relationship to Upstream (Apple)

We intend to remain good citizens:

- Send high-quality patches upstream whenever they are generally useful
- Keep our internal APIs reasonably close to Apple's to ease rebasing
- Clearly document every intentional divergence

Our differentiation lives almost entirely in:
- Kernel configuration profiles
- vminitd extensions
- Higher-level ThoxOS tooling and image formats
- Documentation and reference implementations for embedded use cases

## How to Influence the Roadmap

- Open issues in this repository with the `roadmap` label
- Join the ThoxOS working group (email team@thox.ai)
- Contribute kernel profiles or vminitd features for your specific hardware/use case

## Versioning

- ThoxTainer follows a `0.x` versioning scheme while we stabilize the fork and add ThoxOS-specific features.
- Individual ThoxOS profiles (Mini, Air, etc.) will have their own semantic version numbers once they reach production readiness.

This document is intentionally high-level. Detailed engineering plans live in issues and the private ThoxOS working documents.
