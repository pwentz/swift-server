import Foundation

public struct HTTPRequest {
  public let path: String
  public let verb: HTTPRequestMethod?
  public let body: String?
  public let params: HTTPParameters?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"
  private let parameterDivide: String = "?"

  public var headers: [String: String] = [:]

  public var shouldHaveBody: Bool {
    return self.verb == .Post ||
            self.verb == .Patch ||
              self.verb == .Put
  }

  public init?(for rawRequest: String) {
    let splitRequest = rawRequest.components(separatedBy: crlf)
    let requestTail = splitRequest[splitRequest.index(before: splitRequest.endIndex)]

    let splitRequestLine = splitRequest[splitRequest.startIndex].components(separatedBy: " ")

    guard splitRequestLine.count >= 2 else {
      return nil
    }

    let givenVerb = splitRequestLine[splitRequestLine.startIndex]

    let fullPath = splitRequestLine[splitRequestLine.index(after: splitRequestLine.startIndex)]

    let splitPath = fullPath.components(separatedBy: parameterDivide)

    verb = HTTPRequestMethod(rawValue: givenVerb.capitalized)

    path = fullPath.range(of: parameterDivide).map { fullPath.substring(to: $0.lowerBound) } ?? fullPath

    params = splitPath.first(where: { $0.contains("=") }).flatMap { HTTPParameters(for: $0) }

    body = requestTail.isEmpty ? nil : requestTail

    headers = splitRequest
               .dropFirst()
               .dropLast()
               .reduce([:], requestHeaders)
  }

  private func requestHeaders(_ result: [String: String], _ rawHeader: String) -> [String: String] {
    var mutableResult = result
    let separatorIndex = rawHeader.range(of: ":")

    // missing key w/ value or vice-versa appears as empty string
    let key = separatorIndex.map {
      rawHeader.substring(to: $0.lowerBound)
               .trimmingCharacters(in: .whitespaces)
               .lowercased()
    } ?? ""

    let value = separatorIndex.map {
      rawHeader.substring(from: $0.upperBound)
               .trimmingCharacters(in: .whitespaces)
    } ?? ""

    if !key.isEmpty, !value.isEmpty {
      mutableResult[key] = value
    }

    return mutableResult
  }

}
