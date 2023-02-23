//
//  SBQuickViewController.swift
//
//
//  Created by Sebastian Baar on 23.02.23.
//

import UIKit
import SwiftUI
import QuickLook

public final class SBQuickViewController: UIViewController {
    internal var qlController: QLPreviewController?
    internal var previewItems: [SBPreviewItem] = []
    
    public var fileItems: [SBFileItem]
    
    public init(fileItems: [SBFileItem]) {
        self.fileItems = fileItems
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        parent?.view?.backgroundColor = .clear
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if qlController == nil {
            qlController = QLPreviewController()
            qlController?.dataSource = self
            qlController?.delegate = self
            qlController?.currentPreviewItemIndex = 0
            
            downloadFiles { [weak self] in
                guard let self, let qlController = self.qlController else { return }
                qlController.reloadData()
                self.present(qlController, animated: true)
            }
        }
    }
}

extension SBQuickViewController {
    private func downloadFiles(_ completion: (() -> Void)?) {
        let taskGroup = DispatchGroup()
        let session = URLSession.shared
        var itemsToPreview: [SBPreviewItem] = []
        
        for item in fileItems {
            let fileInfo = self.getFileNameAndExtension(item.url)
            
            let fileExtension = (item.mediaType != nil && item.mediaType?.isEmpty == false) ? item.mediaType! : fileInfo.fileExtension
            let fileName = (item.title != nil && item.title?.isEmpty == false) ? item.title! : fileInfo.fileName
            
            if item.url.isFileURL {
                itemsToPreview.append(
                    SBPreviewItem(
                        previewItemURL: item.url,
                        previewItemTitle: fileName
                    )
                )
                
                continue
            }
            
            let fileManager = FileManager.default
            let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let localFileUrl = cacheDir.appendingPathComponent("\(fileName).\(fileExtension)")
            
            if fileManager.fileExists(atPath: localFileUrl.path) {
                do {
                    try fileManager.removeItem(atPath: localFileUrl.path)
                } catch {
                    itemsToPreview.append(
                        SBPreviewItem(
                            previewItemURL: localFileUrl,
                            previewItemTitle: fileName
                        )
                    )
                    
                    continue
                }
            }
            
            taskGroup.enter()
            
            let request = URLRequest(url: item.url)
            session.downloadTask(with: request) { location, _, error in
                guard let location, error == nil else {
                    taskGroup.leave()
                    return
                }
                
                do {
                    try FileManager.default.moveItem(at: location, to: localFileUrl)
                    
                    itemsToPreview.append(
                        SBPreviewItem(
                            previewItemURL: localFileUrl,
                            previewItemTitle: fileName
                        )
                    )
                    
                    taskGroup.leave()
                } catch {
                    taskGroup.leave()
                }
            }.resume()
        }
        
        taskGroup.notify(queue: .main) { [weak self] in
            self?.previewItems = itemsToPreview
            completion?()
        }
    }
    
    private func getFileNameAndExtension(_ fileURL: URL) -> (fileName: String, fileExtension: String) {
        let urlExtension = fileURL.pathExtension
        let fileExtension = urlExtension.isEmpty ? "file" : urlExtension
        let urlFileName = fileURL.lastPathComponent
        let fileName = urlFileName.isEmpty ? UUID().uuidString : urlFileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
        
        return (fileName, fileExtension)
    }
}
