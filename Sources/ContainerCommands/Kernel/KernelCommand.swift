//===----------------------------------------------------------------------===//
// Copyright © 2025-2026 Apple Inc. and the container project authors.
// Forked and extended by Thox.ai for the ThoxOS family.
// Licensed under the Apache License, Version 2.0
//===----------------------------------------------------------------------===//

import ArgumentParser
import ContainerAPIClient

extension Application {
    /// Top-level `thox kernel` commands for managing ThoxOS kernel profiles.
    public struct KernelCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "kernel",
            abstract: "Manage ThoxOS kernel profiles and builds",
            subcommands: [
                KernelListCommand.self,
                KernelUseCommand.self,
                KernelBuildCommand.self,
            ]
        )

        @OptionGroup
        public var logOptions: Flags.Logging
    }
}

extension Application {
    public struct KernelListCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "list",
            abstract: "List available ThoxOS kernel profiles"
        )

        @OptionGroup
        public var logOptions: Flags.Logging

        public func run() async throws {
            print("🧠 Available ThoxOS Kernel Profiles (from ThoxContainerization):")
            print("   • mini     (ThoxOS Mini - ultra minimal)")
            print("   • air      (ThoxOS Air - hardened, air-gapped)")
            print("   • edge     (ThoxOS Edge - real-time + I/O)")
            print("   • desktop  (ThoxOS Desktop - richer workstation)")
            print("   • companion (experimental)")
            print("")
            print("   (Scaffold) Full implementation will scan kernel/build/ directory")
        }
    }
}

extension Application {
    public struct KernelUseCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "use",
            abstract: "Set the default kernel profile for `thox os` commands"
        )

        @OptionGroup
        public var logOptions: Flags.Logging

        @Argument(help: "Kernel profile name (mini, air, edge, ...)")
        var profile: String

        public func run() async throws {
            print("✅ [scaffold] Default kernel profile set to: \(profile)")
            print("   (This will be persisted for future `thox os` commands)")
        }
    }
}

extension Application {
    public struct KernelBuildCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "build",
            abstract: "Build a custom ThoxOS kernel profile"
        )

        @OptionGroup
        public var logOptions: Flags.Logging

        @Argument(help: "Profile name to build (e.g. mini-mobile)")
        var profile: String

        public func run() async throws {
            print("🔨 [scaffold] Would build custom kernel profile: \(profile)")
            print("   Delegates to: ThoxContainerization/kernel/ (make kernel PROFILE=\(profile))")
        }
    }
}
