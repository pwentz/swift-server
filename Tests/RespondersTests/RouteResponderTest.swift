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

  // Gets

    func testItCanGetContentWithACookiePrefix() {
      let rawRequest = "GET /someRoute HTTP/1.1\r\nCookie: type=oatmeal"
      let request = HTTPRequest(for: rawRequest)!

      let data = ResourceData(["/someRoute": "this is a file.".toData])

      let route = Route(cookiePrefix: "neat", allowedMethods: [.Get])
      let routes = ["/someRoute": route]

      let response = RouteResponder(routes: routes, data: data).getResponse(to: request)
      let expected = [
        "this is a file.",
        "neat oatmeal"
      ].joined(separator: "\n\n")

      XCTAssertEqual(response.body!, expected.toBytes)
    }

    func testItCanGetContentWithCookiePrefixAndLogsIncluded() {
      let rawRequest = "GET /someRoute HTTP/1.1\r\nCookie: type=oatmeal"
      let request = HTTPRequest(for: rawRequest)!

      let data = ResourceData(["/someRoute": "this is a file.".toData])

      let route = Route(cookiePrefix: "neat", includeLogs: true, allowedMethods: [.Get])
      let routes = ["/someRoute": route]

      let response = RouteResponder(routes: routes, data: data).getResponse(to: request)
      let expected = [
        "this is a file.",
        "neat oatmeal",
        "GET /someRoute HTTP/1.1",
      ].joined(separator: "\n\n")

      XCTAssertEqual(response.body!, expected.toBytes)
    }

    func testItCanGetContentWithCookiePrefixAndDirectoryLinksAndLogsIncluded() {
      let rawRequest = "GET /someRoute HTTP/1.1\r\nCookie: type=oatmeal"
      let request = HTTPRequest(for: rawRequest)!

      let data = ResourceData(["/someRoute": "this is a file.".toData])

      let route = Route(cookiePrefix: "neat", includeLogs: true, allowedMethods: [.Get], includeDirectoryLinks: true)
      let routes = ["/someRoute": route]

      let response = RouteResponder(routes: routes, data: data).getResponse(to: request)
      let expected = [
        "this is a file.",
        "neat oatmeal",
        "GET /someRoute HTTP/1.1",
        "<a href=\"/someRoute\">someRoute</a>"
      ].joined(separator: "\n\n")

      XCTAssertEqual(response.body!, expected.toBytes)
    }

  // Data manipulation

    func testItReturnsEmptyResponseBodyIfNoContent() {
      let rawRequest = "GET /someRoute HTTP/1.1"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(allowedMethods: [.Get])
      let routes = ["/someRoute": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertNil(response.body)
    }

    func testItCanCreateNewDataWithPost() {
      let postRequest = HTTPRequest(for: "POST /someRoute HTTP/1.1\r\ncheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let route = Route(allowedMethods: [.Get, .Post])
      let routes = ["/someRoute": route]

      let responder = RouteResponder(routes: routes)
      let _ = responder.getResponse(to: postRequest)
      let response = responder.getResponse(to: getRequest)

      XCTAssertEqual(response.body!, "cheese".toBytes)
    }

    func testItCanUpdateExistingRouteDataWithPut() {
      let putRequest = HTTPRequest(for: "PUT /someRoute HTTP/1.1\r\nupdated cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let data = ResourceData(["/someRoute": "cheese".toData])

      let route = Route(allowedMethods: [.Get, .Put])
      let routes = ["/someRoute": route]

      let responder = RouteResponder(routes: routes, data: data)
      let _ = responder.getResponse(to: putRequest)
      let response = responder.getResponse(to: getRequest)

      XCTAssertEqual(response.body!, "updated cheese".toBytes)
    }

    func testItCanRemoveExistingRouteDataWithDelete() {
      let deleteRequest = HTTPRequest(for: "DELETE /someRoute HTTP/1.1")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let data = ResourceData(["/someRoute": "cheese".toData])

      let route = Route(allowedMethods: [.Get, .Delete])
      let routes = ["/someRoute": route]

      let responder = RouteResponder(routes: routes, data: data)
      let _ = responder.getResponse(to: deleteRequest)
      let response = responder.getResponse(to: getRequest)

      XCTAssertNil(response.body)
    }

    func testItCanUpdateExistingDataWithPatch() {
      let patchRequest = HTTPRequest(for: "PATCH /someRoute HTTP/1.1\r\nnew cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let data = ResourceData(["/someRoute": "cheese".toData])

      let route = Route(allowedMethods: [.Get, .Patch])
      let routes = ["/someRoute": route]

      let responder = RouteResponder(routes: routes, data: data)
      let _ = responder.getResponse(to: patchRequest)
      let response = responder.getResponse(to: getRequest)

      XCTAssertEqual(response.body!, "new cheese".toBytes)
    }

    func testItSendsA204StatusInResponseToPatch() {
      let patchRequest = HTTPRequest(for: "PATCH /someRoute HTTP/1.1\r\nnew cheese")!

      let route = Route(allowedMethods: [.Patch])
      let routes = ["/someRoute": route]

      let responder = RouteResponder(routes: routes)
      let response = responder.getResponse(to: patchRequest)

      XCTAssertEqual(response.statusCode, "204 No Content")
    }

  // Other request methods

    func testItReturnsAllowedMethodsOnOptionsRequest() {
      let request = HTTPRequest(for: "OPTIONS /someRoute HTTP/1.1")!

      let route = Route(allowedMethods: [.Options, .Post, .Head])
      let routes = ["/someRoute": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.headers["Allow"]!, "OPTIONS,POST,HEAD")
    }

    func testItCanHandleHeadRequests() {
      let request = HTTPRequest(for: "HEAD /someRoute HTTP/1.1")!

      let route = Route(allowedMethods: [.Head])
      let routes = ["/someRoute": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }


  // Edge Cases
    func testItCanUpdateNonExistingData() {
      let putRequest = HTTPRequest(for: "PUT /someRoute HTTP/1.1\r\nupdated cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let route = Route(allowedMethods: [.Get, .Put])
      let routes = ["/someRoute": route]

      let responder = RouteResponder(routes: routes)
      let putResponse = responder.getResponse(to: putRequest)
      let getResponse = responder.getResponse(to: getRequest)

      XCTAssertEqual(putResponse.statusCode, "201 Created")
      XCTAssertEqual(getResponse.body!, "updated cheese".toBytes)
    }

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

    func testItDoesNotAppendAdditionalDataToImage() {
      let rawRequest = "GET /someRoute.jpeg HTTP/1.1\r\nCookie: type=oatmeal"
      let request = HTTPRequest(for: rawRequest)!

      let data = ResourceData(["/someRoute.jpeg": "this is an image file".toData])

      let route = Route(cookiePrefix: "neat", includeLogs: true, allowedMethods: [.Get], includeDirectoryLinks: true)
      let routes = ["/someRoute.jpeg": route]

      let response = RouteResponder(routes: routes, data: data).getResponse(to: request)

      XCTAssertEqual(response.body!, "this is an image file".toBytes)
    }

    func testItDoesNotAppendHTMLDataWhenContentTypeIsText() {
      let request = HTTPRequest(for: "GET /someRoute.txt HTTP/1.1")!

      let data = ResourceData(["/someRoute.txt": "this is an image file".toData])

      let route = Route(allowedMethods: [.Get], includeDirectoryLinks: true)
      let routes = ["/someRoute.txt": route]

      let response = RouteResponder(routes: routes, data: data).getResponse(to: request)

      XCTAssertEqual(response.body!, "this is an image file".toBytes)
    }
}
