import Foundation

public class FileWriter {
  let path: String
  let content: String
  let userDirectory: URL

  public init(at path: String, with content: String) throws {
    self.path = path
    self.content = content
    self.userDirectory = try FileManager.default.url(
      for: .userDirectory,
      in: .allDomainsMask,
      appropriateFor: nil,
      create: true
    )
  }

  public func write(to fileName: String, fileExtension: String = "txt") throws {
    let logsFileUrl = userDirectory.appendingPathComponent("\(path)/\(fileName)")
                                   .appendingPathExtension(fileExtension)

    do {
      try content.write(to: logsFileUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      throw error
    }
  }
}
