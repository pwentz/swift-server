import XCTest
@testable import Responses

class ResponseTest: XCTestCase {
  func testItCanCompleteAStatusCode() {
    let statusCode = 200
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = FormattedResponse(status: statusCode, headers: headers, body: body)

    XCTAssertEqual(response.statusCode, "200 OK")
  }

  func testItCanCompleteOtherStatusCodes() {
    let statusCode = 418
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = FormattedResponse(status: statusCode, headers: headers, body: body)

    XCTAssertEqual(response.statusCode, "418 I'm a teapot")
  }

  func testItCanFormatItsBody() {
    let statusCode = 200
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = FormattedResponse(status: statusCode, headers: headers, body: body)

    XCTAssertEqual(response.body, "\n\n\(body)")
  }

  func testItCanFormatItsHeaders() {
    let statusCode = 200
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let body = "BODY"

    let response = FormattedResponse(status: statusCode, headers: headers, body: body)

    XCTAssertEqual(response.headers, headers)
  }

  func testItCanFormatItself() {
    let statusCode = 200
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let rawHeaders = "Content-Type:text/html\r\nWWW-Authenticate:Basic realm=\"simple\""
    let body = "BODY"
    let formattedStatus: [UInt8] = Array("HTTP/1.1 200 OK\r\n".utf8)
    let formattedHeaders: [UInt8] = Array(rawHeaders.utf8)
    let formattedBody: [UInt8] = Array(("\n\n" + body).utf8)
    let formattedResponse = formattedStatus + formattedHeaders + formattedBody

    let response = FormattedResponse(status: statusCode, headers: headers, body: body)

    XCTAssertEqual(response.formatted, formattedResponse)
  }
}
