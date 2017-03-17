public class Params {
  public let path: String

  public init(for path: String) {
    self.path = path
  }

  public func toString() -> String {
    let rawParams = path.components(separatedBy: "?").last ?? ""

    return rawParams
  }

  public func toDictionary() -> [String: String] {
    var zippedParams: [String: String] = [:]

    for (index, paramKey) in keys().enumerated() {
      zippedParams[paramKey] = values()[index]
    }

    return zippedParams
  }

  public func keys() -> [String] {
    let stringParams = toString()
    let splitParams = stringParams.components(separatedBy: "=")

    return [splitParams.first!]
  }

  public func values() -> [String] {
    let stringParams = toString()
    let splitParams = stringParams.components(separatedBy: "=")

    return [splitParams.last!]
  }
}
