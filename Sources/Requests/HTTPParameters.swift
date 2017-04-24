public class HTTPParameters {
  public let keyValueSeparator = "="
  public let multipleSeparator = "&"
  public var keys: [String] = []
  public var values: [String] = []

  public init?(for rawParams: String) {
    let flattenedParams = rawParams
                            .components(separatedBy: multipleSeparator)
                            .flatMap(separateKeyValuePair)
                            .filter { !$0.isEmpty }

    guard flattenedParams.count >= 2 else {
      return nil
    }

    for (index, param) in flattenedParams.enumerated() {
      if index == flattenedParams.count - 1, flattenedParams.count % 2 != 0 {
        break
      }

      if index % 2 == 0 {
        keys.append(decode(param))
      } else {
        values.append(decode(param))
      }
    }
  }

  private func separateKeyValuePair(_ rawParameter: String) -> [String] {
    return rawParameter.components(separatedBy: keyValueSeparator)
  }

  private func decode(_ rawParams: String) -> String {
    return rawParams.removingPercentEncoding ?? rawParams
  }

}
