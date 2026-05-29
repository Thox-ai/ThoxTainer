//===----------------------------------------------------------------------===//
// Copyright © 2025-2026 Apple Inc. and the container project authors.
// Forked and extended by Thox.ai for the ThoxOS family.
// Licensed under the Apache License, Version 2.0
//===----------------------------------------------------------------------===//

import ArgumentParser
import ContainerAPIClient

extension Application {
    /// Top-level `thox os` command group for managing ThoxOS family images and VMs.
    ///
    /// This is the primary interface for building and running ThoxOS Mini, Air,
    /// Companion, Portable, Desktop, and Agentic variants using ThoxTainer.
    public struct OSCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "os",
            abstract: "Build, run, and manage ThoxOS family images and lightweight VMs",
            discussion: """
            The `os` subcommand family is the primary way to work with ThoxOS variants
            (Mini, Air, Companion, Portable, Desktop, and AgenticOS) using ThoxTainer.

            Examples:
              thox os build --project thoxos-mini-mobile --profile mini
              thox os run my-edge-device
              thox os list
            """,
            subcommands: [
                OSBuildCommand.self,
                OSRunCommand.self,
                OSListCommand.self,
                OSDeleteCommand.self,
            ],
            aliases: ["o"]
        )

        @OptionGroup
        public var logOptions: Flags.Logging
    }
}

// Placeholder for delete until we implement it properly
extension Application {
    public struct OSDeleteCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "delete",
            abstract: "Delete a ThoxOS image or VM"
        )

        @OptionGroup
        public var logOptions: Flags.Logging

        @Argument(help: "Name of the ThoxOS image or VM to delete")
        var name: String

        public func run() async throws {
            print("🗑️  [scaffold] Would delete ThoxOS image/VM: \(name)")
            print("   (Full implementation coming in next iteration)")
        }
    }
}
