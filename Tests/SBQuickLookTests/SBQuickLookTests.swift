import XCTest
@testable import SBQuickLook

// swiftlint:disable line_length
final class SBQuickLookTests: XCTestCase {

    func testExample() throws {
        let fileItems: [SBQLFileItem] = [
            SBQLFileItem(url: URL(string: "https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_1MB_PDF.pdf")!, title: "Test PDF"),
            SBQLFileItem(url: URL(string: "https://calibre-ebook.com/downloads/demos/demo.docx")!),
            SBQLFileItem(url: URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/10/file_example_JPG_100kB.jpg")!),
            SBQLFileItem(url: URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/10/file_example_PNG_500kB.png")!),
            SBQLFileItem(url: URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/10/file_example_GIF_3500kB.gif")!),
            SBQLFileItem(url: URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/11/file_example_MP3_5MG.mp3")!)
        ]

        let qlView = SBQuickLookView(fileItems: fileItems)

        XCTAssert(qlView.fileItems.count > 0)
    }
}
