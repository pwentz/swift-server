import Foundation

extension URL: Writable {

  public func write(_ content: String) throws {
    return try content.write(to: self, atomically: true, encoding: .utf8)
  }

}
