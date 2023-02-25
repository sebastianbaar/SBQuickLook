//
//  SBQLErrorType.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents `SBQLErrorType` type
public enum SBQLErrorType {
    /// Error downloading item(s)
    case download([SBQLFileItem: Error?])
    /// Error caused by no files / empty array of files
    case emptyFileItems
    /// Error caused by initialising `QLPreviewController`
    case qlPreviewControllerError

}
