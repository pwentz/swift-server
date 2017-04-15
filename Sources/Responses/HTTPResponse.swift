import Util

public struct HTTPResponse: Response {
  public var statusCode: String
  public var headers: [String: String]
  public var body: [UInt8]?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"
  public let bodyDivide: String = "\n\n"

  public init(status: StatusCode, headers: [String: String] = [:], body: BytesRepresentable? = nil) {
    self.statusCode = status.description
    self.headers = headers

    let divide = bodyDivide
    self.body = body.map { divide.toBytes + $0.toBytes }
  }

  public mutating func appendToBody(_ newContent: BytesRepresentable) {
    let formattedContent = "\n\n".toBytes + newContent.toBytes
    self.body = body.map { $0 + formattedContent } ?? formattedContent
  }

  public mutating func replaceBody(with newContent: BytesRepresentable) {
    self.body = "\n\n".toBytes + newContent.toBytes
  }

  public mutating func appendToHeaders(with newHeaders: [String: String]) {
    for (key, value) in newHeaders {
      headers[key] = value
    }
  }

  public mutating func updateStatus(with newStatus: StatusCode) {
    self.statusCode = newStatus.description
  }

}
