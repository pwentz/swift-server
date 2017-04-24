import Foundation

public struct HTTPRequest {
  public let path: String
  public let verb: HTTPRequestMethod?
  public let body: String?
  public let params: HTTPParameters?
  private let crlf: String = "\r\n"
  private let headerDivide: String = ":"
  private let transferProtocol: String = "HTTP/1.1"
  private let parameterDivide: String = "?"

  public var headers: [String: String] = [:]

  public var shouldHaveBody: Bool {
    return self.verb == .Post ||
            self.verb == .Patch ||
              self.verb == .Put
  }

  public init?(for rawRequest: String) {
    guard rawRequest.contains(transferProtocol) else {
      return nil
    }

    let splitRequest = rawRequest.components(separatedBy: crlf)
    let requestTail = splitRequest.last

    let requestLineParts = splitRequest.first?.components(separatedBy: " ")

    guard let splitRequestLine = requestLineParts, splitRequestLine.count >= 3 else {
      return nil
    }

    let fullPath = splitRequestLine.first(where: { $0.hasPrefix("/") })

    guard let path = fullPath else {
      return nil
    }

    self.verb = splitRequestLine
                  .first
                  .flatMap { HTTPRequestMethod(rawValue: $0.capitalized) }

    self.path = path
                 .range(of: parameterDivide)
                 .flatMap { path.substring(to: $0.lowerBound) } ?? path

    self.params = path
                   .components(separatedBy: parameterDivide)
                   .first(where: { $0.contains("=") })
                   .flatMap(HTTPParameters.init)

    self.body = requestTail.flatMap { $0.isEmpty ? nil : $0 }

    self.headers = splitRequest
                     .dropFirst()
                     .dropLast()
                     .reduce([:], requestHeaders)
  }

  private func requestHeaders(_ result: [String: String], _ rawHeader: String) -> [String: String] {
    var mutableResult = result
    let separatorIndex = rawHeader.range(of: headerDivide)

    let key = separatorIndex.map {
      rawHeader.substring(to: $0.lowerBound)
               .trimmingCharacters(in: .whitespaces)
               .lowercased()
    }

    let value = separatorIndex.map {
      rawHeader.substring(from: $0.upperBound)
               .trimmingCharacters(in: .whitespaces)
    }

    guard let k = key, let v = value, !k.isEmpty, !v.isEmpty else {
      return mutableResult
    }

    mutableResult[k] = v

    return mutableResult
  }

}
