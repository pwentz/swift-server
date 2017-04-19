import XCTest
@testable import Responders
import Util
import Requests
import Responses
import Routes

class TwoHundredResponderTest: XCTestCase {
  // Compound Routes
    func testItCanGetContentWithACookiePrefix() {
      let rawRequest = "GET /someRoute HTTP/1.1\r\nCookie: type=oatmeal"
      let request = HTTPRequest(for: rawRequest)!

      let data = ResourceData(["/someRoute": "this is a file.".toData])

      let route = Route(cookiePrefix: "neat", allowedMethods: [.Get])

      let response = TwoHundredResponder(route: route, data: data).response(to: request)
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
      let logs = ["GET /someRoute HTTP/1.1"]

      let responder = TwoHundredResponder(route: route, data: data, logs: logs)
      let response = responder.response(to: request)
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
      let logs = ["GET /someRoute HTTP/1.1"]

      let responder = TwoHundredResponder(route: route, data: data, logs: logs)
      let response = responder.response(to: request)

      let expected = [
        "this is a file.",
        "neat oatmeal",
        "GET /someRoute HTTP/1.1",
        "<a href=\"/someRoute\">someRoute</a>"
      ].joined(separator: "\n\n")

      XCTAssertEqual(response.body!, expected.toBytes)
    }

  // CRUD functionality
    func testItCanDeliverContentsWithoutExtension() {
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1")!
      let data = ResourceData(
        ["/someRoute": "I'm a file".toData]
      )

      let route = Route(allowedMethods: [.Get])

      let response = TwoHundredResponder(route: route, data: data).response(to: request)

      XCTAssertEqual(response.body!, "I'm a file".toBytes)
    }

    func testItReturnsEmptyResponseBodyIfNoContent() {
      let rawRequest = "GET /someRoute HTTP/1.1"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(allowedMethods: [.Get])

      let response = TwoHundredResponder(route: route).response(to: request)

      XCTAssertNil(response.body)
    }

    func testItCanCreateNewDataWithPost() {
      let postRequest = HTTPRequest(for: "POST /someRoute HTTP/1.1\r\ncheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let route = Route(allowedMethods: [.Get, .Post])

      let responder = TwoHundredResponder(route: route)
      let _ = responder.response(to: postRequest)
      let response = responder.response(to: getRequest)

      XCTAssertEqual(response.body!, "cheese".toBytes)
    }

    func testItCanUpdateExistingRouteDataWithPut() {
      let putRequest = HTTPRequest(for: "PUT /someRoute HTTP/1.1\r\nupdated cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let data = ResourceData(["/someRoute": "cheese".toData])

      let route = Route(allowedMethods: [.Get, .Put])

      let responder = TwoHundredResponder(route: route, data: data)
      let _ = responder.response(to: putRequest)
      let response = responder.response(to: getRequest)

      XCTAssertEqual(response.body!, "updated cheese".toBytes)
    }

    func testItCanRemoveExistingRouteDataWithDelete() {
      let deleteRequest = HTTPRequest(for: "DELETE /someRoute HTTP/1.1")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let data = ResourceData(["/someRoute": "cheese".toData])

      let route = Route(allowedMethods: [.Get, .Delete])

      let responder = TwoHundredResponder(route: route, data: data)
      let _ = responder.response(to: deleteRequest)
      let response = responder.response(to: getRequest)

      XCTAssertNil(response.body)
    }

    func testItCanUpdateExistingDataWithPatch() {
      let patchRequest = HTTPRequest(for: "PATCH /someRoute HTTP/1.1\r\nnew cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let data = ResourceData(["/someRoute": "cheese".toData])

      let route = Route(allowedMethods: [.Get, .Patch])

      let responder = TwoHundredResponder(route: route, data: data)
      let _ = responder.response(to: patchRequest)
      let response = responder.response(to: getRequest)

      XCTAssertEqual(response.body!, "new cheese".toBytes)
    }

    func testItSendsETagInHeaderIfPresentInRequest() {
      let patchRequest = HTTPRequest(for: "PATCH /someRoute HTTP/1.1\r\nIf-Match: abcde\r\nnew cheese")!

      let data = ResourceData(["/someRoute": "cheese".toData])

      let route = Route(allowedMethods: [.Get, .Patch])

      let responder = TwoHundredResponder(route: route, data: data)
      let response = responder.response(to: patchRequest)

      XCTAssertEqual(response.headers["ETag"]!, "abcde")
    }

    func testItSendsA204StatusInResponseToPatch() {
      let patchRequest = HTTPRequest(for: "PATCH /someRoute HTTP/1.1\r\nnew cheese")!

      let route = Route(allowedMethods: [.Patch])

      let responder = TwoHundredResponder(route: route)
      let response = responder.response(to: patchRequest)

      XCTAssertEqual(response.statusCode, "204 No Content")
    }

  // Other request methods
    func testItReturnsAllowedMethodsOnOptionsRequest() {
      let request = HTTPRequest(for: "OPTIONS /someRoute HTTP/1.1")!

      let route = Route(allowedMethods: [.Options, .Post, .Head])

      let response = TwoHundredResponder(route: route).response(to: request)

      XCTAssertEqual(response.headers["Allow"]!, "OPTIONS,POST,HEAD")
    }

    func testItCanHandleHeadRequests() {
      let request = HTTPRequest(for: "HEAD /someRoute HTTP/1.1")!

      let route = Route(allowedMethods: [.Head])

      let response = TwoHundredResponder(route: route).response(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

  // Edge cases
    func testItCanUpdateNonExistingData() {
      let putRequest = HTTPRequest(for: "PUT /someRoute HTTP/1.1\r\nupdated cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1")!

      let route = Route(allowedMethods: [.Get, .Put])

      let responder = TwoHundredResponder(route: route)
      let putResponse = responder.response(to: putRequest)
      let getResponse = responder.response(to: getRequest)

      XCTAssertEqual(putResponse.statusCode, "201 Created")
      XCTAssertEqual(getResponse.body!, "updated cheese".toBytes)
    }

    func testItDoesNotAppendAdditionalDataToImage() {
      let rawRequest = "GET /someRoute.jpeg HTTP/1.1\r\nCookie: type=oatmeal"
      let request = HTTPRequest(for: rawRequest)!

      let data = ResourceData(["/someRoute.jpeg": "this is an image file".toData])

      let route = Route(cookiePrefix: "neat", includeLogs: true, allowedMethods: [.Get], includeDirectoryLinks: true)

      let response = TwoHundredResponder(route: route, data: data).response(to: request)

      XCTAssertEqual(response.body!, "this is an image file".toBytes)
    }
}
