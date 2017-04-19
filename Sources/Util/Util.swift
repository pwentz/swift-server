public func isAnImage(_ file: String) -> Bool {
  return file.hasSuffix("jpeg") ||
          file.hasSuffix("gif") ||
           file.hasSuffix("png")
}

public func parseRangeHeader(_ rangeHeader: String?) -> (start: Int?, end: Int?) {
  let range = rangeHeader?
                .components(separatedBy: "=")
                .last?
                .components(separatedBy: "-")

  let givenEndRange = range?.last.flatMap { Int($0) }
  let givenStartRange = range?.first.flatMap { Int($0) }

  return (start: givenStartRange, end: givenEndRange)
}
