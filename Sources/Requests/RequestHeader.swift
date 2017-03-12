struct RequestHeader {
  let key: String
  let value: String

  init(for rawHeader: String) {
    let separatorIndex = rawHeader.characters.index(of: ":")!

    key = rawHeader[rawHeader.startIndex..<separatorIndex]
                   .trimmingCharacters(in: .whitespaces)
                   .lowercased()

    value = rawHeader[rawHeader.index(after: separatorIndex)..<rawHeader.endIndex]
                     .trimmingCharacters(in: .whitespaces)
  }
}
