import XCTest
@testable import FileIO

class FileWriterTest: XCTestCase {
  func testInitDoesNotCallWritableWriteMethod() {
    let path = "/some/path/to/somewhere"
    let content = MockContent()
    let url = URL(fileURLWithPath: path + "/file1").appendingPathExtension("txt")

    let _ = try! FileWriter<URL>(at: url, with: content)

    XCTAssert(content.didWrite == false)
  }

  func testWriteMethodCallsWritableWriteMethod() {
    let path = "/some/path/to/somewhere"
    let content = MockContent()
    let url = URL(fileURLWithPath: path + "/file1").appendingPathExtension("txt")

    let fileWriter = try! FileWriter<URL>(at: url, with: content)

    try! fileWriter.write()

    XCTAssert(content.didWrite)
  }

  func testWriteMethodPassesFullURLToWritableWriteMethod() {
    let path = "/some/path/to/somewhere"
    let content = MockContent()
    let url = URL(fileURLWithPath: path + "/file1").appendingPathExtension("txt")

    let fileWriter = try! FileWriter<URL>(at: url, with: content)

    let expected = URL(fileURLWithPath: "/some/path/to/somewhere/file1.txt")

    try! fileWriter.write()

    XCTAssertEqual(content.givenArgs, expected)
  }
}
