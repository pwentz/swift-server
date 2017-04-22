import XCTest
@testable import FileIO
import Errors

class FileReaderTest: XCTestCase {
  func testItCanReadFileNames() {
    let path = "/valid/path/to/contents"
    let fileManager = MockFileManager()

    let fileReader = DirectoryReader(fileManager)

    let result = try! fileReader.getFileNames(at: path)

    XCTAssertEqual(result, ["file1", "file2"])
  }

  func testItThrowsIfPathIsInvalid() throws {
    let path = "/some/random/path"
    let fileManager = MockFileManager()

    let fileReader = DirectoryReader(fileManager)

    XCTAssertThrowsError(try fileReader.getFileNames(at: path)) { error in
      XCTAssertEqual(error as! ServerStartError, ServerStartError.InvalidPublicDirectoryGiven)
    }
  }
}
