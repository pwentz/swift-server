import Foundation
import Shared
import Errors

public class DirectoryReader {
  let fileManager: FileIO

  public init(_ fileManager: FileIO) {
    self.fileManager = fileManager
  }

  public func getFileNames(at path: String) throws -> [String] {
    guard path == defaultPublicDirPath else {
      throw ServerStartError.InvalidPublicDirectoryGiven
    }

    return try fileManager.contentsOfDirectory(atPath: path)
  }

}
