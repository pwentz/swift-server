import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class DirectoryLinksFormatterTest: XCTestCase {
  func testItCanAddDirectoryLinksToResponseBody() {
    let rawRequest = "GET / HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let files = ["/file1", "/file2"]

    DirectoryLinksFormatter(for: request, files: files).execute(on: &response)

    let expected = "\n\n<a href=\"/file1\">file1</a><br><a href=\"/file2\">file2</a>"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItDoesNotAddDirectoryLinksIfFilesAreNil() {
    let rawRequest = "GET / HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    DirectoryLinksFormatter(for: request, files: nil).execute(on: &response)

    XCTAssertNil(response.body)
  }
}
