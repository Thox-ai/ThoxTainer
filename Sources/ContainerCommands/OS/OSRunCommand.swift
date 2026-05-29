//===----------------------------------------------------------------------===//
// Copyright © 2025-2026 Apple Inc. and the container project authors.
// Forked and extended by Thox.ai for the ThoxOS family.
// Licensed under the Apache License, Version 2.0
//===----------------------------------------------------------------------===//

import ArgumentParser
import ContainerAPIClient

extension Application {
    public struct OSRunCommand: AsyncLoggableCommand {
        public init() {}

        public static let configuration = CommandConfiguration(
            commandName: "run",
            abstract: "Run a ThoxOS family image or VM as a lightweight virtual machine",
            discussion: """
            Launches a ThoxOS image (built with `thox os build` or manually)
            inside a dedicated lightweight VM using ThoxTainer + Virtualization.framework.

            This is the primary way to test ThoxOS Mini, Air, Companion, Portable,
            Desktop, and AgenticOS workloads on Apple Silicon during development.

            Examples:
              thox os run thoxos-mini-mobile
              thox os run thox-agentic-os --variant agent-runtime --memory 4G
              thox os run my-edge-device --kernel-profile air
            """
        )

        @OptionGroup
        public var logOptions: Flags.Logging

        @Argument(help: "Name of the ThoxOS image, project, or VM to run")
        var name: String

        @Option(name: .long, help: "Override kernel profile")
        var kernelProfile: String?

        @Option(name: .long, help: "Variant for projects like thox-agentic-os")
        var variant: String?

        @Option(name: .long, help: "Memory limit (e.g. 2G, 512M)")
        var memory: String = "1G"

        @Option(name: .long, help: "Number of CPUs")
        var cpus: Int = 2

        @Flag(name: .long, help: "Run with GUI / desktop mode if supported")
        var gui: Bool = false

        public func run() async throws {
            print("🖥️  [scaffold] ThoxTainer OS Runner")
            print("   Target  : \(name)")
            if let variant { print("   Variant : \(variant)") }
            print("   Kernel  : \(kernelProfile ?? "default from image")")
            print("   Memory  : \(memory)")
            print("   CPUs    : \(cpus)")
            print("   GUI     : \(gui)")

            print("")
            print("   This is scaffolding. Full implementation will:")
            print("   • Resolve the image (local OCI, registry, or project manifest)")
            print("   • Select the correct kernel from ThoxContainerization")
            print("   • Launch via Virtualization.framework as a dedicated lightweight VM")
            print("   • Wire vsock / gRPC to vminitd inside the VM")
            print("   • Support live kernel swapping and hot-reload for development")
            print("")
            print("   Example future behavior:")
            print("   thox os run \(name) --kernel-profile \(kernelProfile ?? "mini")")
        }
    }
}
