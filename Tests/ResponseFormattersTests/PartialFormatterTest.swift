import XCTest
@testable import ResponseFormatters
import Responses
import Requests

class PartialFormatterTest: XCTestCase {
  func testItCanUpdateBodyOnResponseGivenRangeStart() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=4-\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let content = "This is a file that contains text to read part of in order to fulfill a 206."
    var response = HTTPResponse(status: TwoHundred.Ok, body: content)

    let partialFormatter = PartialFormatter(for: request.headers["range"])

    partialFormatter.execute(on: &response)
    let expected = " is a file that contains text to read part of in order to fulfill a 206.\n"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItCanUpdateBodyOnResponseGivenRangeEnd() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=-6\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let content = "This is a file that contains text to read part of in order to fulfill a 206."
    var response = HTTPResponse(status: TwoHundred.Ok, body: content)

    let partialFormatter = PartialFormatter(for: request.headers["range"])

    partialFormatter.execute(on: &response)

    let expected = " 206.\n"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItCanUpdateBodyOnResponseGiveRangeStartAndEnd() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=0-4\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let content = "This is a file that contains text to read part of in order to fulfill a 206."
    var response = HTTPResponse(status: TwoHundred.Ok, body: content)

    PartialFormatter(for: request.headers["range"]).execute(on: &response)
    let expected = "This "

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItCanUpdateStatusOnResponse() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=0-4\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let content = "This is a file that contains text to read part of in order to fulfill a 206."
    var response = HTTPResponse(status: TwoHundred.Ok, body: content)

    PartialFormatter(for: request.headers["range"]).execute(on: &response)

    XCTAssertEqual(response.statusCode, "206 Partial Content")
  }
}
