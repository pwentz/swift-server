import XCTest
@testable import Requests
@testable import Controllers

class ResourcesControllerTest: XCTestCase {
  func testItCanProcessARequestWithTextFiles() throws {
    let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["file1": "this is a text file.",
                    "file2": "this is another text file."]

    let response = try ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.body, "\n\nthis is a text file.")
  }

  func testItCanProcessAnImageRequest() throws {
    let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let longBase64String = "kdjnakjenawew09eqea///a20jq203jq+++ekqjn23kj32=="

    let contents = ["image.jpeg": longBase64String,
                    "file2": "this is another text file."]

    let expected = "\n\n<img src=\"data:image/jpeg;base64,\(longBase64String)\"/>"

    let response = try ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.body, expected)
  }

  func testItReturns404IfNoFileIsFound() throws {
    let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["file2": "this is another text file."]

    let response = try ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "404 Not Found")
  }
}
