import XCTest
@testable import FileIO
import Errors

class FileReaderTest: XCTestCase {
  func testItCanReadFileNames() {
    let path = "/Users/patrickwentz/cob_spec/public"
    let fileManager = MockFileManager()

    let fileReader = FileReader(fileManager)

    let result = try! fileReader.getFileNames(at: path)

    XCTAssertEqual(result, ["file1", "file2"])
  }

  func testItThrowsIfPathIsNotCobSpecPath() throws {
    let path = "/some/random/path"
    let fileManager = MockFileManager()

    let fileReader = FileReader(fileManager)

    XCTAssertThrowsError(try fileReader.getFileNames(at: path)) { error in
      XCTAssertEqual(error as! ServerStartError, ServerStartError.InvalidPublicDirectoryGiven)
    }
  }
}
