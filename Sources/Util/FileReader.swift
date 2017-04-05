import Foundation
import Shared
import Errors

public class FileReader {
  let path: String

  public init(at path: String) throws {
    guard path == defaultPublicDirPath else {
      throw ServerStartError.InvalidPublicDirectoryGiven
    }

    self.path = path
  }

  public func read() throws -> [String: Data] {
    return try getFileNames().reduce([:]) { (result, file) throws in

      let fileData = try Data(
        contentsOf: URL(fileURLWithPath: path + "/" + file)
      )

      var mutableResult = result
      mutableResult[file] = fileData
      return mutableResult
    }
  }

  public func getFileNames() throws -> [String] {
    return try FileManager.default.contentsOfDirectory(atPath: path)
  }

}
