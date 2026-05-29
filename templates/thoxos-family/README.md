# ThoxOS Family Starter Templates

This directory contains starter templates for building OCI images and future ThoxTainer-managed ThoxOS images for the full ThoxOS product line.

## Purpose

These templates are designed to be used with:

- Current ThoxTainer (`thox run`, custom kernels)
- Future `thox os build` tooling

They provide a consistent structure across all ThoxOS variants so that teams working on different form factors (Mobile, Companion, Portable, Agentic, Desktop) can share the same image-building patterns.

## Directory Layout

```
templates/thoxos-family/
├── thoxos-mini-mobile/
├── thoxos-companion/
├── thoxos-mini-portable/
├── thox-agentic-os/          # Special: contains both agent runtime + ThoxOS Air shim
├── thoxos-desktop/
└── README.md                 # This file
```

## How to Use (Current State)

1. Copy the relevant folder into your target project (e.g. `thoxos-mini-mobile/`).
2. Customize the `Dockerfile` and `.toml`.
3. Build with Docker or BuildKit.
4. Run the resulting image using ThoxTainer + a matching kernel profile from `ThoxContainerization`.

Example:

```bash
cd templates/thoxos-family/thoxos-mini-mobile
docker build -t thoxos-mini-mobile:dev .
thox run --kernel ../../../ThoxContainerization/kernel/build/ThoxOS-Mini/vmlinux thoxos-mini-mobile:dev
```

## The `.toml` Config Files

The `thoxos-*.toml` files define a future declarative format for `thox os build`.

They are intentionally simple today so we can evolve the schema as the `thox os` tooling is implemented.

Key fields (proposed):
- `profile` — ThoxOS kernel profile to use (mini, air, edge, desktop, companion, etc.)
- `base` — Base image or rootfs strategy
- `packages` / `features`
- `entrypoint`
- `kernel_overrides`
- `signing`

## Special Case: thox-agentic-os

This folder contains **two** Dockerfiles + a combined `.toml`:

- `Dockerfile.agent-runtime` — Packages the Rust agent runtime, bridges, and userspace components from ThoxAgenticOS as an OCI image.
- `Dockerfile.thoxos-air-shim` — Builds the embedded Linux side (ThoxOS Air) that meshes with full ThoxAOS nodes.
- `thox-agentic-os.toml` — Declares both build variants.

**Strongly recommended**: Read the greatly expanded dedicated section in  
`docs/QUICKSTART-THOXOS-FAMILY.md` → “4.4 thox-agentic-os (ThoxAOS) — Packaging as OCI Images”.

This is currently one of the highest-value use cases for ThoxTainer.

## Contributing

When a new ThoxOS family member is created, add a new subdirectory here following the existing pattern.

Update this README and the main Quickstart guide.

## Status

These are **starter / living templates**. They will be refined as real projects (`thoxos-mini-mobile`, etc.) publish their build requirements.

Last updated: May 2026
