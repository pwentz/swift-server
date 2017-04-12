import Foundation

extension URL: WritableLocation {
  public func write(writableContent: String) throws {
    return try writableContent.write(to: self, atomically: true, encoding: .utf8)
  }
}
