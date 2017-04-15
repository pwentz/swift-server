import XCTest
@testable import ResponseFormatters
import Util
import Requests
import Responses

class ContentFormatterTest: XCTestCase {
  func testItCanUpdateBodyWithFileContents() {
    let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ControllerData(
      ["file1": Data(value: "this is a text file."),
       "file2": Data(value: "this is another text file.")]
    )

    let contentFormatter = ContentFormatter(for: request, data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.body!, "\n\nthis is a text file.".toBytes)
  }

  func testItCanUpdateContentTypeHeaderWhenExtensionIsMissing() {
    let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ControllerData(
      ["file1": Data(value: "this is a text file.")]
    )

    let contentFormatter = ContentFormatter(for: request, data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/html")
  }

  func testItCanUpdateBodyWithImageContents() {
    let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ControllerData(
      ["image.jpeg": Data(value: "some encoded stuff")]
    )

    let contentFormatter = ContentFormatter(for: request, data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.body!, "\n\nsome encoded stuff".toBytes)
  }

  func testItCanUpdateContentTypeHeaderWithJPEG() {
    let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ControllerData(
      ["image.jpeg": Data(value: "some encoded stuff")]
    )

    let contentFormatter = ContentFormatter(for: request, data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/jpeg")
  }

  func testItCanUpdateContentTypeHeaderWithPNG() {
    let rawRequest = "GET /image.png HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ControllerData(
      ["image.png": Data(value: "some encoded stuff")]
    )

    let contentFormatter = ContentFormatter(for: request, data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/png")
  }

  func testItCanUpdateContentTypeHeaderWithGIF() {
    let rawRequest = "GET /image.gif HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ControllerData(
      ["image.gif": Data(value: "some encoded stuff")]
    )

    let contentFormatter = ContentFormatter(for: request, data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/gif")
  }

  func testItCanUpdateContentTypeHeaderWithTXT() {
    let rawRequest = "GET /file1.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ControllerData(
      ["file1.txt": Data(value: "this is a text file.")]
    )

    let contentFormatter = ContentFormatter(for: request, data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/plain")
  }
}
