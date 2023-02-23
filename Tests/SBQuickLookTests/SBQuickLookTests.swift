import XCTest
@testable import SBQuickLook

final class SBQuickLookTests: XCTestCase {
    
    func testExample() throws {
        let urls: [URL] = [
            URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!,
            URL(string: "https://file-examples.com/wp-content/uploads/2017/02/file-sample_100kB.doc")!,
            URL(string: "https://file-examples.com/wp-content/uploads/2017/10/file_example_JPG_100kB.jpg")!,
            URL(string: "https://file-examples.com/wp-content/uploads/2017/10/file_example_PNG_500kB.png")!,
            URL(string: "https://file-examples.com/wp-content/uploads/2017/10/file_example_GIF_3500kB.gif")!,
            URL(string: "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_5MG.mp3")!,
            URL(string: "https://file-examples.com/wp-content/uploads/2017/11/file_example_WAV_5MG.wav")!
        ]
        let qlView = SBQuickLookView(urls: urls)
        
        XCTAssert(qlView.urls.count > 0)
    }
}
