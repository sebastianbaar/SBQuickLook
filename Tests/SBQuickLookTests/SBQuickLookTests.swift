import XCTest
@testable import SBQuickLook

final class SBQuickLookTests: XCTestCase {
    
    func testExample() throws {
        let urls: [URL] = [
            URL(string: "https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_1MB_PDF.pdf")!,
            URL(string: "https://calibre-ebook.com/downloads/demos/demo.docx")!,
            URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/10/file_example_JPG_100kB.jpg")!,
            URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/10/file_example_PNG_500kB.png")!,
            URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/10/file_example_GIF_3500kB.gif")!,
            URL(string: "https://file-examples.com/storage/fe197d899c63f609e194cb1/2017/11/file_example_MP3_5MG.mp3")!,
        ]
        let qlView = SBQuickLookView(urls: urls)
        
        XCTAssert(qlView.urls.count > 0)
    }
}
