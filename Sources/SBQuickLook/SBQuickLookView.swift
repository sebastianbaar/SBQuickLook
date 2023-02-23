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

struct TransparentBackground: UIViewControllerRepresentable {
    public func makeUIViewController(context _: Context) -> UIViewController {
        return TransparentController()
    }
    
    public func updateUIViewController(_: UIViewController, context _: Context) {}
    
    class TransparentController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .clear
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            parent?.view?.backgroundColor = .clear
            parent?.modalPresentationStyle = .overCurrentContext
        }
    }
}
