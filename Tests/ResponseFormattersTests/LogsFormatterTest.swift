import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class LogsFormatterTest: XCTestCase {
  func testItAppendsLogsToBodyIfGivenLogs() {
    var response = HTTPResponse(status: TwoHundred.Ok)
    let existingLogs = ["GET /someRoute HTTP/1.1"]

    let logsFormatter = LogsFormatter(logs: existingLogs)
    logsFormatter.execute(on: &response)

    let expected = "GET /someRoute HTTP/1.1"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItDoesNotAppendWhenLogsIsNil() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let logsFormatter = LogsFormatter(logs: nil)
    logsFormatter.execute(on: &response)

    XCTAssertNil(response.body)
  }
}
