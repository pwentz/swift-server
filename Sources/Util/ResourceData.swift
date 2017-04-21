import Responses
import Foundation

public class ResourceData {
  private var contents: [String: BytesRepresentable]
  public let fileNames: [String]

  public init(_ fileContents: [String: BytesRepresentable]) {
    self.contents = fileContents
    self.fileNames = [String](fileContents.keys)
  }

  public subscript(key: String) -> BytesRepresentable? {
    return contents[key]
  }

  public func update(_ key: String, withVal value: String?) {
    contents.updateValue(value ?? "", forKey: key)
  }

  public func remove(at key: String) {
    contents[key] = nil
  }

}

public class EmptyResourceData: ResourceData {
  public init() {
    super.init([:])
  }
}
