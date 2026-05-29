# Quickstart: Building ThoxOS Family Images with ThoxTainer

**Goal**: Use **ThoxTainer** as the universal image builder and Apple Silicon development/runtime platform for the entire ThoxOS product family.

This guide shows the current (and near-future) workflow for turning the following projects into runnable images:

- **thoxos-mini-mobile** — Ultra-compact ThoxOS for phones and small mobile form factors
- **thoxos-companion** — Companion OS/runtime for watches, earbuds, and secondary devices
- **thoxos-mini-portable** — Battery-powered portable devices (handhelds, field units)
- **thox-agentic-os** (ThoxAOS) — Flagship bare-metal Rust agent-native microkernel (uses ThoxOS Air as the embedded Linux shim)
- **thoxos-desktop** — Full desktop / workstation experience

---

## 1. The Role of ThoxTainer

ThoxTainer + ThoxContainerization gives you:

- Custom minimal Linux kernels (ThoxOS Mini / Air / Edge profiles)
- Extremely fast-booting lightweight VMs on Apple Silicon (via Virtualization.framework)
- OCI-compatible image building and running
- A clean path from "source repo" → bootable ThoxOS image → running VM on your Mac

This makes ThoxTainer the **preferred development platform** for all ThoxOS variants while you iterate on Apple Silicon Macs.

---

## 2. Prerequisites

```bash
# 1. ThoxTainer + ThoxContainerization built
cd /Volumes/VibeStore/ThoxTainer
make all

cd ../ThoxContainerization
make all

# 2. At least one baseline kernel
make fetch-default-kernel
# OR build custom profiles (see docs/KERNEL_GUIDE.md)
```

---

## 3. General Workflow (Today → Near Future)

| Step | Today (Manual)                          | Near Future (`thox os` commands)              |
|------|-----------------------------------------|-----------------------------------------------|
| 1    | Clone target ThoxOS repo                | `thox os create --project thoxos-mini-mobile` |
| 2    | Select or build appropriate kernel      | `thox kernel use mini` or `--profile air`     |
| 3    | Package rootfs / initramfs              | `thox os build`                               |
| 4    | Run as lightweight VM                   | `thox os run` or `thox run --thoxos`          |
| 5    | Iterate (kernel + userspace)            | Hot-reload + live kernel swap                 |

---

## 4. Project-Specific Quickstarts

### 4.1 thoxos-mini-mobile

**Target form factor**: Smartphones, small tablets, portable AI companions.

**Intended kernel profile**: `ThoxOS Mini` (or a mobile-tuned variant).

**Current workflow**:

```bash
git clone https://github.com/ttracx/thoxos-mini-mobile.git
cd thoxos-mini-mobile

# Build the userspace / agent runtime for the device
# (project-specific build instructions go here once repo is public)

# Package as OCI image (recommended for iteration)
docker build -t thoxos-mini-mobile:latest .

# Run on Apple Silicon using ThoxTainer (lightweight VM)
thox run --rm \
  --kernel ../ThoxContainerization/kernel/build/ThoxOS-Mini/vmlinux \
  thoxos-mini-mobile:latest \
  /usr/bin/thox-init
```

**Future ideal command** (once `thox os` lands):

```bash
thox os build --project thoxos-mini-mobile --profile mini --arch arm64
thox os run thoxos-mini-mobile --device mobile-sim
```

---

### 4.2 thoxos-companion

**Target form factor**: Wearables, earbuds, companion modules, always-on sensors.

**Characteristics**: Extremely small footprint, aggressive power management, MeshStack™ client.

**Recommended kernel**: Highly stripped `ThoxOS Air` or custom `ThoxOS Companion` profile.

**Workflow**:

```bash
git clone https://github.com/ttracx/thoxos-companion.git
cd thoxos-companion

# Build companion runtime (usually Rust + minimal C)
cargo build --release --target aarch64-unknown-linux-musl

# Create minimal rootfs
# ...

# Run in ThoxTainer for development & testing
thox run \
  --kernel ../ThoxContainerization/kernel/build/ThoxOS-Air/vmlinux \
  --memory 128M \
  --cpu 1 \
  thoxos-companion:latest
```

**Key testing benefit**: You can simulate companion <-> main device MeshStack communication entirely on your Mac using multiple ThoxTainer VMs.

---

### 4.3 thoxos-mini-portable

**Target**: Handheld devices, field kits, battery-powered AI tools.

**Typical needs**: Good balance of size vs capability, real-time sensor support, offline-first.

**Recommended profile**: `ThoxOS Mini` or `ThoxOS Edge` (if real-time I/O is needed).

**Workflow** similar to above, plus:

