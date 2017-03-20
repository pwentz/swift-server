import XCTest
@testable import Requests
@testable import Controllers

class LogsControllerTest: XCTestCase {
  func testItBlocksAnyRequestWithoutAuthParams() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let logs = [""]

    let res = try LogsController(logs).process(request)

    XCTAssertEqual(res.statusCode, "401 Unauthorized")
  }

  func testItBlocksAnyRequestWithoutMatchingAuthParams() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic someencodedstuff==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let logs = [""]

    let res = try LogsController(logs).process(request)

    XCTAssertEqual(res.statusCode, "401 Unauthorized")
  }

  func testItApprovesRequestsWithMatchingAuthParams() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic YWRtaW46aHVudGVyMg==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let logs = [""]

    let res = try LogsController(logs).process(request)

    XCTAssertEqual(res.statusCode, "200 OK")
  }

  func testItCanReturnBodyWithCombinedLogs() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic YWRtaW46aHVudGVyMg==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let logs = ["PUT /these HTTP/1.1"]

    let expected = "\n\nPUT /these HTTP/1.1\nGET /logs HTTP/1.1"

    let res = try LogsController(logs).process(request)

    XCTAssertEqual(res.body, expected)
  }

  func testItGivesNoBodyIfAuthDoesntMatch() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic someCode==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let logs = ["PUT /these HTTP/1.1"]

    let res = try LogsController(logs).process(request)

    XCTAssert(res.body.isEmpty)
  }
}
