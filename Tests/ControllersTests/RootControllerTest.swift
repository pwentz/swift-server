import XCTest
@testable import Controllers
import Requests
import Util

class RootControllerTest: XCTestCase {
  func testItReturnsResponseWithAStatus200() {
    let rawRequest = "GET / HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let fileContents = ["file1": Data(value: "I'm a text file"),
                        "file2": Data(value: "I'm a different text file")]

    let data = ControllerData(fileContents)

    let response = RootController(contents: data).process(request)

    XCTAssertEqual(response.statusCode, "200 OK")
  }

  func testItReturnsResponseWithAContentTypeHeader() {
    let rawRequest = "GET / HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let fileContents = ["file1": Data(value: "I'm a text file"),
                        "file2": Data(value: "I'm a different text file")]

    let data = ControllerData(fileContents)

    let response = RootController(contents: data).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/html")
  }

  func testItReturnsResponseWithGivenFiles() {
    let rawRequest = "GET / HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let fileContents = ["file1": Data(value: "I'm a text file"),
                        "file2": Data(value: "I'm a different text file")]

    let data = ControllerData(fileContents)

    let response = RootController(contents: data).process(request)

    let expected = "\n\n<a href=\"/file2\">file2</a><br><a href=\"/file1\">file1</a>".toBytes

    XCTAssertEqual(response.body!, expected)
  }
}
