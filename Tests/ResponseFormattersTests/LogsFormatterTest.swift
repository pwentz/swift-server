import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class LogsFormatterTest: XCTestCase {
  func testItReturnsNewBodyWithLogsIfGivenLogs() {
    let response = HTTPResponse(status: TwoHundred.Ok)
    let existingLogs = ["GET /someRoute HTTP/1.1"]

    let newResponse = LogsFormatter(logs: existingLogs).addToResponse(response)

    let expected = "GET /someRoute HTTP/1.1"

    XCTAssertEqual(newResponse.body!, expected.toBytes)
  }

  func testItAppendsLogsToExistingBody() {
    let response = HTTPResponse(status: TwoHundred.Ok, body: "neat")
    let existingLogs = ["GET /someRoute HTTP/1.1"]

    let newResponse = LogsFormatter(logs: existingLogs).addToResponse(response)

    let expected = "neat\n\nGET /someRoute HTTP/1.1"

    XCTAssertEqual(newResponse.body!, expected.toBytes)
  }

  func testItReturnsExistingBodyIfNoLogsAreGiven() {
    let response = HTTPResponse(status: TwoHundred.Ok, body: "neat")

    let newResponse = LogsFormatter(logs: nil).addToResponse(response)

    XCTAssertEqual(newResponse.body!, "neat".toBytes)
  }

  func testItReturnsAnEmptyBodyIfBodyWasEmptyAndNoGivenLogs() {
    let response = HTTPResponse(status: TwoHundred.Ok)

    let newResponse = LogsFormatter(logs: nil).addToResponse(response)

    XCTAssertNil(newResponse.body)
  }
}
