# ThoxOS Kernel Guide

This is the most important document for anyone doing serious work with ThoxTainer for embedded use cases.

## Why Custom Kernels Matter for ThoxOS

The default kernel that ships with Apple's container project is excellent for general development and running standard container workloads.

For **ThoxOS Mini**, **ThoxOS Air**, robotics, medical devices, defense, or air-gapped systems, you need precise control over:

- Which drivers and subsystems are compiled in vs. modules
- Crypto algorithms (FIPS vs modern only)
- Real-time capabilities (PREEMPT_RT)
- Attack surface (remove USB, FireWire, random filesystems, etc.)
- Boot time and memory footprint
- Hardware support for specific sensors/actuators

ThoxTainer + ThoxContainerization makes kernel customization a first-class, supported workflow.

## Directory Structure

```
ThoxContainerization/
└── kernel/
    ├── Makefile
    ├── build.sh
    ├── config-arm64                 ← Upstream baseline (good starting point)
    ├── image/
    │   └── Dockerfile               ← Containerized cross-compile environment
    └── README.md
```

## Creating a New ThoxOS Kernel Profile

### Step 1: Copy a Baseline

```bash
cd ThoxContainerization/kernel

# For a minimal AI/edge device
cp config-arm64 config-ThoxOS-Mini

# For high-security air-gapped use
cp config-arm64 config-ThoxOS-Air
```

### Step 2: Edit the Config

Use your favorite editor or `make menuconfig` inside the build container.

Key areas to review for ThoxOS profiles:

**Must-haves for all ThoxOS profiles**
- `CONFIG_VIRTIO_*=y` (all virtio drivers built-in, not modules)
- `CONFIG_VIRTIO_CONSOLE=y`
- `CONFIG_VIRTIO_NET=y`
- `CONFIG_VIRTIO_BLK=y`
- `CONFIG_VIRTIO_PCI=y`

**Typical Mini / Air reductions**
```diff
- CONFIG_USB_SUPPORT=y
- CONFIG_USB=y
- CONFIG_SOUND=y
- CONFIG_DRM=y
+ # Disable above for smaller attack surface + faster boot
```

**For ThoxOS-Air (extra hardening)**
- Remove most network drivers except virtio
- Disable module loading at runtime (`CONFIG_MODULES=n`)
- Enable only approved crypto algorithms
- Enable audit and integrity subsystems

**For ThoxOS-Edge / Robotics**
- Enable `PREEMPT_RT` (real-time patch)
- Enable CAN bus (`CONFIG_CAN_*`)
- Enable specific I2C/SPI/GPIO expanders your hardware needs
- Consider `CONFIG_HIGH_RES_TIMERS` and `CONFIG_NO_HZ_FULL`

### Step 3: Build the Kernel

From the `ThoxContainerization` directory:

```bash
# Build the default upstream kernel
make kernel

# Build a specific ThoxOS profile
make kernel PROFILE=ThoxOS-Mini

# Build with custom output directory
make kernel PROFILE=ThoxOS-Air OUTPUT_DIR=~/kernels/thox-air
```

The build runs inside a Docker container that has the correct cross-compiler toolchain and Linux source tree.

### Step 4: Locate the Output

After a successful build you will have:

```
kernel/build/<profile>/arch/arm64/boot/Image
kernel/build/<profile>/vmlinux          # Uncompressed, what you usually want
kernel/build/<profile>/System.map
```

For use with ThoxTainer / ThoxContainerization, you almost always want the uncompressed `vmlinux`.

## Using a Custom Kernel with ThoxTainer

As of the current state of the fork, kernel selection is still done at the library level (in `ThoxContainerization`).

Future CLI surface (planned):

```bash
thox kernel install --profile Mini vmlinux-ThoxOS-Mini
thox kernel list
thox run --kernel-profile Mini alpine:latest ...
thox os build --profile Air --kernel vmlinux-ThoxOS-Air
```

Until those commands exist, you can pass custom kernels when constructing `LinuxContainer` or `LinuxVM` instances in Swift code (see examples in `ThoxContainerization/Sources/cctl`).

## Recommended Minimal Config Additions for ThoxOS

These are good defaults for most ThoxOS variants:

```kconfig
# Fast boot + small footprint
CONFIG_CC_OPTIMIZE_FOR_SIZE=y

# Good security baseline
CONFIG_SECURITY=y
CONFIG_SECURITY_APPARMOR=y          # or your LSM of choice
CONFIG_INTEGRITY=y
CONFIG_IMA=y

# Modern crypto (adjust for FIPS/air-gapped requirements)
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_CHACHA20POLY1305=y

# Virtio is non-negotiable
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_VIRTIO_NET=y
CONFIG_VIRTIO_BLK=y
CONFIG_VIRTIO_RNG=y
```

## Testing a New Kernel

1. Build the kernel.
2. Use it to launch a simple container or ThoxOS initramfs.
3. Verify:
   - Boots in < 3 seconds (ideally < 1s)
   - Networking works
   - `dmesg` is clean (no missing virtio drivers)
   - Memory usage is reasonable (`free -h` inside the VM)

## Releasing / Distributing ThoxOS Kernels

For production ThoxOS devices you will want:

- Reproducible builds (pin the exact Linux tree + config + toolchain container)
- Cryptographic signing of the `vmlinux` (and later the full OS image)
- SBOM generation
- Versioning scheme (e.g. `thoxos-mini-6.14.9-2026.05`)

The `kernel/` build system can be extended to produce signed artifacts and metadata.

## Common Pitfalls

- Forgetting to build virtio drivers **into** the kernel (modules don't work at early boot)
- Accidentally enabling huge subsystems (sound, DRM, USB gadget, etc.)
- Using a kernel version that is too new or too old for the host's Virtualization.framework expectations (6.14.x range is currently well tested)

## Next Steps

- Read the upstream `kernel/README.md` in `ThoxContainerization`
- Look at real-world minimal configs from Kata Containers or Firecracker
- Start with `config-ThoxOS-Mini` and measure boot time + size aggressively
- When you're happy, upstream any generally useful improvements back to Apple's `config-arm64`

This capability — easily producing multiple, purpose-built, tiny, secure Linux kernels that boot in a fraction of a second inside dedicated VMs — is one of the most powerful differentiators of the ThoxTainer + ThoxOS platform.
