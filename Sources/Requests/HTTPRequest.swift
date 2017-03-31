import Foundation

public struct HTTPRequest: Request {
  public let verb: HTTPRequestMethod
  public let path: String
  public let pathName: String
  public let params: Params?
  public let body: String?
  public let crlf: String = "\r\n"
  public let parameterDivide: String = "?"
  public let parameterKeyValueSeparator: String = "="

  public var headers: [String: String] = [:]

  public init(for rawRequest: String) {
    let parsedRequest = rawRequest.components(separatedBy: crlf)
    let requestTail = parsedRequest[parsedRequest.index(before: parsedRequest.endIndex)]

    let mainHeaderParsed = parsedRequest.first?.components(separatedBy: " ") ?? [rawRequest]
    let givenVerb = mainHeaderParsed[mainHeaderParsed.startIndex]

    let fullPath = mainHeaderParsed[mainHeaderParsed.index(after: mainHeaderParsed.startIndex)]

    let parsedPath = fullPath.components(separatedBy: parameterDivide)

    let separator = parameterKeyValueSeparator

    verb = HTTPRequestMethod(rawValue: givenVerb.capitalized).map { $0 } ?? .Invalid

    path = parsedPath.first ?? fullPath
    pathName = path.substring(from: path.index(after: path.startIndex))

    params = parsedPath.index(where: { $0.contains(separator) }).flatMap { index -> HTTPParameters? in
      let dividedParams = parsedPath[index].components(separatedBy: separator).filter { !$0.isEmpty }
      if dividedParams.count < 2 {
        return nil
      }

      return HTTPParameters(for: parsedPath[index])
    }

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
