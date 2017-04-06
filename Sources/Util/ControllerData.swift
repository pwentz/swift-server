import Foundation

public class ControllerData {
  private var contents: [String: Data]
  private let nonFiles: [String]

  public init(_ fileContents: [String: Data], nonFiles: [String] = []) {
    var contents = fileContents

    nonFiles.forEach {
      contents[$0] = Data(value: "")
    }

    self.contents = contents
    self.nonFiles = nonFiles
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
    return contents.keys.filter { !nonFiles.contains($0) }
  }

}

public extension Data {
  init(value: String) {
    self.init(bytes: Array(value.utf8))
  }
}
