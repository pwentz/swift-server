import XCTest
@testable import Requests
@testable import Controllers

class MethodOptionsControllerTest: XCTestCase {
  func testItCanRespondWithStatus200() {
    let rawRequest = "OPTIONS /method_options HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let response = MethodOptionsController().process(request)

    XCTAssertEqual(response.statusCode, "200 OK")
  }

  func testItCanRespondWithCorrectAllowHeaders() {
    let rawRequest = "OPTIONS /method_options HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let response = MethodOptionsController().process(request)

    let expected = "GET,HEAD,POST,OPTIONS,PUT"

    XCTAssertEqual(response.headers["Allow"]!, expected)
  }
}
