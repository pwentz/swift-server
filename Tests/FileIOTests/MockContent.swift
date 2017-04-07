import FileIO
import Foundation

class MockContent: Writable {
  var didWrite: Bool = false
  var givenArgs: URL = URL(fileURLWithPath: "")

  func write<WriteableLocation>(to destination: WriteableLocation) throws {
    didWrite = true
    givenArgs = destination as! URL
  }
}

