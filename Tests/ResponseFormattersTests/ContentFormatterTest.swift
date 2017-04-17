import XCTest
@testable import ResponseFormatters
import Util
import Requests
import Responses

class ContentFormatterTest: XCTestCase {
  func testItCanUpdateBodyWithFileContents() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/file1": Data(bytes: "this is a text file.".toBytes),
       "/file2": Data(bytes: "this is another text file.".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/file1", data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.body!, "\n\nthis is a text file.".toBytes)
  }

  func testItCanUpdateContentTypeHeaderWhenExtensionIsMissing() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/file1": Data(bytes: "this is a text file.".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/file1", data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/html")
  }

  func testItCanUpdateBodyWithImageContents() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/image.jpeg": Data(bytes: "some encoded stuff".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/image.jpeg", data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.body!, "\n\nsome encoded stuff".toBytes)
  }

  func testItCanUpdateContentTypeHeaderWithJPEG() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/image.jpeg": Data(bytes: "some encoded stuff".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/image.jpeg", data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/jpeg")
  }

  func testItCanUpdateContentTypeHeaderWithPNG() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/image.png": Data(bytes: "some encoded stuff".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/image.png", data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/png")
  }

  func testItCanUpdateContentTypeHeaderWithGIF() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/image.gif": Data(bytes: "some encoded stuff".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/image.gif", data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "image/gif")
  }

  func testItCanUpdateContentTypeHeaderWithTXT() {
    var response = HTTPResponse(status: TwoHundred.Ok)

    let contents = ResourceData(
      ["/file1.txt": Data(bytes: "this is a text file.".toBytes)]
    )

    let contentFormatter = ContentFormatter(for: "/file1.txt", data: contents)
    contentFormatter.execute(on: &response)

    XCTAssertEqual(response.headers["Content-Type"]!, "text/plain")
  }
}
