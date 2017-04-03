public struct HTTPResponse: Response {
  public let statusCode: String
  public let headers: [String: String]
  public let body: [UInt8]?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"
  public let bodyDivide: String = "\n\n"

  public init(status: StatusCode, headers: [String: String], bodyBytes: [UInt8]?) {
    self.statusCode = status.description
    self.headers = headers

    let divide = bodyDivide
    self.body = bodyBytes.map { Array(divide.utf8) + $0 }
  }

  public init(status: StatusCode, headers: [String: String] = [:], body: String? = nil) {
    self.statusCode = status.description
    self.headers = headers

    let divide = bodyDivide
    self.body = body.map { Array((divide + $0).utf8) }
  }

}
