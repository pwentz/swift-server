import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class DirectoryLinksFormatterTest: XCTestCase {
  func testItCanAddDirectoryLinksToResponseBody() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let files = ["/file1", "/file2"]

    DirectoryLinksFormatter(files: files).execute(on: &response)

    let expected = "\n\n<a href=\"/file1\">file1</a><br><a href=\"/file2\">file2</a>"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItDoesNotAddDirectoryLinksIfFilesAreNil() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    DirectoryLinksFormatter(files: nil).execute(on: &response)

    XCTAssertNil(response.body)
  }
}
