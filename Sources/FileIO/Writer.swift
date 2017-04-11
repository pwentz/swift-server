import Foundation

public class Writer<WritableLocation> {
  let content: Writable
  let destination: WritableLocation

  public init(at destination: WritableLocation, with content: Writable) throws {
    self.content = content
    self.destination = destination
  }

  public func write() throws {
    try content.write(to: destination)
  }

}
