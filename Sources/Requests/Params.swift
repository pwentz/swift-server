import Foundation

public class Params {
  public let path: String

  public init(for path: String) {
    self.path = path
  }

  public func toString() -> String {
    let formattedParams = getParams().replacingOccurrences(of: "&", with: "\n")

    return decode(formattedParams)
  }

  public func toDictionary() -> [String: String] {
    var zippedParams: [String: String] = [:]

    for (index, paramKey) in keys().enumerated() {
      zippedParams[paramKey] = values()[index]
    }

    return zippedParams
  }

  public func keys() -> [String] {
    return getParams().components(separatedBy: "&").map {
      decode($0.components(separatedBy: "=").first ?? "")
    }
  }

  public func values() -> [String] {
    return getParams().components(separatedBy: "&").map {
      decode($0.components(separatedBy: "=").last ?? "")
    }
  }

  private func getParams() -> String {
    return path.components(separatedBy: "?").last ?? ""
  }

  private func decode(_ rawParams: String) -> String {
    return rawParams.removingPercentEncoding ?? rawParams
  }

}
