import XCTest
@testable import Requests
@testable import Controllers

class CookieControllerTest: XCTestCase {
  func testItCanFormatCorrectBody() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let result = "\n\nEat"

    let res = CookieController().process(request)

    XCTAssertEqual(res.body, result)
  }

  func testItCanFormatCorrectHeaders() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let headers = [
      "Content-Type" : "text/html",
      "Set-Cookie" : "type=chocolate"
    ]

    let res = CookieController().process(request)

    XCTAssertEqual(res.headers, headers)
  }

  func testItCanCookieFormatResponseWithCorrectStatus() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let res = CookieController().process(request)

    XCTAssertEqual(res.statusCode, "200 OK")
  }

  func testItCanMatchHeadersToRequest() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let headers = [
      "Content-Type" : "text/html",
    ]

    let res = CookieController().process(request)

    XCTAssertEqual(res.headers, headers)
  }

  func testItCanResponseWithTheCorrectBodyWithCookieHeader() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let result = "\n\nmmmm chocolate"

    let res = CookieController().process(request)

    XCTAssertEqual(res.body, result)
  }

  func testItCanResponseWithToDynamicCookieHeader() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=oatmeal\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let res = CookieController().process(request)

    let result = "\n\nmmmm oatmeal"

    XCTAssertEqual(res.body, result)
  }

  func testItCanFormatResponseWithCorrectStatus() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let res = CookieController().process(request)

    XCTAssertEqual(res.statusCode, "200 OK")
  }
}
