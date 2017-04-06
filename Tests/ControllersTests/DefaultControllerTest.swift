import XCTest
@testable import Controllers
import Requests

class DefaultControllerTest: XCTestCase {
  func testItReturnsResponseWithStatus200() {
    let rawRequest = "GET /requests HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = DefaultController().process(request)

    XCTAssertEqual(response.statusCode, "200 OK")
  }
}
