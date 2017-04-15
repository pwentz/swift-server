import XCTest
@testable import Responders
import Routes
import Responses
import Requests

class FourHundredResponderTest: XCTestCase {
  let route = Route(auth: "XYZ", allowedMethods: [.Get], redirectPath: "/")

  func testItPutsNotFoundRouteAtTopOfList() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!

    let routes = ["/someOtherRoute": route]

    let responder = FourHundredResponder(route: routes["/someRoute"])

    let responses = responder.responses(to: request)

    XCTAssertEqual(responses.first!, HTTPResponse(status: FourHundred.NotFound))
  }

  func testItPlacesCustomResponseSecond() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!

    let expectedResponse = HTTPResponse(status: TwoHundred.Ok, body: "ponies")
    let route = Route(allowedMethods: [.Get], customResponse: expectedResponse)

    let responder = FourHundredResponder(route: route)

    let responses = responder.responses(to: request)
    let expectedIndex = responses.index(responses.startIndex, offsetBy: 1)

    XCTAssertEqual(responses[expectedIndex], expectedResponse)
  }

  func testItPutsUnauthorizedResponseThird() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\nAuthorization: Basic ABC\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!

    let responder = FourHundredResponder(route: route)

    let responses = responder.responses(to: request)
    let expectedIndex = responses.index(responses.startIndex, offsetBy: 2)
    let expectedResponse = HTTPResponse(
      status: FourHundred.Unauthorized,
      headers: ["WWW-Authenticate": "Basic realm=\"simple\""]
    )

    XCTAssertEqual(responses[expectedIndex], expectedResponse)
  }

  func testItPlacesMethodNotAllowedLast() {
    let rawRequest = "POST /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!

    let route = Route(allowedMethods: [.Get])

    let responder = FourHundredResponder(route: route)

    let responses = responder.responses(to: request)
    let expectedIndex = responses.index(responses.startIndex, offsetBy: 3)
    let expectedResponse = HTTPResponse(status: FourHundred.MethodNotAllowed)

    XCTAssertEqual(responses[expectedIndex], expectedResponse)
  }
}
