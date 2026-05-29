//===----------------------------------------------------------------------===//
// Copyright © 2025-2026 Apple Inc. and the container project authors.
// Forked and extended by Thox.ai for the ThoxOS family.
// Licensed under the Apache License, Version 2.0
//===----------------------------------------------------------------------===//

import ArgumentParser
import ContainerAPIClient

extension Application {
    public struct OSListCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "list",
            abstract: "List available ThoxOS images, projects, and running VMs",
            aliases: ["ls"]
        )

        @OptionGroup
        public var logOptions: Flags.Logging

        @Flag(name: .long, help: "Show only running ThoxOS VMs")
        var running: Bool = false

        public func run() async throws {
            print("📋 [scaffold] ThoxOS Images & VMs")
            print("")

            if running {
                print("   (Would list currently running ThoxOS VMs managed by ThoxTainer)")
            } else {
                print("   Available projects (from templates + registry):")
                print("     • thoxos-mini-mobile")
                print("     • thoxos-companion")
                print("     • thoxos-mini-portable")
                print("     • thox-agentic-os (agent-runtime, thoxos-air-shim)")
                print("     • thoxos-desktop")
                print("")
                print("   (Full implementation will query local store + configured registries)")
            }
        }
    }
}
