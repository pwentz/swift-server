import Util

public struct HTTPResponse: Response {
  public var statusCode: String
  public var headers: [String: String]
  public var body: [UInt8]? {
    didSet {
      if let contentType = self.headers["Content-Type"] {
        if isAnImage(contentType) {
          self.body = oldValue
        }
      }
    }
  }
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"
  public let bodyDivide: String = "\n\n"

  public init(status: StatusCode, headers: [String: String] = [:], body: BytesRepresentable? = nil) {
    self.statusCode = status.description
    self.headers = headers

    let divide = bodyDivide
    self.body = body.map { Array(divide.utf8) + $0.toBytes }
  }

  public mutating func appendToBody(_ newContent: String) {
    let formattedContent = "\n\n\(newContent)".toBytes
    self.body = body.map { $0 + formattedContent } ?? formattedContent
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
