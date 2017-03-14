import XCTest
@testable import Requests

class RequestTest: XCTestCase {
    func testItTakesRawRequestAndExtractsVerbGET() {
        let rawRequest = "GET /log HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
        let request = Request(for: rawRequest)

        XCTAssertEqual(request.verb, "GET")
    }

    func testItTakesRawRequestAndExtractsVerbPOST() {
        let rawRequest = "POST /log HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
        let request = Request(for: rawRequest)

        XCTAssertEqual(request.verb, "POST")
    }

    func testItTakesRawRequestAndExtractsPathLog() {
        let rawRequest = "GET /log HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
        let request = Request(for: rawRequest)

        XCTAssertEqual(request.path, "/log")
    }

    func testItTakesRawRequestAndExtractsPathLogs() {
        let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
        let request = Request(for: rawRequest)

        XCTAssertEqual(request.path, "/logs")
    }

    func testItTakesRawRequestAndExtractsAllValidHeaders() {
        let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\nAuthorization: Basic YWRtaW46aHVudGVyMg==\r\n Connection: Keep-Alive\r\n User-Agent:Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding:gzip,deflate\r\nAccept-Charset: utf-8"
        let request = Request(for: rawRequest)
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
        let rawRequest = "POST /form HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)
        let expectedResult = [
          "host": "yahoo.com",
          "connection": "Keep-Alive",
          "user-agent": "chrome",
          "accept-encoding": "gzip,deflate"
        ]

        XCTAssertEqual(request.headers, expectedResult)
    }

    func testItCanTranslateEmptyHeaderValues() {
        let rawRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)
        let expectedResult = [
          "host": "",
          "connection": "Keep-Alive",
          "user-agent": "chrome",
          "accept-encoding": "gzip,deflate"
        ]

        XCTAssertEqual(request.headers, expectedResult)
    }

    func testItHasNoParams() {
        let rawRequest = "GET /cookie HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)

        XCTAssertNil(request.params)
    }

    func testItHasInvalidParams() {
        let rawRequest = "GET /cookie?sometihgnaksjnd HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)

        XCTAssertNil(request.params)
    }

    func testItCanRecognizeBlankParamVals() {
        let rawRequest = "GET /cookie?sometihgnaksjnd= HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)

        XCTAssertEqual(request.params!.zip(), ["sometihgnaksjnd": ""])
    }

    func testItCanRecognizeBlankParamKey() {
        let rawRequest = "GET /cookie?=sometihgnaksjnd HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)

        XCTAssertEqual(request.params!.zip(), ["": "sometihgnaksjnd"])
    }

    func testItHasParams() {
        let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)


        XCTAssertEqual(request.params!.zip(), ["type": "chocolate"])
    }

    func testItCanHandleDifferentParams() {
        let rawRequest = "GET /cookie?roast=beef HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)


        XCTAssertEqual(request.params!.zip(), ["roast": "beef"])
    }

    func testHavingParamsDoesntChangePath() {
        let rawRequest = "GET /cookie?roast=beef HTTP/1.1\r\nHost:yahoo.com\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
        let request = Request(for: rawRequest)


        XCTAssertEqual(request.path, "/cookie")
    }
}
