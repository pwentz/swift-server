import XCTest
@testable import FileIO

class WritableLocationTest: XCTestCase {

  func testWriteMethodCallsWritableWriteMethod() throws {
    let path = "/some/path/to/somewhere"
    let content = MockContent(fileURLWithPath: path + "/file1")

    try content.write("some stuff")

    XCTAssertEqual(content.content!, "some stuff")
  }

}
