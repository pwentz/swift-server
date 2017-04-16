public struct HTTPRequest {
  public let verb: HTTPRequestMethod
  public let path: String
  public let pathName: String
  public let params: HTTPParameters?
  public let body: String?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"
  private let parameterDivide: String = "?"
  private let parameterKeyValueSeparator: String = "="

  public var headers: [String: String] = [:]

  public init?(for rawRequest: String) {
    let splitRequest = rawRequest.components(separatedBy: crlf)
    let requestTail = splitRequest[splitRequest.index(before: splitRequest.endIndex)]

    let splitMainHeader = splitRequest[splitRequest.startIndex].components(separatedBy: " ")

    guard splitMainHeader.count >= 2 else {
      return nil
    }

    let givenVerb = splitMainHeader[splitMainHeader.startIndex]

    let fullPath = splitMainHeader[splitMainHeader.index(after: splitMainHeader.startIndex)]

    let splitPath = fullPath.components(separatedBy: parameterDivide)

    let separator = parameterKeyValueSeparator

    verb = HTTPRequestMethod(rawValue: givenVerb.capitalized).map { $0 } ?? .Invalid

    path = fullPath.range(of: parameterDivide).map { fullPath.substring(to: $0.lowerBound) } ?? fullPath
    pathName = path.substring(from: path.index(after: path.startIndex))

    params = splitPath.first(where: { $0.contains(separator) }).flatMap { params -> HTTPParameters? in
      let dividedParams = params.components(separatedBy: separator).filter { !$0.isEmpty }
      return dividedParams.count >= 2 ? HTTPParameters(for: params) : nil
    }

    body = requestTail.contains(headerDivide) ? nil : requestTail

    headers = splitRequest
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
