import Foundation

public class FileReader {
  let path: String
  let userDirectory = try! FileManager.default.url(for: .userDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)

  public init(at path: String) {
    self.path = path
  }

  public func readContents() -> [String: String] {
    return getDirectoryContents()
  }

  public func getDirectoryContents() -> [String: String] {
    let publicFileNames = try! FileManager.default.contentsOfDirectory(atPath: path)
    var publicFiles: [String: String] = [:]

    for file in publicFileNames {
      let relativeDirectoryPath = path.components(separatedBy: "/Users/").last!
      let publicFileUrl = userDirectory.appendingPathComponent("\(relativeDirectoryPath)/\(file)")

      do {
        let fileContents = try String(contentsOf: publicFileUrl)

        publicFiles.updateValue(fileContents, forKey: file)

      } catch let fileError as NSError {
        print("ERROR: ", fileError)
      }
    }

    return publicFiles
  }
}
