import Foundation

struct RequestHeader {
  let key: String
  let value: String

  init(for rawHeader: String) {
    let separatorIndex = rawHeader.range(of: ":")

    key = separatorIndex.map {
      rawHeader.substring(to: $0.lowerBound)
               .trimmingCharacters(in: .whitespaces)
               .lowercased()
    } ?? ""

    value = separatorIndex.map {
      rawHeader.substring(from: $0.upperBound)
               .trimmingCharacters(in: .whitespaces)
    } ?? ""

  }
}
