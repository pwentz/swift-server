import XCTest
@testable import Responses

class ResponseTest: XCTestCase {
  let ok = TwoHundred.Ok

  func testItCanCompleteAStatusCode() {
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = HTTPResponse(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.statusCode, "200 OK")
  }

  func testItCanCompleteOtherStatusCodes() {
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = HTTPResponse(status: FourHundred.Teapot, headers: headers, body: body)

    XCTAssertEqual(response.statusCode, "418 I'm a teapot")
  }

  func testItCanFormatItsBody() {
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = HTTPResponse(status: ok, headers: headers, body: body)
    let expected: [UInt8] = Array("\n\n\(body)".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanFormatItsHeaders() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let body = "BODY"

    let response = HTTPResponse(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.headers, headers)
  }

  func testItCanFormatItselfWithExistingBody() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let rawHeaders = "Content-Type:text/html\r\nWWW-Authenticate:Basic realm=\"simple\""
    let body = "BODY"
    let formattedStatus: [UInt8] = Array("HTTP/1.1 200 OK\r\n".utf8)
    let formattedHeaders: [UInt8] = Array(rawHeaders.utf8)
    let formattedBody: [UInt8] = Array("\n\n\(body)".utf8)
    let formattedResponse = formattedStatus + formattedHeaders + formattedBody

    let response = HTTPResponse(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.formatted, formattedResponse)
  }

  func testItCanFormatItselfWithNoBody() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let rawHeaders = "Content-Type:text/html\r\nWWW-Authenticate:Basic realm=\"simple\""
    let formattedStatus: [UInt8] = Array("HTTP/1.1 200 OK\r\n".utf8)
    let formattedHeaders: [UInt8] = Array(rawHeaders.utf8)
    let body: [UInt8] = []
    let formattedResponse = formattedStatus + formattedHeaders + body

    let response = HTTPResponse(status: ok, headers: headers, body: nil)

    XCTAssertEqual(response.formatted, formattedResponse)
  }
}
