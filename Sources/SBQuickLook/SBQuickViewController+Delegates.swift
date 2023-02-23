//
//  SBQuickViewController+Delegates.swift
//  
//
//  Created by Sebastian Baar on 23.02.23.
//

import QuickLook

extension SBQuickViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItems.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItems[index]
    }
    
    
}

extension SBQuickViewController: QLPreviewControllerDelegate {
    @available(iOS 13.0, *)
    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
        .createCopy
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        dismiss(animated: false)
    }
}

