extension String {
  public init?(params: HTTPParameters) {

    let result = zip(params.keys, params.values).reduce("") { res, zipped in
      res + (zipped.0 + params.keyValueSeparator + zipped.1 + "\n")
    }

    self.init(result.trimmingCharacters(in: .newlines))
  }
}
