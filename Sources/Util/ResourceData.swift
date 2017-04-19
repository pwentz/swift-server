import Responses
import Foundation

public class ResourceData {
  private var contents: [String: Data]
  public let fileNames: [String]

  public init(_ fileContents: [String: Data]) {
    self.contents = fileContents
    self.fileNames = [String](fileContents.keys)
  }

  public func update(_ key: String, withVal value: String?) {
    guard let confirmedValue = value else {
      return
    }

    contents.updateValue(confirmedValue.toData, forKey: key)
  }

  public func get(_ key: String) -> String? {
    return contents[key].flatMap { String(data: $0, encoding: .utf8) }
  }

  public func getBinary(_ key: String) -> Data? {
    return contents[key]
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
