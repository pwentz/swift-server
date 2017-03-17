import Foundation

public class FileWriter {
  let path: String
  let content: String
  let userDirectory = try! FileManager.default.url(for: .userDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)

  public init(at path: String, with content: String) {
    self.path = path
    self.content = content
  }

  public func write(to fileName: String, fileExtension: String = "txt") -> Void {
    let logsFileUrl = userDirectory.appendingPathComponent("\(path)/\(fileName)").appendingPathExtension(fileExtension)

    do {
      try content.write(to: logsFileUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
      print("******* ERROR **********", error)
    }
  }
}


