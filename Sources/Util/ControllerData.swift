import Foundation

public class ControllerData {
  private var contents: [String: Data]
  private let nonFiles: [String]
  public let fileNames: [String]

  public init(_ fileContents: [String: Data], nonFiles: [String] = []) {
    var contents = fileContents

    nonFiles.forEach {
      contents[$0] = Data(value: "")
    }

    self.contents = contents
    self.nonFiles = nonFiles
    self.fileNames = [String](fileContents.keys)
  }

  public func update(_ key: String, withVal value: String) {
    contents.updateValue(Data(value: value), forKey: key)
  }

  public func get(_ key: String) -> String? {
    return contents[key].flatMap { String(data: $0, encoding: .utf8) }
  }

  public func getBinary(_ key: String) -> Data? {
    return contents[key]
  }

//   public func fileNames() -> [String] {
//     return contents.keys.filter { !nonFiles.contains($0) }
//   }

  public func remove(at key: String) {
    contents[key] = nil
  }

}

public extension Data {
  init(value: String) {
    self.init(bytes: Array(value.utf8))
  }
}
