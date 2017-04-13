import XCTest
@testable import Responders
import Util
import Requests
import Routes

class ResponderTest: XCTestCase {
  // Authentication
    func testItReturnsA401ResponseIfAuthDoesntMatch() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic someencodedstuff==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: "XYZ", setCookie: false, includeLogs: false, allowedMethods: [.Get])

      let routes = ["/logs": route]

      let responder = Responder(routes: routes, data: contents)

      let response = responder.respond(to: request)

      XCTAssertEqual(response.statusCode, "401 Unauthorized")
    }

    func testItReturnsA200ResponseIfAuthMatches() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic XYZ\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: "XYZ", setCookie: false, includeLogs: false, allowedMethods: [.Get])

      let routes = ["/logs": route]

      let responder = Responder(routes: routes, data: contents)

      let response = responder.respond(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

    func testItReturnsA401ResponseIfAuthDoesntExist() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: "XYZ", setCookie: false, includeLogs: false, allowedMethods: [.Get])

      let routes = ["/logs": route]

      let responder = Responder(routes: routes, data: contents)

      let response = responder.respond(to: request)

      XCTAssertEqual(response.statusCode, "401 Unauthorized")
    }

    func testItReturnsA200IfAuthIsNil() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get])

      let routes = ["/logs": route]

      let responder = Responder(routes: routes, data: contents)

      let response = responder.respond(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

  // Set Cookie
    func testItReturnsResponseWithCorrectBody() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let data = ControllerData([:])

      let route = Route(auth: nil, setCookie: true, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/cookie": route]

      let newResponse = Responder(routes: routes, data: data).respond(to: request)

      let expected = Array("\n\nEat".utf8)

      XCTAssertEqual(newResponse.body!, expected)
    }

    func testItReturnsAResponseWithSetCookieHeadersWhenSetCookieFlagIsTrue() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let data = ControllerData([:])

      let route = Route(auth: nil, setCookie: true, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/cookie": route]

      let newResponse = Responder(routes: routes, data: data).respond(to: request)

      XCTAssertEqual(newResponse.headers["Set-Cookie"]!, "type=chocolate")
    }

  // Cookie Header
    func testItCanRespondWithCorrectBodyGivenCookieHeader() {
      let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/eat_cookie": route]

      let responder = Responder(routes: routes, data: contents)

      let response = responder.respond(to: request)
      let result = Array("\n\nmmmm chocolate".utf8)

      XCTAssertEqual(response.body!, result)
    }

  // Set Cookie AND Auth
    func testItCanHandleCookieAndAuthInvalidAuth() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nAuthorization: Basic ABC\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: "XYZ", setCookie: true, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/cookie": route]

      let res = Responder(routes: routes, data: contents).respond(to: request)

      XCTAssertEqual(res.statusCode, "401 Unauthorized")
    }

  // Include Logs
    func testItCanIncludeLogsInResponseBody() {
      let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: nil, setCookie: false, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/someRoute": route]

      let res = Responder(routes: routes, data: contents).respond(to: request)
      let expected = Array("\n\nGET /someRoute HTTP/1.1".utf8)

      XCTAssertEqual(res.body!, expected)
    }

    func testItCanKeepTrackOfLogs() {
      let _ = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: nil, setCookie: false, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/someRoute": route]
      let responder = Responder(routes: routes, data: contents)

      let _ = responder.respond(to: request)
      let response = responder.respond(to: request)
      let expected = Array("\n\nGET /someRoute HTTP/1.1\nGET /someRoute HTTP/1.1".utf8)

      XCTAssertEqual(response.body!, expected)
    }

  // Include logs AND cookie
    func testItCanSetCookieAndIncludeLogs() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: nil, setCookie: true, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/cookie": route]

      let res = Responder(routes: routes, data: contents).respond(to: request)
      let expected = Array("\n\nEat\n\nGET /cookie HTTP/1.1".utf8)

      XCTAssertEqual(res.body!, expected)
    }

    func testItCanGetCookieAndIncludeLogs() {
      let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: nil, setCookie: false, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/eat_cookie": route]

      let res = Responder(routes: routes, data: contents).respond(to: request)
      let expected = Array("\n\nmmmm chocolate\n\nGET /eat_cookie HTTP/1.1".utf8)

      XCTAssertEqual(res.body!, expected)
    }

    func testItCanGetCookieAndIncludeLogsWithAuth() {
      let rawRequest = "GET /eat_cookie HTTP/1.1\r\nAuthorization: Basic ABC\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: "ABC", setCookie: false, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/eat_cookie": route]

      let res = Responder(routes: routes, data: contents).respond(to: request)
      let expected = Array("\n\nmmmm chocolate\n\nGET /eat_cookie HTTP/1.1".utf8)

      XCTAssertEqual(res.body!, expected)
    }

  // Allowed Methods
    func testItFixesAllowHeaderOnOptionRequest() {
      let rawRequest = "OPTIONS /method_options HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get, .Post, .Options])
      let routes = ["/method_options": route]

      let res = Responder(routes: routes, data: contents).respond(to: request)

      XCTAssertEqual(res.headers["Allow"]!, "GET,POST,OPTIONS")
    }

    func testItDoesNotAllowMethodsThatAreNotDefinedByRoute() {
      let rawRequest = "DELETE /someResource HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)
      let contents = ControllerData([:])

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get, .Post])
      let routes = ["/someResource": route]

      let res = Responder(routes: routes, data: contents).respond(to: request)

      XCTAssertEqual(res.statusCode, "405 Method Not Allowed")
    }

  // FIle Data
    func testItCanReturnCorrectFileContentForFileData() {
      let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let contents = ControllerData(
        ["file1": Data(value: "this is a text file."),
         "file2": Data(value: "this is another text file.")]
      )

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get, .Put, .Patch])
      let routes = ["/file1": route]

      let expected = Array("\n\nthis is a text file.".utf8)
      let response = Responder(routes: routes, data: contents).respond(to: request)

      XCTAssertEqual(response.body!, expected)
    }

    func testItCanReturnCorrectContentTypeForFile() {
      let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let contents = ControllerData(
        ["image.jpeg": Data(value: "some stuff")]
      )

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/image.jpeg": route]

      let response = Responder(routes: routes, data: contents).respond(to: request)

      XCTAssertEqual(response.headers["Content-Type"]!, "image/jpeg")
    }

  // File Data with Logs?

    func testItDeniesAdditionalBodyWhenContentTypeDoesNotAllowIt() {
      let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let contents = ControllerData(
        ["image.jpeg": Data(value: "some stuff")]
      )

      let route = Route(auth: nil, setCookie: false, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/image.jpeg": route]

      let response = Responder(routes: routes, data: contents).respond(to: request)
      let expected = "\n\nsome stuff".toBytes

      XCTAssertEqual(response.body!, expected)
    }

    func testItAllowsAdditionalBodyWhenContentTypeAllowsIt() {
      let rawRequest = "GET /file1.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let contents = ControllerData(
        ["file1.txt": Data(value: "some stuff")]
      )

      let route = Route(auth: nil, setCookie: false, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/file1.txt": route]

      let response = Responder(routes: routes, data: contents).respond(to: request)
      let expected = "\n\nsome stuff\n\nGET /file1.txt HTTP/1.1".toBytes

      XCTAssertEqual(response.body!, expected)
    }

  // Partial Contents
    func testItCanRespondWithA206WithPartialContent() {
      let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange:bytes=4-"
      let request = HTTPRequest(for: rawRequest)

      let content = "This is a file that contains text to read part of in order to fulfill a 206."

      let contents = ControllerData(
        ["partial_content.txt": Data(value: content)]
      )

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/partial_content.txt": route]
      let response = Responder(routes: routes, data: contents).respond(to: request)

      XCTAssertEqual(response.statusCode, "206 Partial Content")
    }

    func testItCanRespondWithPartialContentsGivenRangeStart() {
      let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange:bytes=4-"
      let request = HTTPRequest(for: rawRequest)

      let content = "This is a file that contains text to read part of in order to fulfill a 206."

      let contents = ControllerData(
        ["partial_content.txt": Data(value: content)]
      )

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/partial_content.txt": route]
      let response = Responder(routes: routes, data: contents).respond(to: request)
      let expected = "\n\n is a file that contains text to read part of in order to fulfill a 206.".toBytes

      XCTAssertEqual(response.body!, expected)
    }

  // File Links
    func testItCanRespondWhenRouteIncludesLinks() {
      let rawRequest = "GET / HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)

      let contents = ControllerData(
        ["file1": Data(value: "I'm a text file"),
         "file2": Data(value: "I'm a different text file")]
      )

      let route = Route(auth: nil, setCookie: false, includeLogs: false, allowedMethods: [.Get], includeDirectoryLinks: true)

      let routes = ["/": route]
      let response = Responder(routes: routes, data: contents).respond(to: request)

      let expected = "\n\n<a href=\"/file2\">file2</a><br><a href=\"/file1\">file1</a>".toBytes

      XCTAssertEqual(response.body!, expected)
    }
}
