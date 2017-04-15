import XCTest
@testable import Responders
import Responses
import Requests

class PartialResponderTest: XCTestCase {
  func testItCanUpdateBodyOnResponseGivenRangeStart() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=4-\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let content = "This is a file that contains text to read part of in order to fulfill a 206."
    var response = HTTPResponse(status: TwoHundred.Ok, body: content)

    let partialResponder = PartialResponder(for: request)

    partialResponder.execute(on: &response)
    let expected = "\n\n is a file that contains text to read part of in order to fulfill a 206.\n"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItCanUpdateBodyOnResponseGivenRangeEnd() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=-6\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let content = "This is a file that contains text to read part of in order to fulfill a 206."
    var response = HTTPResponse(status: TwoHundred.Ok, body: content)

    let partialResponder = PartialResponder(for: request)

    partialResponder.execute(on: &response)

    let expected = "\n\n 206.\n"

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItCanUpdateBodyOnResponseGiveRangeStartAndEnd() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=0-4\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let content = "This is a file that contains text to read part of in order to fulfill a 206."
    var response = HTTPResponse(status: TwoHundred.Ok, body: content)

    PartialResponder(for: request).execute(on: &response)
    let expected = "\n\nThis "

    XCTAssertEqual(response.body!, expected.toBytes)
  }

  func testItCanUpdateStatusOnResponse() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=0-4\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let content = "This is a file that contains text to read part of in order to fulfill a 206."
    var response = HTTPResponse(status: TwoHundred.Ok, body: content)

    PartialResponder(for: request).execute(on: &response)

    XCTAssertEqual(response.statusCode, "206 Partial Content")
  }
}
