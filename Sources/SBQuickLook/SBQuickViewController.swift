//
//  SBQuickViewController.swift
//  
//
//  Created by Sebastian Baar on 23.02.23.
//

import UIKit
import SwiftUI
import QuickLook

final class SBQuickViewController: UIViewController {
    private var qlController: QLPreviewController?
    private var previewItems: [SBPreviewItem] = [] {
        didSet {
            qlController?.reloadData()
        }
    }
    
    public var urls: [URL]
    
    public init(urls: [URL]) {
        self.urls = urls
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if qlController == nil {
            qlController = QLPreviewController()
            qlController?.dataSource = self
            qlController?.delegate = self
            qlController?.currentPreviewItemIndex = 0
            present(qlController!, animated: true)
            
            checkAndDownloadFiles()
        }
    }
    
    private func checkAndDownloadFiles() {
        let taskGroup = DispatchGroup()
        let session = URLSession.shared
        var itemsToPreview: [SBPreviewItem] = []
        
        for url in urls {
            taskGroup.enter()
            
            let fileManager = FileManager.default
            let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let (fileName, fileExtension) = self.getFileNameAndExtension(url)
            let localFileUrl = cacheDir.appendingPathComponent("\(fileName).\(fileExtension)")
            
            if fileManager.fileExists(atPath: localFileUrl.absoluteString) {
                do {
                    try fileManager.removeItem(atPath: localFileUrl.absoluteString)
                } catch {
                    itemsToPreview.append(
                        SBPreviewItem(
                            previewItemURL: localFileUrl,
                            previewItemTitle: fileName
                        )
                    )
                    
                    taskGroup.leave()
                }
            }
            
            let request = URLRequest(
                url: url,
                cachePolicy: .reloadIgnoringLocalCacheData,
                timeoutInterval: 10
            )
            
            session.downloadTask(with: request) { location, _, error in
                guard let location, error == nil else {
                    taskGroup.leave()
                    return
                }
                
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: localFileUrl)
                    
                    itemsToPreview.append(
                        SBPreviewItem(
                            previewItemURL: localFileUrl,
                            previewItemTitle: fileName
                        )
                    )
                    
                    taskGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    
                    taskGroup.leave()
                }
            }.resume()
        }
        
        taskGroup.notify(queue: .main) { [weak self] in
            self?.previewItems = itemsToPreview
        }
    }
    
    private func getFileNameAndExtension(_ fileURL: URL) -> (fileName: String, fileExtension: String) {
        let urlFileName = fileURL.lastPathComponent
        let fileName = urlFileName.isEmpty ? UUID().uuidString : urlFileName
        let urlExtension = fileURL.pathExtension
        let fileExtension = urlExtension.isEmpty ? "file" : urlExtension
        return (fileName, fileExtension)
    }
}

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
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        dismiss(animated: true)
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        dismiss(animated: true)
    }
}
