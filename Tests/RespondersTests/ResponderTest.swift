import XCTest
@testable import Responders
import Requests
import Routes

class ResponderTest: XCTestCase {
  // Authentication
    func testItReturnsA401ResponseIfAuthDoesntMatch() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic someencodedstuff==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: "XYZ", setCookie: false, includeLogs: false)

      let routes = ["/logs": route]

      let responder = Responder(routes: routes)

      let response = responder.respond(to: request)

      XCTAssertEqual(response.statusCode, "401 Unauthorized")
    }

    func testItReturnsA200ResponseIfAuthMatches() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic XYZ\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: "XYZ", setCookie: false, includeLogs: false)

      let routes = ["/logs": route]

      let responder = Responder(routes: routes)

      let response = responder.respond(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

    func testItReturnsA401ResponseIfAuthDoesntExist() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: "XYZ", setCookie: false, includeLogs: false)

      let routes = ["/logs": route]

      let responder = Responder(routes: routes)

      let response = responder.respond(to: request)

      XCTAssertEqual(response.statusCode, "401 Unauthorized")
    }

    func testItReturnsA200IfAuthIsNil() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: nil, setCookie: false, includeLogs: false)

      let routes = ["/logs": route]

      let responder = Responder(routes: routes)

      let response = responder.respond(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

  // Set Cookie
    func testItReturnsA200ResponseWhenPassedCookie() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: nil, setCookie: true, includeLogs: false)
      let routes = ["/cookie": route]

      let res = Responder(routes: routes).respond(to: request)

      XCTAssertEqual(res.statusCode, "200 OK")
    }

    func testItReturnsAResponseWithEatWhenSetCookieFlagIsTrue() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: nil, setCookie: true, includeLogs: false)
      let routes = ["/cookie": route]

      let res = Responder(routes: routes).respond(to: request)

      let result = Array("\n\nEat".utf8)

      XCTAssertEqual(res.body!, result)
    }

    func testItReturnsAResponseWithSetCookieHeadersWhenSetCookieFlagIsTrue() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: nil, setCookie: true, includeLogs: false)
      let routes = ["/cookie": route]

      let res = Responder(routes: routes).respond(to: request)

      let result = Array("\n\nEat".utf8)

      XCTAssertEqual(res.headers["Set-Cookie"]!, "type=chocolate")
    }

    func testItReturnsABadRequestResponseIfSetCookieIsTrueButNoCookieProvided() {
      let rawRequest = "GET /cookie HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: nil, setCookie: true, includeLogs: false)
      let routes = ["/cookie": route]

      let res = Responder(routes: routes).respond(to: request)

      XCTAssertEqual(res.statusCode, "400 Bad Request")
    }

  // Set Cookie AND Auth
    func testItCanHandleCookieAndAuthInvalidAuth() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nAuthorization: Basic ABC\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: "XYZ", setCookie: true, includeLogs: false)
      let routes = ["/cookie": route]

      let res = Responder(routes: routes).respond(to: request)

      XCTAssertEqual(res.statusCode, "401 Unauthorized")
    }

  // Include Logs
    func testItCanIncludeLogsInResponseBody() {
      let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: nil, setCookie: false, includeLogs: true)
      let routes = ["/someRoute": route]

      let res = Responder(routes: routes).respond(to: request)
      let expected = Array("\n\nGET /someRoute HTTP/1.1".utf8)

      XCTAssertEqual(res.body!, expected)
    }

    func testItCanKeepTrackOfLogs() {
      let _ = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let route = Route(auth: nil, setCookie: false, includeLogs: true)
      let routes = ["/someRoute": route]
      let responder = Responder(routes: routes)

      let _ = responder.respond(to: request)
      let response = responder.respond(to: request)
      let expected = Array("\n\nGET /someRoute HTTP/1.1\nGET /someRoute HTTP/1.1".utf8)

      XCTAssertEqual(response.body!, expected)
    }
}
