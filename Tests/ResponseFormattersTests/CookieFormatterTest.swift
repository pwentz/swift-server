import XCTest
@testable import ResponseFormatters
import Requests
import Responses

class CookieFormatterTest: XCTestCase {
  let ok = TwoHundred.Ok
  let cookiePrefix = "Eat"

  func testItCanAppendCookiePrefixWhenNoCookieExistsYet() {
    let request = HTTPRequest(for: "GET /cookie?type=chocolate HTTP/1.1\r\n\r\n")!
    let response = HTTPResponse(status: ok)

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: ["Set-Cookie": "type=chocolate"],
      body: "Eat"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanAppendToExistingResponse() {
    let request = HTTPRequest(for: "GET /cookie?type=chocolate HTTP/1.1\r\n\r\n")!
    let response = HTTPResponse(status: ok, headers: ["Content-Type": "text/html"], body: "some stuff")

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: [
        "Set-Cookie": "type=chocolate",
        "Content-Type": "text/html"
      ],
      body: "some stuff\n\nEat"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanPrependCookiePrefixAfterCookieIsSet() {
    let request = HTTPRequest(for: "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\n\r\n")!
    let response = HTTPResponse(status: ok)

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "Eat chocolate"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItPrependsCookiePrefixIfParamsArePresent() {
    let request = HTTPRequest(for: "GET /eat_cookie?type=oatmeal HTTP/1.1\r\nCookie: type=chocolate\r\n\r\n")!
    let response = HTTPResponse(status: ok)

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: ["Set-Cookie": "type=oatmeal"],
      body: "Eat chocolate"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItWillNotAppendIfNoCookieHeader() {
    let request = HTTPRequest(for: "GET /eat_cookie HTTP/1.1\r\n\r\n")!
    let response = HTTPResponse(status: ok)
    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    XCTAssertNil(newResponse.body)
  }

}
