import XCTest
@testable import ResponseFormatters
import Requests
import Responses

class CookieFormatterTest: XCTestCase {
  func testItCanAppendCookiePrefixWhenNoCookieExistsYet() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "Eat"

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    XCTAssertEqual(newResponse.body!, "Eat".toBytes)
  }

  func testItCanAppendCookiePrefixToExistingBody() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok, body: "some stuff")
    let cookiePrefix = "Eat"

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    XCTAssertEqual(newResponse.body!, "some stuff\n\nEat".toBytes)
  }

  func testItCanAddSetCookieHeaderToResponse() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "Eat"

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    XCTAssertEqual(newResponse.headers["Set-Cookie"]!, "type=chocolate")
  }

  func testItCanAddSetCookieHeaderToExistingResponseHeaders() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok, headers: ["Content-Type": "text/html"])
    let cookiePrefix = "Eat"

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    XCTAssertEqual(newResponse.headers, ["Content-Type": "text/html", "Set-Cookie": "type=chocolate"])
  }

  func testItCanAppendCookiePrefixAfterCookieIsSet() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "wow"

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    XCTAssertEqual(newResponse.body!, "wow chocolate".toBytes)
  }

  func testItCanSetCookieAndRespondWithCookie() {
    let rawRequest = "GET /eat_cookie?type=oatmeal HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "wow"

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    XCTAssertEqual(newResponse.body!, "wow chocolate wow".toBytes)
    XCTAssertEqual(newResponse.headers["Set-Cookie"], "type=oatmeal")
  }

  func testItWillNotAppendIfNoCookieHeader() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "wow"

    let newResponse = CookieFormatter(for: request, prefix: cookiePrefix).addToResponse(response)

    XCTAssertNil(newResponse.body)
  }

}
