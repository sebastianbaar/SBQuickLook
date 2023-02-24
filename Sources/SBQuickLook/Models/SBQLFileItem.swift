//
//  SBFileItem.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents the input file item
public struct SBQLFileItem {
    public var url: URL
    public var title: String?
    public var mediaType: String?
    public var urlRequest: URLRequest?
    
    /// Initializes the file item with the given values.
    ///
    /// - Parameters:
    ///   - url: `URL` of the item, choose between local file URLs or external URLs
    ///   - title: Optional title `String` to be displayed in the QuickLook controller.
    ///   - content: Optional media type `String` of the file; e.g. `"pdf"`, `"jpeg"`, ...
    ///   - urlRequest: Optional `URLRequest` used to download the item. The `url` is always set to `fileItem.url`. Default: `URLRequest(url: fileItem.url)`
    public init(url: URL, title: String? = nil, mediaType: String? = nil, urlRequest: URLRequest? = nil) {
        self.url = url
        self.title = title
        self.mediaType = mediaType
        self.urlRequest = urlRequest
    }
}
