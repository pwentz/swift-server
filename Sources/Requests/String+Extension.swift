extension String {
  public init?(params: HTTPParameters) {

    let result = zip(params.keys, params.values).reduce("") { res, zipped in
      res + (zipped.0 + params.keyValueSeparator + zipped.1 + "\n")
    }

    self.init(result.trimmingCharacters(in: .newlines))
  }

  public func prepend(_ value: String) -> String {
    return value + self
  }

  public func trimAndRemoveMultiples(of value: String) -> String {
    return self
             .components(separatedBy: value)
             .filter { !$0.isEmpty }
             .joined(separator: value)
  }
}
