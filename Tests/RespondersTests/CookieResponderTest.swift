import XCTest
@testable import Responders
import Routes
import Requests
import Responses

class CookieResponderTest: XCTestCase {
  func testItReturnsResponseWithCorrectBody() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = HTTPResponse(status: TwoHundred.Ok)

    let cookieResponder = CookieResponder(for: request)

    let newResponse = cookieResponder.formatResponse(response)
    let expected = Array("\n\nEat".utf8)

    XCTAssertEqual(newResponse.body!, expected)
  }

  func testItCanBuildOnExistingResponseBody() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let response = HTTPResponse(status: TwoHundred.Ok, body: "GET /cookie HTTP/1.1")

    let cookieResponder = CookieResponder(for: request)

    let newResponse = cookieResponder.formatResponse(response)
    let expected = Array("\n\nGET /cookie HTTP/1.1\n\nEat".utf8)

    XCTAssertEqual(newResponse.body!, expected)
  }

  func testItReturnsAResponseWithSetCookieHeadersWhenSetCookieFlagIsTrue() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let response = HTTPResponse(status: TwoHundred.Ok)

    let cookieResponder = CookieResponder(for: request)

    let newResponse = cookieResponder.formatResponse(response)

    XCTAssertEqual(newResponse.headers["Set-Cookie"]!, "type=chocolate")
  }

  func testItReturnsABadRequestResponseIfSetCookieIsTrueButNoCookieProvided() {
    let rawRequest = "GET /cookie HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let response = HTTPResponse(status: TwoHundred.Ok)

    let cookieResponder = CookieResponder(for: request)

    let newResponse = cookieResponder.formatResponse(response)

    XCTAssertEqual(newResponse.statusCode, "400 Bad Request")
  }
}
