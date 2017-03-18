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

public let logsPath = "patrickwentz/8th-light/projects/swift/server/Sources/Server/Debug"
