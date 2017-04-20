import FileIO
import Foundation

class MockContent: Writable {
  let fileURLWithPath: String
  var content: String? = nil

  init(fileURLWithPath: String) {
    self.fileURLWithPath = fileURLWithPath
  }

  func write(_ content: String) throws {
    self.content = content
  }
}

