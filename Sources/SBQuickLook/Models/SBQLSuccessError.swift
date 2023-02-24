//
//  SBQLSuccessError.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents `SBQuickLook success error types and URLs
public struct SBQLSuccessError {
    /// Success error `SBQLSuccessErrorType` type
    public var type: SBQLSuccessErrorType
    /// Success error item `URL`
    public var url: URL
}
