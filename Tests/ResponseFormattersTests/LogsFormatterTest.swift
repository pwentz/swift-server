import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class LogsFormatterTest: XCTestCase {
  let ok = TwoHundred.Ok

  func testItReturnsNewBodyWithLogsIfGivenLogs() {
    let response = HTTPResponse(status: ok)
    let existingLogs = ["GET /someRoute HTTP/1.1"]

    let newResponse = LogsFormatter(logs: existingLogs).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "GET /someRoute HTTP/1.1"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItAppendsLogsToExistingBody() {
    let response = HTTPResponse(status: ok, body: "neat")
    let existingLogs = ["GET /someRoute HTTP/1.1"]

    let newResponse = LogsFormatter(logs: existingLogs).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "neat\n\nGET /someRoute HTTP/1.1"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItReturnsExistingBodyIfNoLogsAreGiven() {
    let response = HTTPResponse(status: ok, body: "neat")

    let newResponse = LogsFormatter(logs: nil).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "neat"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItReturnsAnEmptyBodyIfBodyWasEmptyAndNoGivenLogs() {
    let response = HTTPResponse(status: ok)

    let newResponse = LogsFormatter(logs: nil).addToResponse(response)

    XCTAssertNil(newResponse.body)
  }
}
