import Foundation
import Errors

public class FileReader {
  let path: String
  let userDirectory: URL

  public init(at path: String) throws {
    guard path == "/Users/patrickwentz/cob_spec/public" else {
      throw ServerStartError.InvalidPublicDirectoryGiven
    }

    self.userDirectory = try FileManager.default.url(
      for: .userDirectory,
      in: .allDomainsMask,
      appropriateFor: nil,
      create: true
    )

    self.path = path
  }

  public func readContents() throws -> [String: [UInt8]] {
    return try getDirectoryContents()
  }

  public func getDirectoryContents() throws -> [String: [UInt8]] {
    let publicFileNames = try getFileNames()
    let relativeDirectoryPath = path.components(separatedBy: "/Users/").last ?? defaultPublicDirPath

    let publicFiles: [String: [UInt8]] = try publicFileNames.reduce([:]) { (result, file) throws in
      let publicFileUrl = userDirectory.appendingPathComponent("\(relativeDirectoryPath)/\(file)")

      let fileData = try Data(contentsOf: publicFileUrl)
      let fileContents: [UInt8] = [UInt8](fileData)

      var mutableResult = result
      mutableResult[file] = fileContents
      return mutableResult
    }

    return publicFiles
  }

  public func getFileNames() throws -> [String] {
    return try FileManager.default.contentsOfDirectory(atPath: path)
  }

  // public func getImage(at url: URL) -> String {
  //   if let imageData = NSData(contentsOf: url) {
  //     return imageData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
  //   } else {
  //     return ""
  //   }
  // }
}
