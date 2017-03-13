import XCTest
@testable import Requests
@testable import Controllers

class CookieControllerTest: XCTestCase {
  func testItCanFormatCorrectBody() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let controller = CookieController(request)

    let result = "\n\nEat"
    let formattedResult = Array(result.utf8)

    let res = controller.process()

    XCTAssertEqual(res.body, formattedResult)
  }

  func testItCanFormatCorrectHeaders() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let controller = CookieController(request)

    let headers = [
      "Content-Type:text/html",
      "Set-Cookie:type=chocolate"
    ].joined(separator: "\r\n")

    let formattedHeaders = Array(headers.utf8)

    let res = controller.process()

    XCTAssertEqual(res.headers, formattedHeaders)
  }

  func testItCanCookieFormatResponseWithCorrectStatus() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let controller = CookieController(request)

    let res = controller.process()

    XCTAssertEqual(res.statusCode, "200 OK")
  }

  func testItCanMatchHeadersToRequest() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let controller = CookieController(request)

    let headers = [
      "Content-Type:text/html",
    ].joined(separator: "\r\n")

    let formattedHeaders = Array(headers.utf8)

    let res = controller.process()

    XCTAssertEqual(res.headers, formattedHeaders)
  }

  func testItCanResponseWithTheCorrectBodyWithCookieHeader() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let controller = CookieController(request)

    let result = "\n\nmmmm chocolate"

    let formattedResult = Array(result.utf8)

    let res = controller.process()

    XCTAssertEqual(res.body, formattedResult)
  }

  func testItCanFormatResponseWithCorrectStatus() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let controller = CookieController(request)

    let res = controller.process()

    XCTAssertEqual(res.statusCode, "200 OK")
  }
}
