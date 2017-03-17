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
    do { return try getDirectoryContents() }
    catch {
      throw error
    }
  }

  public func getDirectoryContents() throws -> [String: String] {
    do {
      let publicFileNames = try getFileNames()
      var publicFiles: [String: String] = [:]
      let relativeDirectoryPath = path.components(separatedBy: "/Users/").last!

      try publicFileNames.forEach { fileName in
        let publicFileUrl = userDirectory.appendingPathComponent("\(relativeDirectoryPath)/\(fileName)")

        let fileContents = isAnImage(fileName) ? getImage(at: publicFileUrl)
                                               : try String(contentsOf: publicFileUrl)

        publicFiles.updateValue(fileContents, forKey: fileName)
      }

      return publicFiles
    }
    catch {
      throw error
    }
  }

  public func getFileNames() throws -> [String] {
    do {
      return try FileManager.default.contentsOfDirectory(atPath: path)
    }
    catch {
      throw error
    }
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
