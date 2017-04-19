import XCTest
import Requests
import Routes
import Responses
@testable import Responders

class ThreeHundredResponderTest: XCTestCase {
  func testItReturnsARedirectRoute() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!

    let responder = ThreeHundredResponder(redirectPath: "/")

    let response = responder.response(to: request)
    let expectedResponse = HTTPResponse(status: ThreeHundred.Found, headers: ["Location": "/"])

    XCTAssertEqual(response, expectedResponse)
  }
}
