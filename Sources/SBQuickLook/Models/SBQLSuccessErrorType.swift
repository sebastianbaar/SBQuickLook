//
//  SBQLSuccessErrorType.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents `SBQLSuccessError` type
public enum SBQLSuccessErrorType {
    /// Error downloading item from `URL`
    case download(Error?)
    /// Error moving item to `URL`
    case moveTo(Error?)
}
