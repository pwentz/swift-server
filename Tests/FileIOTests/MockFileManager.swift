import FileIO

class MockFileManager: FileIO {
  func contentsOfDirectory(atPath path: String) throws -> [String] {
    return ["file1", "file2"]
  }
}
