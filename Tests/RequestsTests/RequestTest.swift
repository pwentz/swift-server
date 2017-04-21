import XCTest
@testable import Requests

class RequestTest: XCTestCase {
    func testItTakesRawRequestAndExtractsVerbGET() {
        let rawRequest = "GET /log HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!

        XCTAssertEqual(request.verb, .Get)
    }

    func testItTakesRawRequestAndExtractsVerbPOST() {
        let rawRequest = "POST /log HTTP/1.1\r\n\r\ndata=stuff"
        let request = HTTPRequest(for: rawRequest)!

        XCTAssertEqual(request.verb, .Post)
    }

    func testItTakesRawRequestAndExtractsPathLogs() {
        let rawRequest = "GET /logs HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!

        XCTAssertEqual(request.path, "/logs")
    }

    func testItTakesRawRequestAndExtractsAllValidHeaders() {
        let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic YWRtaW46aHVudGVyMg==\r\n Connection: Keep-Alive\r\n User-Agent:Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding:gzip,deflate\r\nAccept-Charset: utf-8\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!
        let expectedResult = [
          "host": "localhost:5000",
          "authorization": "Basic YWRtaW46aHVudGVyMg==",
          "connection": "Keep-Alive",
          "user-agent": "Apache-HttpClient/4.3.5 (java 1.5)",
          "accept-encoding": "gzip,deflate",
          "accept-charset": "utf-8"
        ]

        XCTAssertEqual(request.headers, expectedResult)
    }

    func testItTakesRawRequestAndExtractsOnlyValidHeadersNoWhiteSpacesInHeader() {
        let rawRequest = "GET /form HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!
        let expectedResult = [
          "host": "yahoo.com",
          "connection": "Keep-Alive",
          "user-agent": "chrome",
          "accept-encoding": "gzip,deflate"
        ]

        XCTAssertEqual(request.headers, expectedResult)
    }

    func testItIgnoresEmptyHeaders() {
        let rawRequest = "POST /form HTTP/1.1\r\nHost:\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!
        let expectedResult = [
          "user-agent": "chrome",
          "accept-encoding": "gzip,deflate"
        ]

        XCTAssertEqual(request.headers, expectedResult)
    }

    func testItHasNoParams() {
        let rawRequest = "GET /cookie HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!

        XCTAssertNil(request.params)
    }

    func testItHasInvalidParams() {
        let rawRequest = "GET /cookie?sometihgnaksjnd HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!

        XCTAssertNil(request.params)
    }

    func testItDoesntCreateParamsWithBlankValues() {
        let rawRequest = "GET /cookie?sometihgnaksjnd= HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!

        XCTAssertNil(request.params)
    }

    func testItCanRecognizeBlankParamKey() {
        let rawRequest = "GET /cookie?=sometihgnaksjnd HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!

        XCTAssertNil(request.params)
    }

    func testItHasParams() {
        let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!
        let result = [String: String](params: request.params!)

        XCTAssertEqual(result, ["type": "chocolate"])
    }

    func testItCanHandleDifferentParams() {
        let rawRequest = "GET /cookie?roast=beef HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!
        let result = [String: String](params: request.params!)

        XCTAssertEqual(result, ["roast": "beef"])
    }

    func testHavingParamsDoesntChangePath() {
        let rawRequest = "GET /cookie?roast=beef HTTP/1.1\r\n\r\n"
        let request = HTTPRequest(for: rawRequest)!


        XCTAssertEqual(request.path, "/cookie")
    }

    func testItHasABody() {
      let rawRequest = "POST /form HTTP/1.1\r\n\r\ndata=fatcat"
      let request = HTTPRequest(for: rawRequest)!

      XCTAssertEqual(request.body!, "data=fatcat")
    }

    func testItCanHandleInvalidRequests() {
      let rawRequest = "GET/tosomewhereHTTP/1.1"
      let request = HTTPRequest(for: rawRequest)

      XCTAssertNil(request)
    }

    func testItCanHandleRequestsWithHeadersAndMissingBody() {
      let rawRequest = "GET /cookie HTTP/1.1\r\nConnection: Keep-Alive\r\n\r\n"
      let request = HTTPRequest(for: rawRequest)!

      XCTAssertNil(request.body)
    }

    func testItCanHandleRequestsWithBodyAndMissingHeaders() {
      let rawRequest = "POST /cookie HTTP/1.1\r\n\r\ndata:fatcat"
      let request = HTTPRequest(for: rawRequest)!

      XCTAssertEqual(request.headers, [:])
      XCTAssertEqual(request.body!, "data:fatcat")
    }

    func testItCanSayWhetherItShouldHaveABody() {
      let postRequest = HTTPRequest(for: "POST /cookie HTTP/1.1\r\n\r\n")!
      let putRequest = HTTPRequest(for: "PUT /cookie HTTP/1.1\r\n\r\n")!
      let patchRequest = HTTPRequest(for: "PATCH /cookie HTTP/1.1\r\n\r\n")!

      XCTAssert(postRequest.shouldHaveBody)
      XCTAssert(putRequest.shouldHaveBody)
      XCTAssert(patchRequest.shouldHaveBody)
    }

    func testItWillFailIfPathHasNoLeadingSlash() {
      let request = HTTPRequest(for: "GET someRoute HTTP/1.1\r\n\r\n")

      XCTAssertNil(request)
    }

    func testItWillFormatPathWithMultipleSlashesOrTrailingSlash() {
      let request = HTTPRequest(for: "GET //someRoute//to///////somewhere/ HTTP/1.1\r\n\r\n")!

      XCTAssertEqual(request.path, "/someRoute/to/somewhere")
    }
}
