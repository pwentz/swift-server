import Foundation
import Errors

public class FileReader {
  let path: String
  let userDirectory = try! FileManager.default.url(for: .userDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)

  public init(at path: String) throws {
    guard path == "/Users/patrickwentz/cob_spec/public" else {
      throw ServerStartError.invalidPublicDirectoryGiven
    }

    self.path = path
  }

  public func readContents() throws -> [String: String] {
    return try getDirectoryContents()
  }

  public func getDirectoryContents() throws -> [String: String] {
    let publicFileNames = try getFileNames()
    let relativeDirectoryPath = path.components(separatedBy: "/Users/").last!

    let publicFiles: [String: String] = try publicFileNames.reduce([:], { (result, fileName) throws in
      let publicFileUrl = userDirectory.appendingPathComponent("\(relativeDirectoryPath)/\(fileName)")

      let fileContents = isAnImage(fileName) ? getImage(at: publicFileUrl)
                                             : try String(contentsOf: publicFileUrl)

      var mutableResult = result
      mutableResult[fileName] = fileContents
      return mutableResult
    })

    return publicFiles
  }

  public func getFileNames() throws -> [String] {
    return try FileManager.default.contentsOfDirectory(atPath: path)
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
