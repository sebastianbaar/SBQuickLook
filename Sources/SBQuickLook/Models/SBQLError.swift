//
//  SBQLError.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents `SBQuickLook` error cases
public struct SBQLError: Error {
    /// `SBQuickLook` error type
    public var type: SBQLErrorType
}
