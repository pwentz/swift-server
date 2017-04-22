import XCTest
@testable import ResponseFormatters
import Responses
import Requests

class PartialFormatterTest: XCTestCase {
  let ok = TwoHundred.Ok
  let partial = TwoHundred.PartialContent
  let content = "This is a file that contains text to read part of in order to fulfill a 206.\n"

  func testItCanUpdateBodyOnResponseGivenRangeStart() {
    let request = HTTPRequest(for: "GET /partial_content.txt HTTP/1.1\r\nRange:bytes=4-\r\n\r\n")!

    let response = HTTPResponse(status: ok, body: content)

    let partialFormatter = PartialFormatter(for: request.headers["range"])

    let newResponse = partialFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: partial,
      headers: ["Content-Range": "bytes 4-76/77"],
      body: " is a file that contains text to read part of in order to fulfill a 206.\n"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanUpdateBodyOnResponseGivenRangeEnd() {
    let request = HTTPRequest(for: "GET /partial_content.txt HTTP/1.1\r\nRange:bytes=-6\r\n\r\n")!

    let response = HTTPResponse(status: ok, body: content)

    let partialFormatter = PartialFormatter(for: request.headers["range"])

    let newResponse = partialFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: partial,
      headers: ["Content-Range": "bytes 71-76/77"],
      body: " 206.\n"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanUpdateBodyOnResponseGiveRangeStartAndEnd() {
    let request = HTTPRequest(for: "GET /partial_content.txt HTTP/1.1\r\nRange:bytes=0-4\r\n\r\n")!

    let response = HTTPResponse(status: ok, body: content)

    let partialFormatter = PartialFormatter(for: request.headers["range"])
    let newResponse = partialFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: partial,
      headers: ["Content-Range": "bytes 0-4/77"],
      body: "This "
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItReturnsTheResponseAsIsIfNoRangeGiven() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n\r\n"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: ok, body: content)

    let partialFormatter = PartialFormatter(for: request.headers["range"])
    let newResponse = partialFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: content
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }
}
