import Foundation

public struct HTTPRequest: Request {
  public let verb: HTTPRequestMethod
  public let path: String
  public let pathName: String
  public let params: Params?
  public let body: String?
  public let crlf: String = "\r\n"
  public let parameterDivide: String = "?"

  public var headers: [String: String] = [:]

  public init(for rawRequest: String) {
    let parsedRequest = rawRequest.components(separatedBy: crlf)

    let mainHeaderParsed = parsedRequest.first?.components(separatedBy: " ") ?? [rawRequest]
    let givenVerb = mainHeaderParsed[mainHeaderParsed.startIndex]

    verb = HTTPRequestMethod(rawValue: givenVerb.capitalized).map { $0 } ?? .Invalid

    let fullPath = mainHeaderParsed[mainHeaderParsed.index(after: mainHeaderParsed.startIndex)]

    let parsedPath = fullPath.components(separatedBy: parameterDivide)

    path = parsedPath.first ?? fullPath
    pathName = path.substring(from: path.index(after: path.startIndex))

    params = parsedPath.index(where: { $0.contains("=") }).map { _ in Params(for: fullPath) }

    let requestTail = parsedRequest[parsedRequest.index(before: parsedRequest.endIndex)]

    body = requestTail.contains(":") ? nil : requestTail

    headers = parsedRequest
               .dropFirst()
               .map { RequestHeader(for: $0) }
               .filter { !$0.key.isEmpty && !$0.value.isEmpty }
               .reduce([:], toDictionary)
  }

  private func toDictionary(result: [String: String], header: RequestHeader) -> [String: String] {
    var mutable = result
    mutable[header.key] = header.value
    return mutable
  }

}
