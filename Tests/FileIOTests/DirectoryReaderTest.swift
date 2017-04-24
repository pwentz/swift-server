import XCTest
@testable import FileIO
import Errors

class FileReaderTest: XCTestCase {
  let fileReader = DirectoryReader(MockFileManager())

  func testItCanReadFileNames() {
    let path = "/valid/path/to/contents"
    let result = try! fileReader.getFileNames(at: path)

    XCTAssertEqual(result, ["file1", "file2"])
  }

  func testItThrowsIfPathIsInvalid() throws {
    let path = "/some/random/path"

    XCTAssertThrowsError(try fileReader.getFileNames(at: path)) { error in
      XCTAssertEqual(error as! ServerStartError, ServerStartError.InvalidPublicDirectoryGiven)
    }
  }
}
