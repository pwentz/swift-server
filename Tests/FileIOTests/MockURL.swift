import FileIO
import Foundation

class MockContent: WritableLocation {
  let fileURLWithPath: String
  var writableContent: String = ""

  init(fileURLWithPath: String) {
    self.fileURLWithPath = fileURLWithPath
  }

  func write(writableContent: String) throws {
    self.writableContent = writableContent
  }
}

