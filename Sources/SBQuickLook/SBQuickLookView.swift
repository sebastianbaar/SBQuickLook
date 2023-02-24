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

    /// Initializes the `SBQuickLookView` with the given file items and configuration.
    ///
    /// - Parameters:
    ///   - fileItems: The `[SBQLFileItem]` data for populating the preview. Could be one or many items.
    ///   - configuration: Optional `SBQLConfiguration` configurations.
    public init(fileItems: [SBQLFileItem], configuration: SBQLConfiguration? = nil) {
        self.fileItems = fileItems
        self.configuration = configuration
    }
}

extension SBQuickLookView: UIViewControllerRepresentable {
    public func makeUIViewController(context _: Context) -> UIViewController {
        return SBQuickViewController(fileItems: fileItems, configuration: configuration)
    }

    public func updateUIViewController(_: UIViewController, context _: Context) {}
}
