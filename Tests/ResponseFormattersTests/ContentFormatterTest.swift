import XCTest
@testable import ResponseFormatters
import Util
import Requests
import Responses

class ContentFormatterTest: XCTestCase {
  func testItCanUpdateBodyWithFileContents() {
    let response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/file1": Data(bytes: "this is a text file.".toBytes),
       "/file2": Data(bytes: "this is another text file.".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/file1", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.body!, "this is a text file.".toBytes)
  }

  func testItCanUpdateContentTypeHeaderWhenExtensionIsMissing() {
    let response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/file1": Data(bytes: "this is a text file.".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/file1", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.headers["Content-Type"]!, "text/html")
  }

  func testItCanAppendContentTypeHeaderToExistingHeaders() {
    let response = HTTPResponse(status: TwoHundred.Ok, headers: ["Date": "today"])

    let contents = ResourceData(
      ["/file1": Data(bytes: "this is a text file.".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/file1", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.headers, ["Date": "today", "Content-Type": "text/html"])
  }

  func testItCanUpdateBodyWithImageContents() {
    let response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/image.jpeg": Data(bytes: "some encoded stuff".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/image.jpeg", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.body!, "some encoded stuff".toBytes)
  }

  func testItCanUpdateContentTypeHeaderWithJPEG() {
    let response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/image.jpeg": Data(bytes: "some encoded stuff".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/image.jpeg", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.headers["Content-Type"]!, "image/jpeg")
  }

  func testItCanUpdateContentTypeHeaderWithPNG() {
    let response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/image.png": Data(bytes: "some encoded stuff".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/image.png", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.headers["Content-Type"]!, "image/png")
  }

  func testItCanUpdateContentTypeHeaderWithGIF() {
    let response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/image.gif": Data(bytes: "some encoded stuff".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/image.gif", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.headers["Content-Type"]!, "image/gif")
  }

  func testItCanUpdateContentTypeHeaderWithTXT() {
    let response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/file1.txt": Data(bytes: "this is a text file.".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/file1.txt", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.headers["Content-Type"]!, "text/plain")
  }

  func testItCanAppendFileDataToExistingResponseBody() {
    let response = HTTPResponse(status: TwoHundred.Ok, body: "hello, ")

    let contents = ResourceData(
      ["/file1.txt": Data(bytes: "this is a text file.".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/file1.txt", data: contents)
    let newResponse = contentFormatter.addToResponse(response)

    XCTAssertEqual(newResponse.body!, "hello, \n\nthis is a text file.".toBytes)
  }
}
