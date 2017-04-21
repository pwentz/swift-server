import XCTest
@testable import ResponseFormatters
import Util
import Requests
import Responses

class ContentFormatterTest: XCTestCase {
  let ok = TwoHundred.Ok

  func testItCanUpdateBodyWithFileContents() {
    let response = HTTPResponse(status: ok)

    let contents = ResourceData(
      ["/file1": "this is a text file."]
    )

    let contentFormatter = ContentFormatter(for: "/file1", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: ["Content-Type": "text/html"],
      body: "this is a text file."
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanAppendContentTypeHeaderToExistingHeaders() {
    let response = HTTPResponse(status: ok, headers: ["Date": "today"])

    let contents = ResourceData(
      ["/file1": "this is a text file."]
    )

    let contentFormatter = ContentFormatter(for: "/file1", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: [
        "Content-Type": "text/html",
        "Date": "today"
      ],
      body: "this is a text file."
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanUpdateBodyWithImageContents() {
    let response = HTTPResponse(status: ok)

    let contents = ResourceData(
      ["/image.jpeg": "some encoded stuff"]
    )

    let contentFormatter = ContentFormatter(for: "/image.jpeg", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: [
        "Content-Type": "image/jpeg"
      ],
      body: "some encoded stuff"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanUpdateContentTypeHeaderWithPNG() {
    let response = HTTPResponse(status: ok)

    let contents = ResourceData(
      ["/image.png": "some encoded stuff"]
    )

    let contentFormatter = ContentFormatter(for: "/image.png", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: [
        "Content-Type": "image/png"
      ],
      body: "some encoded stuff"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanUpdateContentTypeHeaderWithGIF() {
    let response = HTTPResponse(status: ok)

    let contents = ResourceData(
      ["/image.gif": "some encoded stuff"]
    )

    let contentFormatter = ContentFormatter(for: "/image.gif", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: [
        "Content-Type": "image/gif"
      ],
      body: "some encoded stuff"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanUpdateContentTypeHeaderWithTXT() {
    let response = HTTPResponse(status: ok)

    let contents = ResourceData(
      ["/file1.txt": "this is a text file."]
    )

    let contentFormatter = ContentFormatter(for: "/file1.txt", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: [
        "Content-Type": "text/plain"
      ],
      body: "this is a text file."
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }
}
