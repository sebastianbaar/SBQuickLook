//
//  SBQuickLookView.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import UIKit
import SwiftUI
import QuickLook

/// The SwiftUI view representable
public struct SBQuickLookView {
    public let fileItems: [SBQLFileItem]
    public let configuration: SBQLConfiguration?
    public let completion: ((Result<SBQLError?, SBQLError>) -> Void)?

    /// Initializes the `SBQuickLookView` with the given file items and configuration.
    ///
    /// - Parameters:
    ///   - fileItems: The `[SBQLFileItem]` data for populating the preview. Could be one or many items.
    ///   - configuration: Optional `SBQLConfiguration` configurations.
    ///   - completion: Optional `Result<SBQLError?, SBQLError>` completion.
    ///      - success: `QLPreviewController` successfully presented with at least one item. Optional `SBQLError` if some items failed to download.
    ///      - failure: `QLPreviewController` could not be  presented.
    public init(
        fileItems: [SBQLFileItem],
        configuration: SBQLConfiguration? = nil,
        completion: ((Result<SBQLError?, SBQLError>) -> Void)? = nil) {
            self.fileItems = fileItems
            self.configuration = configuration
            self.completion = completion
        }
}

extension SBQuickLookView: UIViewControllerRepresentable {
    public func makeUIViewController(context _: Context) -> UIViewController {
        return SBQuickViewController(
            fileItems: fileItems,
            configuration: configuration,
            completion: completion
        )
    }

    public func updateUIViewController(_: UIViewController, context _: Context) {}
}
