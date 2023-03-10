//
//  SBQuickViewController.swift
//  SBQuickLook
//
//  Created by Sebastian Baar on 23.02.23.
//

import UIKit
import SwiftUI
import QuickLook

/// The `SBQuickViewController` to preview one or multiple files
public final class SBQuickViewController: UIViewController {
    internal var qlController: QLPreviewController?
    internal var previewItems: [SBQLPreviewItem] = []

    // - MARK: Public
    public let fileItems: [SBQLFileItem]
    public let configuration: SBQLConfiguration?
    public let completion: ((Result<SBQLError?, SBQLError>) -> Void)?

    /// Initializes the `SBQuickViewController` with the given file items and configuration.
    /// - Parameters:
    ///   - fileItems: The `[SBQLFileItem]` data for populating the preview. Could be one or many items.
    ///   - configuration: Optional `SBQLConfiguration` configurations.
    ///   - completion: Optional `Result<SBQLError?, SBQLError>` completion.
    ///      - success: `QLPreviewController` successfully presented with at least one item. Optional `SBQLError` if some items failed to download.
    ///      - failure: `QLPreviewController` could not be  presented.
    public init(
        fileItems: [SBQLFileItem],
        configuration: SBQLConfiguration? = nil,
        completion: ((Result<SBQLError?, SBQLError>) -> Void)? = nil) {
            self.fileItems = fileItems
            self.configuration = configuration
            self.completion = completion

            super.init(nibName: nil, bundle: nil)
        }

    required init?(coder: NSCoder) {
        fatalError("SBQuickLook: init(coder:) has not been implemented")
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

        guard fileItems.count > 0 else {
            completion?(.failure(SBQLError(type: .emptyFileItems)))
            dismiss(animated: false)
            return
        }

        showPreviewController()
    }
}

extension SBQuickViewController {
    private func showPreviewController() {
        guard qlController == nil else { return }

        qlController = QLPreviewController()
        qlController?.dataSource = self
        qlController?.delegate = self
        qlController?.currentPreviewItemIndex = 0

        downloadFiles { [weak self] itemsToPreview, downloadError in
            guard let self else { return }

            guard let qlController = self.qlController else {
                self.completion?(.failure(SBQLError(type: .qlPreviewControllerError)))
                self.dismiss(animated: false)
                return
            }

            guard itemsToPreview.count > 0 else {
                self.completion?(.failure(downloadError!))
                self.dismiss(animated: false)
                return
            }

            self.previewItems = itemsToPreview

            self.present(qlController, animated: true) {
                self.completion?(.success(downloadError))
            }

            qlController.reloadData()
        }
    }

    // swiftlint:disable function_body_length
    private func downloadFiles(_ completion: @escaping ([SBQLPreviewItem], SBQLError?) -> Void) {
        let taskGroup = DispatchGroup()

        var session = URLSession.shared
        if let customSession = configuration?.session {
            session = customSession
        }

        var itemsToPreview: [SBQLPreviewItem] = []
        var failedItems: [SBQLFileItem: Error] = [:]

        for item in fileItems {
            let fileInfo = self.getFileNameAndExtension(item.url)

            let fileExtension = (item.mediaType != nil && item.mediaType?.isEmpty == false) ?
            item.mediaType! :
            fileInfo.fileExtension
            let fileName = (item.title != nil && item.title?.isEmpty == false) ?
            item.title! :
            fileInfo.fileName

            if item.url.isFileURL {
                itemsToPreview.append(
                    SBQLPreviewItem(
                        previewItemURL: item.url,
                        previewItemTitle: fileName
                    )
                )

                continue
            }

            let fileManager = FileManager.default
            var localFileDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            if let customLocalFileDir = configuration?.localFileDir {
                localFileDir = customLocalFileDir
            }
            let localFileUrl = localFileDir.appendingPathComponent("\(fileName).\(fileExtension)")

            if fileManager.fileExists(atPath: localFileUrl.path) {
                do {
                    try fileManager.removeItem(atPath: localFileUrl.path)
                } catch {
                    itemsToPreview.append(
                        SBQLPreviewItem(
                            previewItemURL: localFileUrl,
                            previewItemTitle: fileName
                        )
                    )

                    continue
                }
            }

            taskGroup.enter()

            var request = URLRequest(url: item.url)
            if var customURLRequest = item.urlRequest {
                customURLRequest.url = item.url
                request = customURLRequest
            }
            session.downloadTask(with: request) { location, _, error in
                guard let location, error == nil else {
                    failedItems[item] = error
                    taskGroup.leave()
                    return
                }

                do {
                    try FileManager.default.moveItem(at: location, to: localFileUrl)

                    itemsToPreview.append(
                        SBQLPreviewItem(
                            previewItemURL: localFileUrl,
                            previewItemTitle: fileName
                        )
                    )

                    taskGroup.leave()
                } catch {
                    failedItems[item] = error
                    taskGroup.leave()
                }
            }.resume()
        }

        taskGroup.notify(queue: .main) {
            var downloadError: SBQLError?
            if failedItems.count > 0 {
                downloadError = SBQLError(type: .download(failedItems))
            }

            completion(
                itemsToPreview,
                downloadError
            )
        }
    }
    // swiftlint:enable function_body_length

    private func getFileNameAndExtension(_ fileURL: URL) -> (fileName: String, fileExtension: String) {
        let urlExtension = fileURL.pathExtension
        let fileExtension = urlExtension.isEmpty ? "file" : urlExtension
        let urlFileName = fileURL.lastPathComponent
        let fileName = urlFileName.isEmpty ?
        UUID().uuidString :
        urlFileName.replacingOccurrences(of: ".\(fileExtension)", with: "")

        return (fileName, fileExtension)
    }
}
