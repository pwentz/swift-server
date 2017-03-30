import Foundation
import Errors

public func getBase64(of input: String) -> String? {
  let data = input.data(using: .utf8)
  return data.map {
    $0.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
  }
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

public func getRange(of rawRange: String, length contentLength: Int) -> Range<Int> {
  let splitRange = rawRange.components(separatedBy: "-")
  let rawStart = splitRange[splitRange.startIndex]
  let rawEnd = splitRange[splitRange.index(before: splitRange.endIndex)]

  let rangeEnd = Int(rawEnd) ?? contentLength - 1

  let rangeStart = Int(rawStart) ?? contentLength - rangeEnd

  return rangeEnd < rangeStart ? rangeStart..<contentLength
                               : rangeStart..<rangeEnd + 1
}

public let logsPath = "/Users/patrickwentz/8th-light/projects/swift/server/Sources/Server/Debug"
public let defaultPublicDirPath = "/Users/patrickwentz/cob_spec/public"
public let authCredentials = "admin:hunter2"
