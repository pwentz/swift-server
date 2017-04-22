import XCTest
@testable import Responders
import Util
import Requests
import Responses
import Routes

class TwoHundredResponderTest: XCTestCase {
  let ok = TwoHundred.Ok
  // Compound Routes
    func testItCanGetContentWithACookiePrefix() {
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\nCookie: type=oatmeal\r\n\r\n")!

      let data = ResourceData(["/someRoute": "this is a file."])

      let route = Route(allowedMethods: [.Get], cookiePrefix: "neat")

      let response = TwoHundredResponder(route: route, data: data).response(to: request)

      let expectedResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "text/html"],
        body: ["this is a file.", "neat oatmeal"].joined(separator: "\n\n")
      )

      XCTAssertEqual(response, expectedResponse)
    }

    func testItCanGetContentWithCookiePrefixAndLogsIncluded() {
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\nCookie: type=oatmeal\r\n\r\n")!

      let data = ResourceData(["/someRoute": "this is a file."])

      let route = Route(allowedMethods: [.Get], cookiePrefix: "neat", includeLogs: true)
      let logs = ["GET /someRoute HTTP/1.1"]

      let responder = TwoHundredResponder(route: route, data: data, logs: logs)
      let response = responder.response(to: request)

      let expectedResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "text/html"],
        body: [
          "this is a file.",
          "neat oatmeal",
          "GET /someRoute HTTP/1.1"
        ].joined(separator: "\n\n")
      )

      XCTAssertEqual(response, expectedResponse)
    }

    func testItCanGetContentWithCookiePrefixAndDirectoryLinksAndLogsIncluded() {
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\nCookie: type=oatmeal\r\n\r\n")!

      let data = ResourceData(["/someRoute": "this is a file."])

      let route = Route(allowedMethods: [.Get], cookiePrefix: "neat", includeLogs: true, includeDirectoryLinks: true)
      let logs = ["GET /someRoute HTTP/1.1"]

      let responder = TwoHundredResponder(route: route, data: data, logs: logs)
      let response = responder.response(to: request)

      let expectedResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "text/html"],
        body: [
          "this is a file.",
          "neat oatmeal",
          "GET /someRoute HTTP/1.1",
          "<a href=\"/someRoute\">someRoute</a>"
        ].joined(separator: "\n\n")
      )

      XCTAssertEqual(response, expectedResponse)
    }

  // CRUD functionality
    func testItCanDeliverContentsWithoutExtension() {
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\n\r\n")!
      let data = ResourceData(
        ["/someRoute": "I'm a file"]
      )

      let route = Route(allowedMethods: [.Get])

      let response = TwoHundredResponder(route: route, data: data).response(to: request)

      let expectedResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "text/html"],
        body: "I'm a file"
      )

      XCTAssertEqual(response, expectedResponse)
    }

    func testItReturnsEmptyResponseBodyIfNoContent() {
      let request = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\n\r\n")!

      let route = Route(allowedMethods: [.Get])

      let response = TwoHundredResponder(route: route).response(to: request)

      XCTAssertNil(response.body)
    }

    func testItCanCreateNewDataWithPost() {
      let postRequest = HTTPRequest(for: "POST /someRoute HTTP/1.1\r\n\r\ncheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\n\r\n")!

      let route = Route(allowedMethods: [.Get, .Post])

      let responder = TwoHundredResponder(route: route)
      let _ = responder.response(to: postRequest)
      let response = responder.response(to: getRequest)

      let expectedResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "text/html"],
        body: "cheese"
      )

      XCTAssertEqual(response, expectedResponse)
    }

    func testItCanUpdateExistingRouteDataWithPut() {
      let putRequest = HTTPRequest(for: "PUT /someRoute HTTP/1.1\r\n\r\nupdated cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\n\r\n")!

      let data = ResourceData(["/someRoute": "cheese"])

      let route = Route(allowedMethods: [.Get, .Put])

      let responder = TwoHundredResponder(route: route, data: data)
      let _ = responder.response(to: putRequest)
      let response = responder.response(to: getRequest)

      let expectedResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "text/html"],
        body: "updated cheese"
      )

      XCTAssertEqual(response, expectedResponse)
    }

    func testItCanRemoveExistingRouteDataWithDelete() {
      let deleteRequest = HTTPRequest(for: "DELETE /someRoute HTTP/1.1\r\n\r\n")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\n\r\n")!

      let data = ResourceData(["/someRoute": "cheese"])

      let route = Route(allowedMethods: [.Get, .Delete])

      let responder = TwoHundredResponder(route: route, data: data)
      let _ = responder.response(to: deleteRequest)
      let response = responder.response(to: getRequest)

      let expectedResponse = HTTPResponse(status: ok)

      XCTAssertEqual(response, expectedResponse)
    }

    func testItCanUpdateExistingDataWithPatch() {
      let patchRequest = HTTPRequest(for: "PATCH /someRoute HTTP/1.1\r\n\r\nnew cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\n\r\n")!

      let data = ResourceData(["/someRoute": "cheese"])

      let route = Route(allowedMethods: [.Get, .Patch])

      let responder = TwoHundredResponder(route: route, data: data)
      let _ = responder.response(to: patchRequest)
      let response = responder.response(to: getRequest)

      let expectedResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "text/html"],
        body: "new cheese"
      )

      XCTAssertEqual(response, expectedResponse)
    }

    func testItSendsETagInHeaderIfPresentInRequest() {
      let patchRequest = HTTPRequest(for: "PATCH /someRoute HTTP/1.1\r\nIf-Match: abcde\r\n\r\nnew cheese")!

      let data = ResourceData(["/someRoute": "cheese"])

      let route = Route(allowedMethods: [.Get, .Patch])

      let responder = TwoHundredResponder(route: route, data: data)
      let response = responder.response(to: patchRequest)

      let expectedResponse = HTTPResponse(
        status: TwoHundred.NoContent,
        headers: ["ETag": "abcde"]
      )

      XCTAssertEqual(response, expectedResponse)
    }

  // Other request methods
    func testItReturnsAllowedMethodsOnOptionsRequest() {
      let request = HTTPRequest(for: "OPTIONS /someRoute HTTP/1.1\r\n\r\n")!

      let route = Route(allowedMethods: [.Options, .Post, .Head])

      let response = TwoHundredResponder(route: route).response(to: request)

      let expectedResponse = HTTPResponse(
        status: TwoHundred.Ok,
        headers: ["Allow": "OPTIONS,POST,HEAD"]
      )

      XCTAssertEqual(response, expectedResponse)
    }

    func testItCanHandleHeadRequests() {
      let request = HTTPRequest(for: "HEAD /someRoute HTTP/1.1\r\n\r\n")!

      let route = Route(allowedMethods: [.Head])

      let response = TwoHundredResponder(route: route).response(to: request)

      let expectedResponse = HTTPResponse(status: ok)

      XCTAssertEqual(response, expectedResponse)
    }

  // Edge cases
    func testItCanUpdateNonExistingData() {
      let putRequest = HTTPRequest(for: "PUT /someRoute HTTP/1.1\r\n\r\nupdated cheese")!
      let getRequest = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\n\r\n")!

      let route = Route(allowedMethods: [.Get, .Put])

      let responder = TwoHundredResponder(route: route)
      let putResponse = responder.response(to: putRequest)
      let getResponse = responder.response(to: getRequest)

      let expectedGetResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "text/html"],
        body: "updated cheese"
      )

      XCTAssertEqual(putResponse.status.description, "201 Created")
      XCTAssertEqual(getResponse, expectedGetResponse)
    }

    func testItDoesNotAppendAdditionalDataToImage() {
      let request = HTTPRequest(for: "GET /someRoute.jpeg HTTP/1.1\r\nCookie: type=oatmeal\r\n\r\n")!

      let data = ResourceData(["/someRoute.jpeg": "this is an image file"])

      let route = Route(allowedMethods: [.Get], cookiePrefix: "neat", includeLogs: true, includeDirectoryLinks: true)

      let response = TwoHundredResponder(route: route, data: data).response(to: request)

      let expectedResponse = HTTPResponse(
        status: ok,
        headers: ["Content-Type": "image/jpeg"],
        body: "this is an image file"
      )

      XCTAssertEqual(response, expectedResponse)
    }

}
