public protocol Params {
  var keyValueSeparator: String { get }
  var multipleSeparator: String { get }
  var keys: [String] { get }
  var values: [String] { get }

  func toDictionary() -> [String: String]
}


public protocol Parameterizable {
  init?(parameters: Params)
}


extension String: Parameterizable {
  public init?(parameters: Params) {
    var result = ""

    if parameters.keys.isEmpty && parameters.values.isEmpty {
      return nil
    }

    for (index, paramKey) in parameters.keys.enumerated() {
      result += (paramKey + parameters.keyValueSeparator + parameters.values[index] + "\n")
    }

    self.init(result.trimmingCharacters(in: .newlines))
  }
}
