import XCTest
@testable import Controllers
import Requests

class FoobarControllerTest: XCTestCase {
  func testItReturnsResponseWithStatus404() {
    let rawRequest = "GET /foobar HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = FoobarController().process(request)

    XCTAssertEqual(response.statusCode, "404 Not Found")
  }

  func testItReturnsResponseWithNoBody() {
    let rawRequest = "GET /foobar HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = FoobarController().process(request)

    XCTAssertNil(response.body)
  }
}
