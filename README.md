# SBQuickLook
[![iOS Build](https://github.com/sebastianbaar/SBQuickLook/actions/workflows/ios.yml/badge.svg)](https://github.com/sebastianbaar/SBQuickLook/actions/workflows/ios.yml)
[![Swift](https://github.com/sebastianbaar/SBQuickLook/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/sebastianbaar/SBQuickLook/actions/workflows/swiftlint.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsebastianbaar%2FSBQuickLook%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/sebastianbaar/SBQuickLook)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsebastianbaar%2FSBQuickLook%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/sebastianbaar/SBQuickLook)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

Quickly preview local & external files and their content using Apple's QuickLook Framework.

This package provides a wrapper around Apple's **[QuickLook Framework](https://developer.apple.com/documentation/quicklook)**. 
- Can preview:
  - iWork and Microsoft Office documents
  - Images
  - Live Photos
  - Text files
  - PDFs
  - Audio and video files
  - Augmented reality objects that use the USDZ file format (iOS and iPadOS only)
  - ZIP files
  - ...
- Can be used with **UIKit** or **SwiftUI**
- Can be used to preview **one** or **multiple** files at once.
- Can be used with **local file** URLs or **external** URLs (it also handels downloading the files).

## 📦 Installation

Add this Swift package in Xcode using its Github repository url. (File > Swift Packages > Add Package Dependency...)

## 🚀 How to use

Initialize the View (SwiftUI) or ViewController (UIKit)

```swift
/// Initializes the `SBQuickLookView` or `SBQuickViewController` with the given file items and configuration.
///
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
    }
```

You have to pass the file items `SBFileItem` to the initializer. Either pass one item or multiple items to the View (SwiftUI) or ViewController (UIKit).

```swift
/// Initializes the file item with the given values.
///
/// - Parameters:
///   - url: `URL` of the item, choose between local file URLs or external URLs
///   - title: Optional title `String` to be displayed in the QuickLook controller.
///   - content: Optional media type `String` of the file; e.g. `"pdf"`, `"jpeg"`, ...
///   - urlRequest: Optional `URLRequest` used to download the item. The `url` is always set to `fileItem.url`. Default: `URLRequest(url: fileItem.url)`
public init(url: URL, title: String? = nil, mediaType: String? = nil, urlRequest: URLRequest? = nil) {
    self.url = url
    self.title = title
    self.mediaType = mediaType
    self.urlRequest = urlRequest
}
```

You can also pass an optional `SBQLConfiguration` to the initializer.

```swift
/// Initializes the file item with the given values.
///
/// - Parameters:
///   - urlRequest: Optional `URLSession`. Overrides the `URLSession` used by the download task. Default: `URLSession.shared`
///   - localFileDir: Optional local directory `URL`. Overrides the local directory `URL` used by the download task. Default: `FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)`
public init(session: URLSession? = nil, localFileDir: URL? = nil) {
    self.session = session
    self.localFileDir = localFileDir
}
```

### SwiftUI
Present the `SBQuickLookView` (which is a `UIViewControllerRepresentable` wrapper for the `SBQuickViewController`) from your favorite View.

```swift
@State var isShown = false

let fileItems: [SBFileItem]
let configuration: SBQLConfiguration

init() {
    let localFileURL = Bundle.main.url(forResource: "sample-local-pdf", withExtension: "pdf")!
    
    fileItems = [
        SBFileItem(url: localFileURL, title: "LOCAL FILE"),
        SBFileItem(url: URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/10/file_example_PNG_500kB.png")!, title: "Nice PNG Image", mediaType: "png")
    ]
    
    let localFileDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    configuration = SBQLConfiguration(localFileDir: localFileDir)
}

var body: some View {
    VStack {            
        Button {
            isShown.toggle()
        } label: {
            Text("Open QuickLook of files")
        }
    }
    .fullScreenCover(isPresented: $isShown, content: {
        SBQuickLookView(fileItems: fileItems, configuration: configuration) { result in
            switch result {
            case .success(let downloadError):
                if let downloadError {
                    print(downloadError)
                }
            case .failure(let error):
                switch error.type {
                case .emptyFileItems:
                    print("emptyFileItems")
                case .qlPreviewControllerError:
                    print("qlPreviewControllerError")
                case .download(let errorFileItems):
                    print("all items failed downloading")
                    print(errorFileItems)
                }
            }
        }
    })        
}
``` 

### UIKit 
Present the `SBQuickViewController` from your favorite ViewController.

```swift
let localFileURL = Bundle.main.url(forResource: "sample-local-pdf", withExtension: "pdf")!

let fileItems = [
    SBFileItem(url: localFileURL, title: "LOCAL FILE"),
    SBFileItem(url: URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/10/file_example_PNG_500kB.png")!, title: "Nice PNG Image", mediaType: "png")
]

let localFileDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let configuration = SBQLConfiguration(localFileDir: localFileDir)

let qlController = SBQuickViewController(fileItems: fileItems, configuration: configuration)
qlController.modalPresentationStyle = .overFullScreen
present(qlController, animated: true)
```

## 🎓 Example

Example SwiftUI Project can be found [here](https://github.com/sebastianbaar/SBQuickLook-Example/tree/main).
