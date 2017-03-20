import XCTest
@testable import Requests
@testable import Controllers

class CookieControllerTest: XCTestCase {
  func testItCanFormatCorrectBody() throws {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let result = "\n\nEat"

    let res = try CookieController().process(request)

    XCTAssertEqual(res.body, result)
  }

  func testItCanFormatCorrectHeaders() throws {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let headers = [
      "Content-Type" : "text/html",
      "Set-Cookie" : "type=chocolate"
    ]

    let res = try CookieController().process(request)

    XCTAssertEqual(res.headers, headers)
  }

  func testItCanCookieFormatResponseWithCorrectStatus() throws {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let res = try CookieController().process(request)

    XCTAssertEqual(res.statusCode, "200 OK")
  }

  func testItCanMatchHeadersToRequest() throws {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let headers = [
      "Content-Type" : "text/html",
    ]

    let res = try CookieController().process(request)

    XCTAssertEqual(res.headers, headers)
  }

  func testItCanResponseWithTheCorrectBodyWithCookieHeader() throws {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let result = "\n\nmmmm chocolate"

    let res = try CookieController().process(request)

    XCTAssertEqual(res.body, result)
  }

  func testItCanResponseWithToDynamicCookieHeader() throws {
    let firstRawRequest = "GET /cookie?type=oatmeal HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let firstRequest = Request(for: firstRawRequest)
    let _ = try CookieController().process(firstRequest)

    let secondRawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=oatmeal\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let secondRequest = Request(for: secondRawRequest)
    let secondResponse = try CookieController().process(secondRequest)

    let result = "\n\nmmmm oatmeal"

    XCTAssertEqual(secondResponse.body, result)
  }

  func testItCanFormatResponseWithCorrectStatus() throws {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let res = try CookieController().process(request)

    XCTAssertEqual(res.statusCode, "200 OK")
  }
}
