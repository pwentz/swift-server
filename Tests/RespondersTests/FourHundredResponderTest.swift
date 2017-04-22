import XCTest
@testable import Responders
import Routes
import Responses
import Requests
import Util

class FourHundredResponderTest: XCTestCase {
  let route = Route(allowedMethods: [.Get], auth: "XYZ", redirectPath: "/")

  func testItReturns401WhenAuthDoesntMatch() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\nAuthorization: Basic ABC\r\n\r\n"
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
    let request = HTTPRequest(for: "POST /someRoute HTTP/1.1\r\n\r\ndata=wow")!

    let route = Route(allowedMethods: [.Get])

    let responder = FourHundredResponder(route: route)

    let response = responder.response(to: request)
    let expectedResponse = HTTPResponse(status: FourHundred.MethodNotAllowed)

    XCTAssertEqual(response, expectedResponse)
  }

  func testItReturnsABadRequestIfPostPatchOrPutIsMissingBody() {
    let invalidPostRequest = HTTPRequest(for: "POST /someRoute HTTP/1.1\r\n\r\n")!
    let invalidPutRequest = HTTPRequest(for: "PUT /someRoute HTTP/1.1\r\n\r\n")!
    let invalidPatchRequest = HTTPRequest(for: "PATCH /someRoute HTTP/1.1\r\n\r\n")!

    let route = Route(allowedMethods: [.Post, .Put, .Patch])

    let responder = FourHundredResponder(route: route)

    let postResponse = responder.response(to: invalidPostRequest)
    let putResponse = responder.response(to: invalidPutRequest)
    let patchResponse = responder.response(to: invalidPatchRequest)

    let expectedResponse = HTTPResponse(status: FourHundred.BadRequest)

    XCTAssertEqual(postResponse, expectedResponse)
    XCTAssertEqual(putResponse, expectedResponse)
    XCTAssertEqual(patchResponse, expectedResponse)
  }

  func testItReturnsA416IfGivenEndRangeIsOutOfBounds() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\nRange: bytes=5-80\r\n\r\n"
    let request = HTTPRequest(for: rawRequest)!

    let route = Route(allowedMethods: [.Get])
    let content = "content less than 80 chars"

    let contentLength = content.count - 1

    let data = ResourceData(
      ["/someRoute": content]
    )

    let responder = FourHundredResponder(route: route, data: data)
    let response = responder.response(to: request)

    let expectedResponse = HTTPResponse(
      status: FourHundred.RangeNotSatisfiable,
      headers: ["Content-Range": "bytes */\(contentLength)"]
    )

    XCTAssertEqual(response, expectedResponse)
  }

  func testItReturnsA416IfGivenStartRangeIsOutOfBounds() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\nRange: bytes=80-5\r\n\r\n"
    let request = HTTPRequest(for: rawRequest)!

    let route = Route(allowedMethods: [.Get])
    let content = "content less than 80 chars"

    let contentLength = content.characters.count - 1

    let data = ResourceData(
      ["/someRoute": content]
    )

    let responder = FourHundredResponder(route: route, data: data)
    let response = responder.response(to: request)

    let expectedResponse = HTTPResponse(
      status: FourHundred.RangeNotSatisfiable,
      headers: ["Content-Range": "bytes */\(contentLength)"]
    )

    XCTAssertEqual(response, expectedResponse)
  }
}
