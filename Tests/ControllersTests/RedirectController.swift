import XCTest
@testable import Requests
@testable import Controllers

class RedirectControllerTest: XCTestCase {
  func testItHas302StatusCode() {
    let rawRequest = "GET /redirect HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = RedirectController().process(request)

    XCTAssertEqual(response.statusCode, "302 Found")
  }

  func testItHasALocationHeader() {
    let rawRequest = "GET /redirect HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = RedirectController().process(request)

    XCTAssertEqual(response.headers["Location"]!, "/")
  }
}

