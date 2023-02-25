//
//  SBQLSuccessErrorType.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents `SBQLSuccessWithErrorType` type
public enum SBQLSuccessWithErrorType {
    /// Error downloading item from `URL`
    case download(Error?)
    /// Error moving item to `URL`
    case moveTo(Error?)
}
