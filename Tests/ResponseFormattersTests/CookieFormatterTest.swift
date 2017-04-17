import XCTest
@testable import ResponseFormatters
import Requests
import Responses

class CookieFormatterTest: XCTestCase {
  func testItCanAppendCookiePrefixWhenNoCookieExistsYet() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "Eat"

    CookieFormatter(for: request, prefix: cookiePrefix).execute(on: &response)

    XCTAssertEqual(response.body!, "\n\nEat".toBytes)
  }

  func testItCanAddSetCookieHeaderToResponse() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "Eat"

    CookieFormatter(for: request, prefix: cookiePrefix).execute(on: &response)

    XCTAssertEqual(response.headers["Set-Cookie"]!, "type=chocolate")
  }

  func testItCanAppendCookiePrefixAfterCookieIsSet() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "wow"

    CookieFormatter(for: request, prefix: cookiePrefix).execute(on: &response)

    XCTAssertEqual(response.body!, "\n\nwow chocolate".toBytes)
  }

  func testItWillNotAppendIfNoCookieHeader() {
    let rawRequest = "GET /eat_cookie HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)
    let cookiePrefix = "wow"

    CookieFormatter(for: request, prefix: cookiePrefix).execute(on: &response)

    XCTAssertNil(response.body)
  }

}
