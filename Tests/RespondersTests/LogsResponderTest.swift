import XCTest
import Requests
import Responses
@testable import Responders

class LogsResponderTest: XCTestCase {
  func testItAppendsLogsToBodyIfGivenLogs() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    var response = HTTPResponse(status: TwoHundred.Ok)
    let existingLogs = ["GET /someRoute HTTP/1.1"]

    let logsResponder = LogsResponder(for: request, logs: existingLogs)
    logsResponder.execute(on: &response)

    let expected = "\n\nGET /someRoute HTTP/1.1"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItDoesNotAppendWhenLogsIsNil() {
    let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    var response = HTTPResponse(status: TwoHundred.Ok)

    let logsResponder = LogsResponder(for: request, logs: nil)
    logsResponder.execute(on: &response)

    XCTAssertNil(response.body)
  }
}