```bash
# Example: enable sensor simulation when running in ThoxTainer
thox run \
  --kernel .../ThoxOS-Mini/vmlinux \
  --device /dev/sensors:host:/dev/input/js0 \
  thoxos-mini-portable:latest
```

---

### 4.4 thox-agentic-os (ThoxAOS) — Special Case

This is the **flagship bare-metal Rust microkernel** project.

See: https://github.com/ttracx/thox-agentic-os

It already has an explicit relationship with ThoxOS:

- **ThoxOS Air** is documented as the embedded Linux path for ThoxMini-class edge devices.
- The Rust microkernel (ThoxAOS) is the "full agent-native OS".
- ThoxMigrate™ shim provides classic ThoxOS compatibility.

**How ThoxTainer fits today**:

1. **Development host + test runner**
   - Use ThoxTainer VMs to run QEMU/HVF instances of ThoxAOS during development.
   - Package the agent runtime (thoxa, meshstack, nullclaw, etc.) as OCI images.

2. **ThoxOS Air shim builder**
   - Use ThoxTainer + custom `ThoxOS Air` kernel to build the embedded Linux side that meshes with full ThoxAOS nodes.

**Example current workflow**:

```bash
# In Thox-agentic-os repo
./scripts/build.sh --release

# Run the QEMU image inside a ThoxTainer-managed environment (future)
thox run \
  --kernel ../ThoxContainerization/kernel/build/ThoxOS-Air/vmlinux \
  --memory 2G \
  ghcr.io/ttracx/thox-agentic-os:latest
```

**Long-term vision**:
- `thox os build --project thox-agentic-os --variant air` produces the Linux shim image.
- `thox os build --project thox-agentic-os --variant native` produces artifacts consumable by the Rust microkernel build.

---

### 4.5 thoxos-desktop

**Target**: Workstations, creative machines, high-end developer laptops, MagStack™ nodes.

**Characteristics**: Richer userspace, windowing (windowd), desktop apps, full MeshStack + agent teams, more permissive kernel profile.

**Recommended kernel**: `ThoxOS Desktop` (future profile) or a less-stripped `ThoxOS Edge/Custom`.

**Workflow**:

```bash
git clone https://github.com/ttracx/thoxos-desktop.git
cd thoxos-desktop

# Build full desktop environment + agents
# ...

# Run full desktop experience in a ThoxTainer VM on your Mac
thox run \
  --kernel ../ThoxContainerization/kernel/build/ThoxOS-Desktop/vmlinux \
  --memory 8G --cpus 8 \
  --gui \
  thoxos-desktop:latest
```

This is the best way to dogfood the full ThoxOS Desktop experience while developing on Apple Silicon.

---

## 5. Recommended Directory Layout (for ThoxOS Family Work)

```
/Volumes/VibeStore/
├── ThoxTainer/                    # ← Image builder + runtime
├── ThoxContainerization/          # ← Kernels + vminitd
├── thoxos-mini-mobile/
├── thoxos-companion/
├── thoxos-mini-portable/
├── thox-agentic-os/               # Major Rust microkernel project
├── thoxos-desktop/
└── thoxos-images/                 # Output artifacts (OCI + raw images)
```

---

## 6. Future `thox` Commands (Target UX)

Once the `thox os` subcommand family is implemented, the experience will become:

```bash
# One-command image build for any family member
thox os build \
  --project thoxos-mini-mobile \
  --profile mini \
  --arch arm64 \
  --output thoxos-images/thoxos-mini-mobile.oci

# Run with device emulation
thox os run thoxos-mini-mobile --profile mobile-sim

# Cross-build for actual hardware
thox os build --project thoxos-mini-portable --profile edge --target aarch64
```

---

## 7. Next Actions for You Right Now

1. **Clone the public one**:
   ```bash
   git clone https://github.com/ttracx/thox-agentic-os.git
   ```

2. **Read its ThoxOS Air documentation**:
   - `docs/thoxos-air.md` inside that repo

3. **Start building a `config-ThoxOS-Mini-Mobile`** kernel profile (see `docs/KERNEL_GUIDE.md`).

4. **Experiment** running the current ThoxAgenticOS QEMU images inside ThoxTainer-managed VMs.

5. Once the other four repos become available, repeat the pattern above.

---

## 8. Contributing Back

Improvements to the image-building workflow, new kernel profiles for specific form factors, or vminitd extensions that benefit any of the ThoxOS family members should be contributed here (ThoxTainer / ThoxContainerization).

Pure agent logic, Rust microkernel work, and desktop UI work belongs in the respective project repositories.

---

**This document is the current "North Star" guide for using ThoxTainer as the image layer for the entire ThoxOS ecosystem.**

Last updated: May 2026
Maintained by the Thox.ai Platform team.
