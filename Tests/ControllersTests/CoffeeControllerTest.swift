import XCTest
@testable import Controllers
import Requests

class CoffeeControllerTest: XCTestCase {
  func testItCanReturnResponseWithStatus418() {
    let rawRequest = "GET /coffee HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = CoffeeController().process(request)

    XCTAssertEqual(response.statusCode, "418 I'm a teapot")
  }

  func testItCanReturnResponseWithAppropriateBody() {
    let rawRequest = "GET /coffee HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = CoffeeController().process(request)

    XCTAssertEqual(response.body!, "\n\nI'm a teapot".toBytes)
  }
}
