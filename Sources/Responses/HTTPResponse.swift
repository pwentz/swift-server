public class HTTPResponse: Response {
  public let statusCode: String
  public let headers: [String: String]
  public let body: [UInt8]?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"

  public required init(status: StatusCode, headers: [String: String], bodyBytes: [UInt8]?) {
    self.statusCode = status.description
    self.headers = headers
    self.body = bodyBytes.map { Array("\n\n".utf8) + $0 }
  }

  public required init(status: StatusCode, headers: [String: String] = [:], body: String? = nil) {
    self.statusCode = status.description
    self.headers = headers
    self.body = body.map { Array("\n\n\($0)".utf8) }
  }
}
