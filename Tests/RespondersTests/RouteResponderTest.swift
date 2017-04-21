import XCTest
@testable import Responders
import Util
import Requests
import Responses
import Routes

class RouteResponderTest: XCTestCase {

  // Early Returns
    func testItReturnsA404IfRouteIsNotSpecified() {
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1")!
      let route = Route(auth: "XYZ", allowedMethods: [.Get])
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).response(to: request)

      XCTAssertEqual(response.status.description, "404 Not Found")
    }

    func testItReturnsA405IfMethodIsNotSpecifiedInRoute() {
      let request = HTTPRequest(for: "POST /logs HTTP/1.1")!

      let route = Route(allowedMethods: [.Get])
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).response(to: request)

      XCTAssertEqual(response.status.description, "405 Method Not Allowed")
    }

    func testItReturnsA401IfRouteAuthDoesNotMatchCredentialsInRequest() {
      let rawRequest = "GET /logs HTTP/1.1\r\nAuthorization: Basic someencodedstuff=="
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: "XYZ", allowedMethods: [.Get])
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).response(to: request)

      XCTAssertEqual(response.status.description, "401 Unauthorized")
    }

    func testItReturnsA302IfRedirectRouteIsSpecified() {
      let request = HTTPRequest(for: "GET /logs HTTP/1.1")!

      let route = Route(allowedMethods: [.Get], redirectPath: "/redirect")
      let redirectRoute = Route(allowedMethods: [.Get])
      let routes = ["/logs": route, "/redirect": redirectRoute]

      let response = RouteResponder(routes: routes).response(to: request)

      XCTAssertEqual(response.status.description, "302 Found")
    }

    func testItReturnsACustomResponseIfSpecified() {
      let request = HTTPRequest(for: "GET /logs HTTP/1.1")!

      let customResponse = HTTPResponse(status: FourHundred.Teapot, body: "ponies")

      let route = Route(allowedMethods: [.Get], customResponse: customResponse)
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).response(to: request)

      XCTAssertEqual(response, customResponse)
    }

    func testItReturnsAValidResponseOtherwise() {
      let request = HTTPRequest(for: "GET /logs HTTP/1.1")!

      let route = Route(allowedMethods: [.Get])
      let routes = ["/logs": route]

      let response = RouteResponder(routes: routes).response(to: request)

      XCTAssertEqual(response.status.description, "200 OK")
    }

  // Edge Cases

    func testItDoesNotAppendToLogsOnInvalidRequestVerb() {
      let invalidRequest = HTTPRequest(for: "HELLO /someRoute HTTP/1.1")!
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let route = Route(includeLogs: true, allowedMethods: [.Get])
      let routes = ["/someRoute": route]

      let responder = RouteResponder(routes: routes)

      let _ = responder.response(to: invalidRequest)
      let response = responder.response(to: request)

      let expectedResponse = HTTPResponse(
        status: TwoHundred.Ok,
        body: "GET /someRoute HTTP/1.1"
      )

      XCTAssertEqual(response, expectedResponse)
    }

}
