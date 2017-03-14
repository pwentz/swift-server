import XCTest
@testable import Requests
@testable import Controllers

class CookieControllerTest: XCTestCase {
  func testItCanFormatCorrectBody() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let result = "\n\nEat"
    let formattedResult = Array(result.utf8)

    let res = CookieController.process(request)

    XCTAssertEqual(res.body, formattedResult)
  }

  func testItCanFormatCorrectHeaders() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let headers = [
      "Content-Type:text/html",
      "Set-Cookie:type=chocolate"
    ].joined(separator: "\r\n")

    let formattedHeaders = Array(headers.utf8)

    let res = CookieController.process(request)

    XCTAssertEqual(res.headers, formattedHeaders)
  }

  func testItCanCookieFormatResponseWithCorrectStatus() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let res = CookieController.process(request)

    XCTAssertEqual(res.statusCode, "200 OK")
  }

  func testItCanMatchHeadersToRequest() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let headers = [
      "Content-Type:text/html",
    ].joined(separator: "\r\n")

    let formattedHeaders = Array(headers.utf8)

    let res = CookieController.process(request)

    XCTAssertEqual(res.headers, formattedHeaders)
  }

  func testItCanResponseWithTheCorrectBodyWithCookieHeader() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let result = "\n\nmmmm chocolate"

    let formattedResult = Array(result.utf8)

    let res = CookieController.process(request)

    XCTAssertEqual(res.body, formattedResult)
  }

  func testItCanResponseWithToDynamicCookieHeader() {
    let firstRawRequest = "GET /cookie?type=oatmeal HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let firstRequest = Request(for: firstRawRequest)
    let _ = CookieController.process(firstRequest)

    let secondRawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=oatmeal\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let secondRequest = Request(for: secondRawRequest)
    let secondResponse = CookieController.process(secondRequest)

    let result = "\n\nmmmm oatmeal"

    let formattedResult = Array(result.utf8)

    XCTAssertEqual(secondResponse.body, formattedResult)
  }

  func testItCanFormatResponseWithCorrectStatus() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let res = CookieController.process(request)

    XCTAssertEqual(res.statusCode, "200 OK")
  }
}
