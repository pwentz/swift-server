import Foundation

public class ControllerData {
  public var contents: [String: [UInt8]]

  public init(_ contents: [String: [UInt8]]) {
    self.contents = contents
  }

  public func update(_ key: String, withVal value: String) {
    contents.updateValue(Array(value.utf8), forKey: key)
  }

  public func get(_ key: String) -> String {
    return String(data: Data(contents[key] ?? []), encoding: .utf8)!
  }

  public func getBinary(_ key: String) -> [UInt8] {
    return contents[key] ?? []
  }

  public func addNew(key: String, value: String) {
    contents[key] = Array(value.utf8)
  }

  public func fileNames() -> [String] {
    return contents.keys.filter { $0 != "form" && $0 != "logs" }
  }
}
