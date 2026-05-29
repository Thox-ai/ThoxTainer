# Getting Started with ThoxTainer & ThoxOS

This guide will get you from zero to running your first custom ThoxOS kernel inside a lightweight virtual machine using ThoxTainer.

## Prerequisites

- Apple silicon Mac (M1 or newer)
- macOS 26 or later (required for modern Virtualization.framework features)
- Xcode 26 or later
- Basic familiarity with Docker/OCI concepts and Linux kernel configuration is helpful but not required

## 1. Clone the Repositories

```bash
# Choose a location with plenty of space (full build + kernel sources are large)
cd /Volumes/VibeStore   # or ~/projects or wherever you work

git clone https://github.com/thox-ai/ThoxTainer.git
git clone https://github.com/thox-ai/ThoxContainerization.git
```

> **Important**: Keep both repositories as siblings. `ThoxTainer/Package.swift` is configured to use the local `../ThoxContainerization` by default for fast kernel development.

## 2. Build ThoxTainer (the `thox` CLI)

```bash
cd ThoxTainer

# Debug build (fast iteration)
swift build --product thox -c debug

# Or use make (also handles some initfs pieces)
make cli
```

The binary will be at:
```bash
.build/debug/thox
```

Create a convenient symlink for development:
```bash
mkdir -p ~/bin
ln -sf "$(pwd)/.build/debug/thox" ~/bin/thox
export PATH="$HOME/bin:$PATH"
```

Verify:
```bash
thox --version
thox --help
```

## 3. Build the Core Library (ThoxContainerization)

```bash
cd ../ThoxContainerization

# One-time setup for cross-compilation / static Linux SDK (if not already done)
make cross-prep

# Build the library + cctl tool
make all
```

## 4. Fetch or Build a Baseline Kernel

The easiest way to start is with the default optimized kernel from upstream:

```bash
cd ../ThoxContainerization
make fetch-default-kernel
```

This downloads a known-good `vmlinux` suitable for development.

## 5. Run Your First Container with `thox`

```bash
# Pull a small image
thox image pull alpine:latest

# Run it
thox run --rm alpine:latest echo "Hello from ThoxTainer!"
```

At this point you are running the same excellent lightweight VM model as Apple's original `container` tool, but under the `thox` command.

## 6. Start Working with ThoxOS Kernels (The Real Goal)

This is where ThoxTainer diverges from the upstream.

1. Go to the kernel directory:
   ```bash
   cd ../ThoxContainerization/kernel
   ```

2. Study the existing config:
   ```bash
   cat config-arm64
   ```

3. Create your first ThoxOS profile (example):
   ```bash
   cp config-arm64 config-ThoxOS-Mini
   # Edit config-ThoxOS-Mini with your minimal + AI/edge focused options
   ```

4. Build the custom kernel (see [KERNEL_GUIDE.md](./KERNEL_GUIDE.md) for full details):
   ```bash
   # From ThoxContainerization root
   make kernel PROFILE=ThoxOS-Mini
   ```

5. Use the resulting kernel with ThoxTainer (future `thox kernel` commands will make this smoother).

## Common First-Day Commands

| Command                              | Purpose                              |
|--------------------------------------|--------------------------------------|
| `thox --help`                        | See all top-level commands           |
| `thox system start`                  | Start the background services        |
| `thox image pull <ref>`              | Pull an OCI image                    |
| `thox run --rm <image> <cmd>`        | Run a container (lightweight VM)     |
| `thox kernel list`                   | (Planned) List available ThoxOS kernels |
| `thox os build --profile mini`       | (Planned) Build a full ThoxOS image  |

## Troubleshooting

**"Another instance of SwiftPM is already running"**
- A previous build was killed. Wait a minute or remove stale locks:
  ```bash
  rm -f ThoxTainer/.build/build.db.lock
  ```

**Build takes forever the first time**
- Normal. The dependency graph (gRPC, NIO, SwiftProtobuf, etc.) is large. Subsequent builds are fast thanks to caching.

**Kernel build fails**
- Make sure you have the Static Linux SDK installed (`make cross-prep`).
- Check that your custom `.config` has all the `VIRTIO` drivers built-in (not as modules).

## Next Steps

- Read [ARCHITECTURE.md](./ARCHITECTURE.md) to understand the model deeply.
- Read [KERNEL_GUIDE.md](./KERNEL_GUIDE.md) — this is the heart of ThoxOS customization.
- Read [ROADMAP.md](./ROADMAP.md) to see where we're headed with ThoxOS Mini / Air / Edge.
- Join the discussion at team@thox.ai

Welcome to the ThoxOS project.
