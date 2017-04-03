import Foundation
import Errors

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
