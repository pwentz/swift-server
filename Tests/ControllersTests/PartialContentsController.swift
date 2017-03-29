import XCTest
@testable import Requests
@testable import Controllers

class PartialContentsControllerTest: XCTestCase {
  func testItCanRespondWithA206WithPartialContent() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange:bytes=4-"
    let request = Request(for: rawRequest)

    let content = "This is a file that contains text to read part of in order to fulfill a 206."

    let response = PartialContentsController(content: content).process(request)

    XCTAssertEqual(response.statusCode, "206 Partial Content")
  }

  func testItCanRespondWithPartialContentsGivenRangeStart() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=4-\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let content = "This is a file that contains text to read part of in order to fulfill a 206."

    let response = PartialContentsController(content: content).process(request)

    let expected = Array("\n\n is a file that contains text to read part of in order to fulfill a 206.".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanRespondWithPartialContentsGivenRangeEnd() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=-6\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let content = "This is a file that contains text to read part of in order to fulfill a 206."

    let response = PartialContentsController(content: content).process(request)

    let expected = Array("\n\na 206.".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanRespondWithPartialContentsGivenRangeStartAndEnd() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=0-4\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let content = "This is a file that contains text to read part of in order to fulfill a 206."

    let response = PartialContentsController(content: content).process(request)

    let expected = Array("\n\nThis ".utf8)

    XCTAssertEqual(response.body!, expected)
  }
}
