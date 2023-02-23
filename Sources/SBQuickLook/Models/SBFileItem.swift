//
//  SBFileItem.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents the input file item
public struct SBFileItem {
    public var url: URL
    public var title: String?
    public var mediaType: String?
    
    /// Initializes the file item with the given values.
    ///
    /// - Parameters:
    ///   - url: The `URL` of the item, choose between local file URLs or external URLs
    ///   - title: An optional title `String` to be displayed in the QuickLook controller.
    ///   - content: An optional media type `String` of the file; e.g. `"pdf"`, `"jpeg"`, ...
    public init(url: URL, title: String? = nil, mediaType: String? = nil) {
        self.url = url
        self.title = title
        self.mediaType = mediaType
    }
}
