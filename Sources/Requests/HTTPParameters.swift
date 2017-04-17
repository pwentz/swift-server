public class HTTPParameters {
  public let rawParams: String
  public let keyValueSeparator: String = "="
  public let multipleSeparator: String = "&"
  public var keys: [String] = []
  public var values: [String] = []

  public var isEmpty: Bool {
    return keys.isEmpty && values.isEmpty
  }

  public init(for rawParams: String) {
    self.rawParams = rawParams

    let flattenedParams = rawParams.components(separatedBy: multipleSeparator)
                                   .flatMap { $0.components(separatedBy: keyValueSeparator) }
                                   .filter { !$0.isEmpty }

    for (index, param) in flattenedParams.enumerated() {
      if index == flattenedParams.count - 1 && flattenedParams.count % 2 != 0 {
        break
      }

      if index % 2 == 0 {
        keys.append(decode(param))
      } else {
        values.append(decode(param))
      }
    }
  }

  public func toDictionary() -> [String: String] {
    var matchedParams: [String: String] = [:]

    if isEmpty {
      return matchedParams
    }

    for (index, key) in keys.enumerated() {
      matchedParams[key] = values[index]
    }

    return matchedParams
  }

  private func decode(_ rawParams: String) -> String {
    return rawParams.removingPercentEncoding ?? rawParams
  }

}

extension String {
  public init?(parameters: HTTPParameters) {
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
