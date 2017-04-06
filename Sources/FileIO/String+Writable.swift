import Foundation

extension String: Writable {
  public func write<WriteableLocation>(to destination: WriteableLocation) throws {
    if let urlDestination = destination as? URL {
      try self.write(to: urlDestination, atomically: true, encoding: .utf8)
    }
  }
}
