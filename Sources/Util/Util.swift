import Foundation
import Errors

public func getBase64(of input: String) -> String {
  let data = input.data(using: String.Encoding.utf8)
  return data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
}

public func formatTimestamp(prefix: String) -> String {
  let dateHelper = DateHelper()
  let currentTime = dateHelper.time(separator: ":")
  let today = dateHelper.date(separator: "-")

  return "\(prefix)-\(currentTime)--\(today)"
}

public func isAnImage(_ file: String) -> Bool {
  return file.hasSuffix("jpeg") ||
          file.hasSuffix("gif") ||
           file.hasSuffix("png")
}

public func getPublicDirectoryContents(flag: String) throws -> [String: String] {
  let args = CommandLine.arguments

  if let directoryFlagIndex = args.index(where: { file in file.contains(flag) }) {
    guard directoryFlagIndex != args.count - 1 else {
      throw ServerStartError.missingPublicDirectoryArgument
    }

    let pathIndex = args.index(after: directoryFlagIndex)
    let directoryPath = args[pathIndex]

    do {
      return try FileReader(at: directoryPath).readContents()
    }
    catch { throw error }
  }
  else {
    throw ServerStartError.missingDirectoryFlagArgument
  }
}

public let logsPath = "patrickwentz/8th-light/projects/swift/server/Sources/Server/Debug"
