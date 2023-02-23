//
//  SBPreviewItem.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import QuickLook

final internal class SBPreviewItem: NSObject, QLPreviewItem {
    public var previewItemURL: URL?
    public var previewItemTitle: String?
    
    public init(previewItemURL: URL? = nil, previewItemTitle: String? = nil) {
        self.previewItemURL = previewItemURL
        self.previewItemTitle = previewItemTitle
    }
}
