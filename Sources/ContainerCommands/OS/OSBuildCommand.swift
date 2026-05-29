//===----------------------------------------------------------------------===//
// Copyright © 2025-2026 Apple Inc. and the container project authors.
// Forked and extended by Thox.ai for the ThoxOS family.
// Licensed under the Apache License, Version 2.0
//===----------------------------------------------------------------------===//

import ArgumentParser
import ContainerAPIClient

extension Application {
    public struct OSBuildCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "build",
            abstract: "Build a ThoxOS family image from source or configuration",
            discussion: """
            Builds a ThoxOS image (OCI or raw) for one of the ThoxOS family projects:

              • thoxos-mini-mobile
              • thoxos-companion
              • thoxos-mini-portable
              • thox-agentic-os (agent-runtime or thoxos-air-shim)
              • thoxos-desktop

            Uses the kernel profiles defined in ThoxContainerization and the
            templates in templates/thoxos-family/.

            Examples:
              thox os build --project thoxos-mini-mobile --profile mini
              thox os build --project thox-agentic-os --variant agent-runtime
            """
        )

        @OptionGroup
        public var logOptions: Flags.Logging

        @Option(name: .long, help: "ThoxOS family project to build")
        var project: String

        @Option(name: .long, help: "Kernel profile to use (mini, air, edge, desktop, companion, etc.)")
        var profile: String = "mini"

        @Option(name: .long, help: "Variant for multi-target projects (e.g. agent-runtime, thoxos-air-shim)")
        var variant: String?

        @Option(name: .long, help: "Target architecture")
        var arch: String = "aarch64"

        @Option(name: .shortAndLong, help: "Output path for the built image")
        var output: String?

        @Flag(name: .long, help: "Build for production (release + signing)")
        var release: Bool = false

        public func run() async throws {
            print("🚀 [scaffold] ThoxTainer OS Builder")
            print("   Project : \(project)")
            print("   Profile : \(profile)")
            if let variant { print("   Variant : \(variant)") }
            print("   Arch    : \(arch)")
            print("   Release : \(release)")

            if let output {
                print("   Output  : \(output)")
            }

            print("")
            print("   This is scaffolding. In a full implementation this would:")
            print("   • Load templates/thoxos-family/\(project)/thoxos-*.toml")
            print("   • Select kernel from ThoxContainerization/kernel/build/\(profile)/")
            print("   • Run container build or rootfs assembly")
            print("   • Produce OCI image or raw VM image")
            print("   • Optionally sign with Thox release keys")
            print("")
            print("   Example future behavior:")
            print("   thox os build --project \(project) --profile \(profile) --output ./\(project).oci")
        }
    }
}
