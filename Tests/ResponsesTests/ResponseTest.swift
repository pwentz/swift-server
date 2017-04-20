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

  func testItHasABody() {
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = HTTPResponse(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.body!.toBytes, body.toBytes)
  }

  func testItCanFormatItsHeaders() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let body = "BODY"

    let response = HTTPResponse(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.headers!, headers)
  }

  func testItCanFormatItselfWithExistingBody() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let rawHeaders = "Content-Type:text/html\r\nWWW-Authenticate:Basic realm=\"simple\""
    let body = "BODY"
    let formattedStatus = "HTTP/1.1 200 OK\r\n".toBytes
    let formattedHeaders = rawHeaders.toBytes
    let formattedBody = "\n\n\(body)".toBytes
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

  func testItCanBeRepresentedByAString() {
    let headers = ["Content-Type": "ABCD"]

    let response = HTTPResponse(status: ok, headers: headers)
    let expected = "HTTP/1.1 200 OK\r\nContent-Type:ABCD"

    XCTAssertEqual(String(response: response), expected)
  }
}
