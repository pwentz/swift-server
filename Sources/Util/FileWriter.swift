import Foundation

public class FileWriter {
  let path: String
  let content: String

  public init(at path: String, with content: String) throws {
    self.path = path
    self.content = content
  }

  public func write(to fileName: String, fileExtension: String = "txt") throws {
    let logsFileUrl = URL(fileURLWithPath: path + "/" + fileName)
                         .appendingPathExtension(fileExtension)

    try content.write(to: logsFileUrl, atomically: true, encoding: .utf8)
  }
}
