import XCTest
import Util
@testable import Responses

class ResponseTest: XCTestCase {
  let ok = TwoHundred.Ok

  func testItCanCompleteAStatusCode() {
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = HTTPResponse(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.status.description, "200 OK")
  }

  func testItCanCompleteOtherStatusCodes() {
    let headers = ["Content-Type": "ABCD"]
    let body = "BODY"

    let response = HTTPResponse(status: FourHundred.Teapot, headers: headers, body: body)

    XCTAssertEqual(response.status.description, "418 I'm a teapot")
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

  func testItCanFormatItselfWithCurrentDataInHeaders() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let rawHeaders = "Content-Type:text/html\r\nWWW-Authenticate:Basic realm=\"simple\""

    let mockCalendar = MockCalendar(hour: 6, minute: 25, second: 10)
    let mockFormatter = MockFormatter(month: "04", day: "21", year: "2017")

    let dateHelper = DateHelper(today: Date(), calendar: mockCalendar, formatter: mockFormatter)

    let rfcDateHeader = "\r\nDate: Fri, 21 Apr 2017\r\n\r\n"
    let body = "BODY"
    let formattedStatus = "HTTP/1.1 200 OK\r\n"
    let formattedResponse = formattedStatus + rawHeaders + rfcDateHeader + body

    let response = HTTPResponse(status: ok, headers: headers, body: body)

    XCTAssertEqual(response.format(dateHelper: dateHelper), formattedResponse.toBytes)
  }

  func testItCanFormatItselfWithNoBody() {
    let headers = ["Content-Type": "text/html",
                   "WWW-Authenticate" : "Basic realm=\"simple\""]

    let rawHeaders = "Content-Type:text/html\r\nWWW-Authenticate:Basic realm=\"simple\""

    let mockCalendar = MockCalendar(hour: 6, minute: 25, second: 10)
    let mockFormatter = MockFormatter(month: "04", day: "21", year: "2017")

    let dateHelper = DateHelper(today: Date(), calendar: mockCalendar, formatter: mockFormatter)

    let rfcDateHeader = "\r\nDate: Fri, 21 Apr 2017\r\n\r\n"

    let formattedResponse = "HTTP/1.1 200 OK\r\n" + rawHeaders + rfcDateHeader

    let response = HTTPResponse(status: ok, headers: headers)

    XCTAssertEqual(response.format(dateHelper: dateHelper), formattedResponse.toBytes)
  }

  func testItsStatusAndHeadersCanBeRepresentedByAString() {
    let headers = ["Content-Type": "ABCD"]

    let response = HTTPResponse(status: ok, headers: headers)
    let expected = "HTTP/1.1 200 OK\r\nContent-Type:ABCD\r\n\r\n"

    XCTAssertEqual(String(response: response), expected)
  }
}
