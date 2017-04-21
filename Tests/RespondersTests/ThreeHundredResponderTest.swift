import XCTest
import Requests
import Routes
import Responses
@testable import Responders

class ThreeHundredResponderTest: XCTestCase {
  func testItReturnsARedirectRoute() {
    let request = HTTPRequest(for: "GET /someRoute HTTP/1.1\r\n")!

    let responder = ThreeHundredResponder(redirectPath: "/")

    let response = responder.response(to: request)
    let expectedResponse = HTTPResponse(status: ThreeHundred.Found, headers: ["Location": "/"])

    XCTAssertEqual(response, expectedResponse)
  }
}
