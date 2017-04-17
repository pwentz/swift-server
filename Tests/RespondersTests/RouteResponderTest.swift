import XCTest
@testable import Responders
import Util
import Requests
import Responses
import Routes

class RouteResponderTest: XCTestCase {
  // Authentication
    func testItReturnsA401ResponseIfAuthDoesntMatch() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic someencodedstuff==\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: "XYZ", includeLogs: false, allowedMethods: [.Get])

      let routes = ["/logs": route]

      let responder = RouteResponder(routes: routes)

      let response = responder.getResponse(to: request)

      XCTAssertEqual(response.statusCode, "401 Unauthorized")
      XCTAssertEqual(response.headers["WWW-Authenticate"]!, "Basic realm=\"simple\"")
    }

    func testItReturnsA200ResponseIfAuthMatches() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic XYZ\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: "XYZ", includeLogs: false, allowedMethods: [.Get])

      let routes = ["/logs": route]

      let responder = RouteResponder(routes: routes)

      let response = responder.getResponse(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

    func testItReturnsA401ResponseIfAuthDoesntExist() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: "XYZ", includeLogs: false, allowedMethods: [.Get])

      let routes = ["/logs": route]

      let responder = RouteResponder(routes: routes)

      let response = responder.getResponse(to: request)

      XCTAssertEqual(response.statusCode, "401 Unauthorized")
    }

    func testItReturnsA200IfAuthIsNil() {
      let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, includeLogs: false, allowedMethods: [.Get])

      let routes = ["/logs": route]

      let responder = RouteResponder(routes: routes)

      let response = responder.getResponse(to: request)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

  // Set Cookie
    func testItReturnsResponseWithCorrectBody() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, cookiePrefix: "Eat", includeLogs: false, allowedMethods: [.Get])
      let routes = ["/cookie": route]

      let newResponse = RouteResponder(routes: routes).getResponse(to: request)

      let expected = "Eat".toBytes

      XCTAssertEqual(newResponse.body!, expected)
    }

    func testItReturnsAResponseWithSetCookieHeadersWhenSetCookieFlagIsTrue() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, cookiePrefix: "Eat", includeLogs: false, allowedMethods: [.Get])
      let routes = ["/cookie": route]

      let newResponse = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(newResponse.headers["Set-Cookie"]!, "type=chocolate")
    }

  // Cookie Header
    func testItCanRespondWithCorrectBodyGivenCookieHeader() {
      let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, cookiePrefix: "mmmm", includeLogs: false, allowedMethods: [.Get])
      let routes = ["/eat_cookie": route]

      let responder = RouteResponder(routes: routes)

      let response = responder.getResponse(to: request)
      let result = "mmmm chocolate".toBytes

      XCTAssertEqual(response.body!, result)
    }

  // Set Cookie AND Auth
    func testItCanHandleCookieAndAuthInvalidAuth() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nAuthorization: Basic ABC\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: "XYZ", cookiePrefix: "Eat", includeLogs: false, allowedMethods: [.Get])
      let routes = ["/cookie": route]

      let res = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(res.statusCode, "401 Unauthorized")
    }

  // Include Logs
    func testItCanIncludeLogsInResponseBody() {
      let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/someRoute": route]

      let res = RouteResponder(routes: routes).getResponse(to: request)
      let expected = "GET /someRoute HTTP/1.1".toBytes

      XCTAssertEqual(res.body!, expected)
    }

    func testItCanKeepTrackOfLogs() {
      let _ = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let rawRequest = "GET /someRoute HTTP/1.1\r\n Host: localhost:5000\r\nConnection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/someRoute": route]
      let responder = RouteResponder(routes: routes)

      let _ = responder.getResponse(to: request)
      let response = responder.getResponse(to: request)
      let expected = "GET /someRoute HTTP/1.1\nGET /someRoute HTTP/1.1".toBytes

      XCTAssertEqual(response.body!, expected)
    }

  // Include logs AND cookie
    func testItCanSetCookieAndIncludeLogs() {
      let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, cookiePrefix: "Eat", includeLogs: true, allowedMethods: [.Get])
      let routes = ["/cookie": route]

      let res = RouteResponder(routes: routes).getResponse(to: request)
      let expected = "Eat\n\nGET /cookie HTTP/1.1".toBytes

      XCTAssertEqual(res.body!, expected)
    }

    func testItCanGetCookieAndIncludeLogs() {
      let rawRequest = "GET /eat_cookie HTTP/1.1\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, cookiePrefix: "mmmm", includeLogs: true, allowedMethods: [.Get])
      let routes = ["/eat_cookie": route]

      let res = RouteResponder(routes: routes).getResponse(to: request)
      let expected = "mmmm chocolate\n\nGET /eat_cookie HTTP/1.1".toBytes

      XCTAssertEqual(res.body!, expected)
    }

    func testItCanGetCookieAndIncludeLogsWithAuth() {
      let rawRequest = "GET /eat_cookie HTTP/1.1\r\nAuthorization: Basic ABC\r\nCookie: type=chocolate\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: "ABC", cookiePrefix: "mmmm", includeLogs: true, allowedMethods: [.Get])
      let routes = ["/eat_cookie": route]

      let res = RouteResponder(routes: routes).getResponse(to: request)
      let expected = "mmmm chocolate\n\nGET /eat_cookie HTTP/1.1".toBytes

      XCTAssertEqual(res.body!, expected)
    }

  // Allowed Methods
    func testItFixesAllowHeaderOnOptionRequest() {
      let rawRequest = "OPTIONS /method_options HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, includeLogs: false, allowedMethods: [.Get, .Post, .Options])
      let routes = ["/method_options": route]

      let res = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(res.headers["Allow"]!, "GET,POST,OPTIONS")
    }

    func testItDoesNotAllowMethodsThatAreNotDefinedByRoute() {
      let rawRequest = "DELETE /someResource HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(auth: nil, includeLogs: false, allowedMethods: [.Get, .Post])
      let routes = ["/someResource": route]

      let res = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(res.statusCode, "405 Method Not Allowed")
    }

  // FIle Data
    func testItCanReturnCorrectFileContentForFileData() {
      let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let contents = ResourceData(
        ["/file1": Data(bytes: "this is a text file.".toBytes),
         "/file2": Data(bytes: "this is another text file.".toBytes)]
      )

      let route = Route(auth: nil, includeLogs: false, allowedMethods: [.Get, .Put, .Patch])
      let routes = ["/file1": route]

      let expected = "this is a text file.".toBytes
      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)

      XCTAssertEqual(response.body!, expected)
    }

  // File Data with Logs?

    func testItDeniesAdditionalBodyWhenContentTypeDoesNotAllowIt() {
      let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let contents = ResourceData(
        ["/image.jpeg": Data(bytes: "some stuff".toBytes)]
      )

      let route = Route(auth: nil, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/image.jpeg": route]

      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)
      let expected = "some stuff".toBytes

      XCTAssertEqual(response.body!, expected)
    }

    func testItAllowsAdditionalBodyWhenContentTypeAllowsIt() {
      let rawRequest = "GET /file1.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let contents = ResourceData(
        ["/file1.txt": Data(bytes: "some stuff".toBytes)]
      )

      let route = Route(auth: nil, includeLogs: true, allowedMethods: [.Get])
      let routes = ["/file1.txt": route]

      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)
      let expected = "some stuff\n\nGET /file1.txt HTTP/1.1".toBytes

      XCTAssertEqual(response.body!, expected)
    }

  // Partial Contents
    func testItCanRespondWithA206WithPartialContent() {
      let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange:bytes=4-"
      let request = HTTPRequest(for: rawRequest)!

      let content = "This is a file that contains text to read part of in order to fulfill a 206."

      let contents = ResourceData(
        ["/partial_content.txt": Data(bytes: content.toBytes)]
      )

      let route = Route(auth: nil, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/partial_content.txt": route]
      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "206 Partial Content")
    }

    func testItCanRespondWithPartialContentsGivenRangeStart() {
      let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange:bytes=4-"
      let request = HTTPRequest(for: rawRequest)!

      let content = "This is a file that contains text to read part of in order to fulfill a 206."

      let contents = ResourceData(
        ["/partial_content.txt": Data(bytes: content.toBytes)]
      )

      let route = Route(auth: nil, includeLogs: false, allowedMethods: [.Get])
      let routes = ["/partial_content.txt": route]
      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)
      let expected = " is a file that contains text to read part of in order to fulfill a 206.\n".toBytes

      XCTAssertEqual(response.body!, expected)
    }

  // File Links
    func testItCanRespondWhenRouteIncludesLinks() {
      let rawRequest = "GET / HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let contents = ResourceData(
        ["/file1": Data(bytes: "I'm a text file".toBytes),
         "/file2": Data(bytes: "I'm a different text file".toBytes)]
      )

      let route = Route(allowedMethods: [.Get], includeDirectoryLinks: true)

      let routes = ["/": route]
      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)

      let expected = "<a href=\"/file1\">file1</a><br><a href=\"/file2\">file2</a>".toBytes

      XCTAssertEqual(response.body!, expected)
    }

  // Params (no Cookie)
    func testItCanRespondWithExpectedParams() {
      let rawRequest = "GET /parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(allowedMethods: [.Get])

      let routes = ["/parameters": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)
      let expected = "variable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?\nvariable_2 = stuff"

      XCTAssertEqual(response.body!, expected.toBytes)
    }

  // Patch file resources
    func testItCanReturnA204WhenSentAPatch() {
      let rawRequest = "PATCH /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nIf-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\nContent-Length: 15\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate\r\npatched content"
      let request = HTTPRequest(for: rawRequest)!
      let contents = ResourceData(["patch-content.txt": Data(bytes: "default content".toBytes)])

      let route = Route(allowedMethods: [.Patch])

      let routes = ["/patch-content.txt": route]

      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "204 No Content")
    }

    func testItCanModifyDefaultContent() {
      let rawPatchRequest = "PATCH /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nIf-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\nContent-Length: 15\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate\r\npatched content"
      let rawGetRequest = "GET /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
      let patchRequest = HTTPRequest(for: rawPatchRequest)!
      let getRequest = HTTPRequest(for: rawGetRequest)!

      let route = Route(allowedMethods: [.Patch, .Get])
      let routes = ["/patch-content.txt": route]

      let contents = ResourceData(["patch-content.txt": Data(bytes: "default content".toBytes)])

      let responder = RouteResponder(routes: routes, data: contents)

      let _ = responder.getResponse(to: patchRequest)

      let response = responder.getResponse(to: getRequest)

      let expected = "patched content"

      XCTAssertEqual(response.body!, expected.toBytes)
    }

  // Post/Put/Delete/Get non-file resources
    func testItReturnsEmptyOnInitialGet() {
      let rawRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(allowedMethods: [.Get])
      let routes = ["/form": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssert(response.body == nil)
    }

    func testItRespondsWith200StatusOnPost() {
      let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
      let postRequest = HTTPRequest(for: rawPostRequest)!
      let route = Route(allowedMethods: [.Post])

      let routes = ["/form": route]

      let response = RouteResponder(routes: routes).getResponse(to: postRequest)

      XCTAssertEqual(response.statusCode, "200 OK")
    }

    func testItCreatesDataOnPost() {
      let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
      let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
      let postRequest = HTTPRequest(for: rawPostRequest)!
      let getRequest = HTTPRequest(for: rawGetRequest)!

      let route = Route(allowedMethods: [.Post, .Get])

      let routes = ["/form": route]
      let responder = RouteResponder(routes: routes)

      let _ = responder.getResponse(to: postRequest)
      let response = responder.getResponse(to: getRequest)

      let expected = "data=fatcat"

      XCTAssertEqual(response.body!, expected.toBytes)
    }

    func testItUpdatesDataOnPut() {
      let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
      let rawPutRequest = "PUT /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=hamilton"
      let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
      let postRequest = HTTPRequest(for: rawPostRequest)!
      let putRequest = HTTPRequest(for: rawPutRequest)!
      let getRequest = HTTPRequest(for: rawGetRequest)!

      let route = Route(allowedMethods: [.Post, .Put, .Get])
      let routes = ["/form": route]

      let responder = RouteResponder(routes: routes)

      let _ = responder.getResponse(to: postRequest)
      let _ = responder.getResponse(to: putRequest)
      let response = responder.getResponse(to: getRequest)

      let expected = "data=hamilton"

      XCTAssertEqual(response.body!, expected.toBytes)
    }

    func testItRemovesDataOnDelete() {
      let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
      let rawDeleteRequest = "DELETE /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
      let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
      let postRequest = HTTPRequest(for: rawPostRequest)!
      let deleteRequest = HTTPRequest(for: rawDeleteRequest)!
      let getRequest = HTTPRequest(for: rawGetRequest)!

      let route = Route(allowedMethods: [.Post, .Delete, .Get])
      let routes = ["/form": route]

      let responder = RouteResponder(routes: routes)

      let _ = responder.getResponse(to: postRequest)
      let _ = responder.getResponse(to: deleteRequest)
      let response = responder.getResponse(to: getRequest)

      XCTAssert(response.body == nil)
    }

  // Custom HTTPResponse

    func testItReturnsCustomResponseWhenRouteHasCustomResponse() {
      let rawRequest = "GET /coffee HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!
      let customResponse = HTTPResponse(status: FourHundred.Teapot, body: "I'm a teapot")

      let route = Route(allowedMethods: [.Get], customResponse: customResponse)
      let routes = ["/coffee": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "418 I'm a teapot")
      XCTAssertEqual(response.body!, "I'm a teapot".toBytes)
    }

  // Appending body to response w/ image content
    func testItDoesNotIncludeDirectoryLinksWhenResponseIsAnImage() {
      let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let contents = ResourceData(
        ["/image.jpeg": Data(bytes: "some encoded stuff".toBytes)]
      )

      let route = Route(allowedMethods: [.Get], includeDirectoryLinks: true)
      let routes = ["/image.jpeg": route]

      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)

      XCTAssertEqual(response.body!, "some encoded stuff".toBytes)
    }

    func testItDoesNotIncludeLogsWhenResponseIsAnImage() {
      let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let contents = ResourceData(
        ["/image.jpeg": Data(bytes: "some encoded stuff".toBytes)]
      )

      let route = Route(includeLogs: true, allowedMethods: [.Get])
      let routes = ["/image.jpeg": route]

      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)

      XCTAssertEqual(response.body!, "some encoded stuff".toBytes)
    }

    func testItDoesNotIncludeCookiePrefixWhenResponseIsAnImage() {
      let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
      let request = HTTPRequest(for: rawRequest)!

      let contents = ResourceData(
        ["/image.jpeg": Data(bytes: "some encoded stuff".toBytes)]
      )

      let route = Route(cookiePrefix: "some stuff", allowedMethods: [.Get])
      let routes = ["/image.jpeg": route]

      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)

      XCTAssertEqual(response.body!, "some encoded stuff".toBytes)
    }

    func testItDoesNotIncludePartialResponseWhenResponseIsAnImage() {
      let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange: bytes=-4"
      let request = HTTPRequest(for: rawRequest)!

      let contents = ResourceData(
        ["/image.jpeg": Data(bytes: "some encoded stuff".toBytes)]
      )

      let route = Route(allowedMethods: [.Get])
      let routes = ["/image.jpeg": route]

      let response = RouteResponder(routes: routes, data: contents).getResponse(to: request)

      XCTAssertEqual(response.body!, "some encoded stuff".toBytes)
    }


  // Invalid verb
    func testItReturns405OnInvalidMethod() {
      let rawRequest = "HEY /someRoute HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange: bytes=-4"
      let request = HTTPRequest(for: rawRequest)!

      let route = Route(allowedMethods: [.Get])
      let routes = ["/someRoute": route]

      let response = RouteResponder(routes: routes).getResponse(to: request)

      XCTAssertEqual(response.statusCode, "405 Method Not Allowed")
    }
}
