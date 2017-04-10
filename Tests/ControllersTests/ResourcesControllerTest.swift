import XCTest
import Util
@testable import Requests
@testable import Controllers

class ResourcesControllerTest: XCTestCase {
  func testItCanProcessARequestWithTextFiles() {
    let rawRequest = "GET /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let contents = ControllerData(
      ["file1": Data(value: "this is a text file."),
       "file2": Data(value: "this is another text file.")]
    )

    let expected = Array("\n\nthis is a text file.".utf8)
    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanProcessAnImageRequest() {
    let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let encodedImage = Data(value: "someEncodedStuff")

    let contents = ControllerData(
      ["image.jpeg": encodedImage,
       "file2": Data(value: "this is another text file.")]
    )

    let expected = Array("\n\n".utf8) + encodedImage

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.body!, expected)
  }

  func testItReturnsA405IfVerbIsAPutRequest() {
    let rawRequest = "PUT /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let contents = ControllerData(
      ["file1": Data(value: "this is a text file."),
       "file2": Data(value: "this is another text file.")]
    )

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "405 Method Not Allowed")
  }

  func testItReturnsA405IfVerbIsAPostRequest() {
    let rawRequest = "POST /file1 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let contents = ControllerData(
      ["file1": Data(value: "this is a text file."),
       "file2": Data(value: "this is another text file.")]
    )

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "405 Method Not Allowed")
  }

  func testItCanFitContentTypeForJPEG() {
    let rawRequest = "GET /image.jpeg HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let encodedImage = Data(value: "someEncodedStuff")

    let contents = ControllerData(
      ["image.jpeg": encodedImage,
       "file2": Data(value: "this is another text file.")]
    )

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/jpeg")
  }

  func testItCanFitContentTypeForPNG() {
    let rawRequest = "GET /image.png HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let encodedImage = Data(value: "someEncodedStuff")

    let contents = ControllerData(
      ["image.png": encodedImage,
       "file2": Data(value: "this is another text file.")]
    )

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/png")
  }

  func testItCanFitContentTypeForGIF() {
    let rawRequest = "GET /image.gif HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)
    let encodedImage = Data(value: "someEncodedStuff")

    let contents = ControllerData(
      ["image.gif": encodedImage,
       "file2": Data(value: "this is another text file.")]
    )

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/gif")
  }

  func testItCanFitContentTypeForTextWhenTXTExtensionIsPresent() {
    let rawRequest = "GET /stuff.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let contents = ControllerData(
      ["stuff.txt": Data(value: "this is a text file."),
       "file2": Data(value: "this is another text file.")]
    )

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/plain")
  }

  func testItFitsDefaultContentTypeWhenNoExtensionPresent() {
    let rawRequest = "GET /file2 HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let contents = ControllerData(
      ["stuff.txt": Data(value: "this is a text file."),
       "file2": Data(value: "this is another text file.")]
    )

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/html")
  }

  func testItCanReturnDefaultStatusOnGet() {
    let rawRequest = "GET /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let contents = ControllerData(["patch-content.txt": Data(value: "default content")])

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "200 OK")
  }

  func testItCanReturnDefaultContentOnGet() {
    let rawRequest = "GET /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let contents = ControllerData(["patch-content.txt": Data(value: "default content")])

    let response = ResourcesController(contents: contents).process(request)

    let expected = Array("\n\ndefault content".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanReturn204WhenSentPatch() {
    let rawRequest = "PATCH /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nIf-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\nContent-Length: 15\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate\r\npatched content"
    let request = HTTPRequest(for: rawRequest)

    let contents = ControllerData(["patch-content.txt": Data(value: "default content")])

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "204 No Content")
  }

  func testItCanModifyDefaultContent() {
    let rawPatchRequest = "PATCH /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nIf-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\nContent-Length: 15\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate\r\npatched content"
    let rawGetRequest = "GET /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let patchRequest = HTTPRequest(for: rawPatchRequest)
    let getRequest = HTTPRequest(for: rawGetRequest)

    let contents = ControllerData(["patch-content.txt": Data(value: "default content")])

    let _ = ResourcesController(contents: contents).process(patchRequest)

    let response = ResourcesController(contents: contents).process(getRequest)

    let expected = Array("\n\npatched content".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItCanHandlePartialContentRequests() {
    let rawRequest = "GET /partial_content.txt HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate\r\nRange:bytes=4-"
    let request = HTTPRequest(for: rawRequest)

    let partialContent = "This is a file that contains text to read part of in order to fulfill a 206."
    let contents = ControllerData(["partial_content.txt": Data(value: partialContent)])

    let response = ResourcesController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "206 Partial Content")
  }
}
