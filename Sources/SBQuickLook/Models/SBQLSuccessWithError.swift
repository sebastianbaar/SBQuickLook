//
//  SBQLSuccessError.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents `SBQuickLook` success with error types and URLs
public struct SBQLSuccessWithError {
    /// Error `SBQLSuccessErrorType` type
    public var type: SBQLSuccessWithErrorType
    /// Error item `URL`
    public var url: URL
}
