import XCTest
@testable import Responses

class ResponseTest: XCTestCase {
  let ok = TwoHundred.Ok

  func testItCanCompleteAStatusCode() {
    let headers = ["Content-Type": "ABCD"]
    let body = Array("BODY".utf8)

    let response = Response(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.statusCode, "200 OK")
  }

  func testItCanCompleteOtherStatusCodes() {
    let headers = ["Content-Type": "ABCD"]
    let body = Array("BODY".utf8)

    let response = Response(status: FourHundred.Teapot, headers: headers, body: body)

    XCTAssertEqual(response.statusCode, "418 I'm a teapot")
  }

  func testItCanFormatItsBody() {
    let headers = ["Content-Type": "ABCD"]
    let body = Array("BODY".utf8)

    let response = Response(status: ok, headers: headers, body: body)
    let expected: [UInt8] = Array("\n\n".utf8) + body

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanFormatItsHeaders() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let body = Array("BODY".utf8)

    let response = Response(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.headers, headers)
  }

  func testItCanFormatItself() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let rawHeaders = "Content-Type:text/html\r\nWWW-Authenticate:Basic realm=\"simple\""
    let body = Array("BODY".utf8)
    let formattedStatus: [UInt8] = Array("HTTP/1.1 200 OK\r\n".utf8)
    let formattedHeaders: [UInt8] = Array(rawHeaders.utf8)
    let formattedBody: [UInt8] = Array("\n\n".utf8) + body
    let formattedResponse = formattedStatus + formattedHeaders + formattedBody

    let response = Response(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.formatted, formattedResponse)
  }
}
