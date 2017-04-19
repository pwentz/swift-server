import XCTest
@testable import Responders
import Util
import Requests
import Responses
import Routes

class RouteResponderTest: XCTestCase {

  // Early Returns
    func testItReturnsA404IfRouteIsNotSpecified() {
      let rawRequest = "GET /someRoute HTTP/1.1"
      let request = HTTPRequest(for: rawRequest)!
      let route = Route(auth: "XYZ", allowedMethods: [.Get])
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "404 Not Found")
    }

    func testItReturnsA405IfMethodIsNotSpecifiedInRoute() {
      let rawRequest = "POST /logs HTTP/1.1"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(allowedMethods: [.Get])
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "405 Method Not Allowed")
    }

    func testItReturnsA401IfRouteAuthDoesNotMatchCredentialsInRequest() {
      let rawRequest = "GET /logs HTTP/1.1\r\nAuthorization: Basic someencodedstuff=="
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: "XYZ", allowedMethods: [.Get])
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "401 Unauthorized")
    }

    func testItReturnsA302IfRedirectRouteIsSpecified() {
      let rawRequest = "GET /logs HTTP/1.1"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(allowedMethods: [.Get], redirectPath: "/redirect")
      let redirectRoute = Route(allowedMethods: [.Get])
      let routes = ["/logs": route, "/redirect": redirectRoute]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "302 Found")
    }

    func testItReturnsACustomResponseIfSpecified() {
      let rawRequest = "GET /logs HTTP/1.1"
      let request = HTTPRequest(for: rawRequest)!

      let customResponse = HTTPResponse(status: FourHundred.Teapot, body: "ponies")

      let route = Route(allowedMethods: [.Get], customResponse: customResponse)
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response, customResponse)
    }

    func testItReturnsAValidResponseOtherwise() {
      let rawRequest = "GET /logs HTTP/1.1"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(allowedMethods: [.Get])
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

  // Edge Cases

    func testItDoesNotAppendToLogsOnInvalidRequestVerb() {
      let invalidRequest = HTTPRequest(for: "HELLO /someRoute HTTP/1.1")!
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let route = Route(includeLogs: true, allowedMethods: [.Get])
      let routes = ["/someRoute": route]

      let responder = RouteResponder(routes: routes)

      let _ = responder.getResponse(to: invalidRequest)
      let response = responder.getResponse(to: request)

      let expected = "GET /someRoute HTTP/1.1"

      XCTAssertEqual(response.body!, expected.toBytes)
    }

}
