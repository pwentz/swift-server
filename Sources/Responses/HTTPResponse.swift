public struct HTTPResponse {
  public var statusCode: String
  public var headers: [String: String]
  public var body: [UInt8]?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"
  public let bodyDivide: String = "\n\n"

  public init(status: HTTPStatusCode, headers: [String: String] = [:], body: BytesRepresentable? = nil) {
    self.statusCode = status.description
    self.headers = headers
    self.body = body?.toBytes
  }

  public mutating func appendToBody(_ newContent: BytesRepresentable) {
    self.body = body.map { $0 + "\n\n".toBytes + newContent.toBytes } ?? newContent.toBytes
  }

  public mutating func replaceBody(with newContent: BytesRepresentable) {
    self.body = newContent.toBytes
  }

  public mutating func appendToHeaders(with newHeaders: [String: String]) {
    for (key, value) in newHeaders {
      headers[key] = value
    }
  }

  public mutating func updateStatus(with newStatus: HTTPStatusCode) {
    self.statusCode = newStatus.description
  }

  public var formatted: [UInt8] {
    let joinedHeaders = headers.map { $0 + headerDivide + $1 }.joined(separator: crlf)
    let statusLine = "\(transferProtocol) \(statusCode + crlf)"
    let formattedBody = body.map { "\n\n".toBytes + $0 } ?? []

    return statusLine.toBytes + joinedHeaders.toBytes + formattedBody
  }
}
