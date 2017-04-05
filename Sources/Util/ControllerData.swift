import Foundation

public extension Data {
  init(value: String) {
    self.init(bytes: Array(value.utf8))
  }
}

public class ControllerData {
  public var contents: [String: Data]

  public init(_ contents: [String: Data]) {
    self.contents = contents
  }

  public func update(_ key: String, withVal value: String) {
    contents.updateValue(Data(value: value), forKey: key)
  }

  public func get(_ key: String) -> String {
    return String(data: contents[key] ?? Data(), encoding: .utf8) ?? ""
  }

  public func getBinary(_ key: String) -> Data {
    return contents[key] ?? Data()
  }

  public func addNew(key: String, value: String) {
    contents[key] = Data(value: value)
  }

  public func fileNames() -> [String] {
    return contents.keys.filter { $0 != "form" && $0 != "logs" }
  }

}
