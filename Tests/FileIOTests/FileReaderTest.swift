import XCTest
@testable import FileIO

class MockFileManager: FileIO {
  func contentsOfDirectory(atPath path: String) throws -> [String] {
    return ["file1", "file2"]
  }
}

class FileReaderTest: XCTestCase {
  func testItCanReadFileNames() {
    let path = "/Users/patrickwentz/cob_spec/public"
    let fileManager = MockFileManager()

    let fileReader = FileReader(fileManager)

    let result = try! fileReader.getFileNames(at: path)

    XCTAssertEqual(result, ["file1", "file2"])
  }

  func testItCanThrow() {
    // implement me!
  }
}
