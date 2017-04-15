import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class LogsFormatterTest: XCTestCase {
  func testItAppendsLogsToBodyIfGivenLogs() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)
    let existingLogs = ["GET /someRoute HTTP/1.1"]

    let logsFormatter = LogsFormatter(for: request, logs: existingLogs)
    logsFormatter.execute(on: &response)

    let expected = "\n\nGET /someRoute HTTP/1.1"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItDoesNotAppendWhenLogsIsNil() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let logsFormatter = LogsFormatter(for: request, logs: nil)
    logsFormatter.execute(on: &response)

    XCTAssertNil(response.body)
  }
}