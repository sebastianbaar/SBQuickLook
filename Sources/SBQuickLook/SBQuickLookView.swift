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
    public let urls: [URL]
    
    public init(urls: [URL]) {
        self.urls = urls
    }
}

extension SBQuickLookView: UIViewControllerRepresentable {
    public func makeUIViewController(context _: Context) -> UIViewController {
        return SBQuickViewController(urls: urls)
    }
    
    public func updateUIViewController(
        _: UIViewController, context _: Context
    ) {}
}
