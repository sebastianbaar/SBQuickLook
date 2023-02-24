//
//  SBQLError.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import Foundation

/// Represents `SBQuickLook` error cases
public enum SBQLError: Error {
    /// Error caused by no files / empty array of files
    case emptyFileItems
    /// Error downloading all given files
    case downloadError
    /// Error caused by initialising `QLPreviewController`
    case qlPreviewControllerError
}
