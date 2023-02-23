//
//  SBFileItem.swift
//  
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

public struct SBFileItem {
    public var url: URL
    public var title: String?
    
    public init(url: URL, title: String? = nil) {
        self.url = url
        self.title = title
    }
}
