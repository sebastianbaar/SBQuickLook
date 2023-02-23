//
//  SBQuickLookView.swift
//
//
//  Created by Sebastian Baar on 23.02.23.
//

import UIKit
import SwiftUI
import QuickLook

public struct SBQuickLookView {
    public let fileItems: [SBFileItem]
    
    public init(fileItems: [SBFileItem]) {
        self.fileItems = fileItems
    }
}

extension SBQuickLookView: UIViewControllerRepresentable {
    public func makeUIViewController(context _: Context) -> UIViewController {
        return SBQuickViewController(fileItems: fileItems)
    }
    
    public func updateUIViewController(_: UIViewController, context _: Context) {}
}
