public protocol Params {
  var keyValueSeparator: String { get }
  var multipleSeparator: String { get }
  var keys: [String] { get }
  var values: [String] { get }
  var isEmpty: Bool { get }

  func toDictionary() -> [String: String]
}

extension String {
  public init?(parameters: Params) {
    if parameters.isEmpty {
      return nil
    }

    var result = ""

    for (index, paramKey) in parameters.keys.enumerated() {
      result += (paramKey + parameters.keyValueSeparator + parameters.values[index] + "\n")
    }

    self.init(result.trimmingCharacters(in: .newlines))
  }
}
