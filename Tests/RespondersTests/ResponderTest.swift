import XCTest
@testable import Responders
import Requests
import Routes

class ResponderTest: XCTestCase {
  func testItReturnsA401ResponseIfAuthDoesntMatch() {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic someencodedstuff==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let route = Route(auth: "XYZ")

    let routes = ["/logs": route]

    let responder = Responder(routes: routes)

    let response = responder.respond(to: request)

    XCTAssertEqual(response.statusCode, "401 Unauthorized")
  }

  func testItReturnsA200ResponseIfAuthMatches() {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic XYZ\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let route = Route(auth: "XYZ")

    let routes = ["/logs": route]

    let responder = Responder(routes: routes)

    let response = responder.respond(to: request)

    XCTAssertEqual(response.statusCode, "200 OK")
  }

  func testItReturnsA401ResponseIfAuthDoesntExist() {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let route = Route(auth: "XYZ")

    let routes = ["/logs": route]

    let responder = Responder(routes: routes)

    let response = responder.respond(to: request)

    XCTAssertEqual(response.statusCode, "401 Unauthorized")
  }

  func testItReturnsA200IfAuthIsNil() {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let route = Route(auth: nil)

    let routes = ["/logs": route]

    let responder = Responder(routes: routes)

    let response = responder.respond(to: request)

    XCTAssertEqual(response.statusCode, "200 OK")
  }
}
