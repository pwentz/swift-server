import Foundation

// component should throw

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

    publicFileNames.forEach {
      let relativeDirectoryPath = path.components(separatedBy: "/Users/").last!
      let publicFileUrl = userDirectory.appendingPathComponent("\(relativeDirectoryPath)/\($0)")
      let isAnImage = $0.contains("jpeg") || $0.contains("gif") || $0.contains("png")

      do {
        let fileContents = isAnImage ? getImage(at: publicFileUrl)
                                     : try String(contentsOf: publicFileUrl)

        publicFiles.updateValue(fileContents, forKey: $0)
      }
      catch let error as NSError {
        print("ERROR!!!", error)
      }
    }

    return publicFiles
  }

  public func getImage(at url: URL) -> String {
    if let imageData = NSData(contentsOf: url) {
      return imageData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    else {
      return ""
    }
  }
}
