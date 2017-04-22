import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class DirectoryLinksFormatterTest: XCTestCase {
  let ok = TwoHundred.Ok

  func testItReturnNewResponseWithAddedDirectoryLinks() {
    let response = HTTPResponse(status: ok)

    let files = ["/file1", "/file2"]

    let newResponse = DirectoryLinksFormatter(files: files).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "<a href=\"/file1\">file1</a><br><a href=\"/file2\">file2</a>"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItReturnsANewResponseWithExistingBodyAndAdditionalLinks() {
    let response = HTTPResponse(status: TwoHundred.Ok, body: "neat!")

    let files = ["/file1", "/file2"]

    let newResponse = DirectoryLinksFormatter(files: files).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "neat!\n\n<a href=\"/file1\">file1</a><br><a href=\"/file2\">file2</a>"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItDoesNotAddDirectoryLinksIfFilesAreNil() {
    let response = HTTPResponse(status: ok)

    let newResponse = DirectoryLinksFormatter(files: nil).addToResponse(response)

    XCTAssertNil(newResponse.body)
  }

  func testItReturnsNewResponseBodyAsIsIfFilesAreNil() {
    let response = HTTPResponse(status: ok, body: "neat!")

    let newResponse = DirectoryLinksFormatter(files: nil).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "neat!"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItDoesNotAppendHTMLDataWhenContentTypeIsText() {
    let response = HTTPResponse(
      status: TwoHundred.Ok,
      headers: ["Content-Type": "text/plain"],
      body: "some image content"
    )

    let files = ["/someRoute"]

    let newResponse = DirectoryLinksFormatter(files: files).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      headers: ["Content-Type": "text/plain"],
      body: "some image content"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }
}
