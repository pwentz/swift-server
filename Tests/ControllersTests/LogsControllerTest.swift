import XCTest
@testable import Requests
@testable import Controllers

class LogsControllerTest: XCTestCase {
  func testItBlocksAnyRequestWithoutAuthParams() {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let res = LogsController.process(request)

    XCTAssertEqual(res.statusCode, "401 Unauthorized")
  }

  func testItBlocksAnyRequestWithoutMatchingAuthParams() {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic someencodedstuff==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let res = LogsController.process(request)

    XCTAssertEqual(res.statusCode, "401 Unauthorized")
  }

  func testItApprovesRequestsWithMatchingAuthParams() {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic YWRtaW46aHVudGVyMg==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let res = LogsController.process(request)

    XCTAssertEqual(res.statusCode, "200 OK")
  }
}
