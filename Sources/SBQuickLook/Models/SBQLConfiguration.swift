//
//  SBConfiguration.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents the optional configuration file
public struct SBQLConfiguration {
    public var session: URLSession?
    public var localFileDir: URL?
    
    /// Initializes the file item with the given values.
    ///
    /// - Parameters:
    ///   - urlRequest: Optional `URLSession`. Overrides the `URLSession` used by the download task. Default: `URLSession.shared`
    ///   - localFileDir: Optional local directory `URL`. Overrides the local directory `URL` used by the download task. Default: `FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)`
    public init(session: URLSession? = nil, localFileDir: URL? = nil) {
        self.session = session
        self.localFileDir = localFileDir
    }
}
