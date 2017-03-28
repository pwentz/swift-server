import XCTest
@testable import Requests
@testable import Controllers

class ResourcesControllerTest: XCTestCase {
  func testItCanProcessARequestWithTextFiles() {
    let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["file1": Array("this is a text file.".utf8),
                    "file2": Array("this is another text file.".utf8)]

    let expected = Array("\n\nthis is a text file.".utf8)
    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanProcessAnImageRequest() {
    let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let encodedImage = Array("someEncodedStuff".utf8)

    let contents = ["image.jpeg": encodedImage,
                    "file2": Array("this is another text file.".utf8)]

    let expected = Array("\n\n".utf8) + encodedImage

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.body!, expected)
  }

  func testItReturns404IfNoFileIsFound() {
    let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["file2": Array("this is another text file.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "404 Not Found")
  }

  func testItReturnsA405IfVerbIsAPutRequest() {
    let rawRequest = "PUT /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["file1": Array("this is a text file.".utf8),
                    "file2": Array("this is another text file.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "405 Method Not Allowed")
  }

  func testItReturnsA405IfVerbIsAPostRequest() {
    let rawRequest = "POST /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["file1": Array("this is a text file.".utf8),
                    "file2": Array("this is another text file.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "405 Method Not Allowed")
  }

  func testItCanFitContentTypeForJPEG() {
    let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let encodedImage = Array("someEncodedStuff".utf8)

    let contents = ["image.jpeg": encodedImage,
                    "file2": Array("this is another text file.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/jpeg")
  }

  func testItCanFitContentTypeForPNG() {
    let rawRequest = "GET /image.png HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let encodedImage = Array("someEncodedStuff".utf8)

    let contents = ["image.png": encodedImage,
                    "file2": Array("this is another text file.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/png")
  }

  func testItCanFitContentTypeForGIF() {
    let rawRequest = "GET /image.gif HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)
    let encodedImage = Array("someEncodedStuff".utf8)

    let contents = ["image.gif": encodedImage,
                    "file2": Array("this is another text file.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/gif")
  }

  func testItCanFitContentTypeForTextWhenTXTExtensionIsPresent() {
    let rawRequest = "GET /stuff.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["stuff.txt": Array("this is a text file.".utf8),
                    "file2": Array("this is another text file.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/plain")
  }

  func testItFitsDefaultContentTypeWhenNoExtensionPresent() {
    let rawRequest = "GET /file2 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["stuff.txt": Array("this is a text file.".utf8),
                    "file2": Array("this is another text file.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/html")
  }

  func testItCanRespondWithA206WithPartialContent() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange:bytes=4-"
    let request = Request(for: rawRequest)

    let contents = ["partial_content.txt": Array("This is a file that contains text to read part of in order to fulfill a 206.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "206 Partial Content")
  }

  func testItCanRespondWithPartialContentsGivenRangeStart() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=4-\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["partial_content.txt": Array("This is a file that contains text to read part of in order to fulfill a 206.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    let expected = Array("\n\n is a file that contains text to read part of in order to fulfill a 206.".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanRespondWithPartialContentsGivenRangeEnd() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=-6\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["partial_content.txt": Array("This is a file that contains text to read part of in order to fulfill a 206.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    let expected = Array("\n\na 206.".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanRespondWithPartialContentsGivenRangeStartAndEnd() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\nRange:bytes=0-4\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents = ["partial_content.txt": Array("This is a file that contains text to read part of in order to fulfill a 206.".utf8)]

    let response = ResourcesController(contents: contents).process(request)

    let expected = Array("\n\nThis ".utf8)

    XCTAssertEqual(response.body!, expected)
  }
}