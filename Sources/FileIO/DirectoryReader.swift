import Config
import Errors

public class DirectoryReader {
  let fileManager: FileIO

  public init(_ fileManager: FileIO) {
    self.fileManager = fileManager
  }

  public func getFileNames(at path: String) throws -> [String] {
    do {
      return try fileManager.contentsOfDirectory(atPath: path)
    } catch {
      throw ServerStartError.InvalidPublicDirectoryGiven
    }
  }

}
