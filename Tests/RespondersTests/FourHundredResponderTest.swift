import XCTest
@testable import Responders
import Routes
import Responses
import Requests

class FourHundredResponderTest: XCTestCase {
  let route = Route(auth: "XYZ", allowedMethods: [.Get], redirectPath: "/")

  func testItReturns401WhenAuthDoesntMatch() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\nAuthorization: Basic ABC\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!

    let responder = FourHundredResponder(route: route)

    let response = responder.response(to: request)
    let expectedResponse = HTTPResponse(
      status: FourHundred.Unauthorized,
      headers: ["WWW-Authenticate": "Basic realm=\"simple\""]
    )

    XCTAssertEqual(response, expectedResponse)
  }

  func testItReturnsMethodNotAllowedWhenMethodIsNotInConfig() {
    let rawRequest = "POST /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!

    let route = Route(allowedMethods: [.Get])

    let responder = FourHundredResponder(route: route)

    let response = responder.response(to: request)
    let expectedResponse = HTTPResponse(status: FourHundred.MethodNotAllowed)

    XCTAssertEqual(response, expectedResponse)
  }
}
