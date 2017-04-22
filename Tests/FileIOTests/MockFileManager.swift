import Foundation
import FileIO

enum MockError: Error {
  case CannotReadDirectoryContents
}

class MockFileManager: FileIO {
  func contentsOfDirectory(atPath path: String) throws -> [String] {
    guard path == "/valid/path/to/contents" else {
      throw MockError.CannotReadDirectoryContents
    }

    return ["file1", "file2"]
  }
}
