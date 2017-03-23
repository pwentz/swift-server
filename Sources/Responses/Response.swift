public class Response {
  public let statusCode: String
  public let headers: [String: String]
  public var body: [UInt8]?

  public init(status: Int, headers: [String: String], body: [UInt8]?) {
    self.statusCode = statusCodes[status] ?? "404 Not Found"

    self.headers = headers
    self.body = body.map { Array("\n\n".utf8) + $0 }
  }

  public var formatted: [UInt8] {
    let formattedHeaders = Array(joinHeaders().utf8)
    let formattedStatus: [UInt8] = Array(statusLine().utf8)
    let formattedBody: [UInt8] = body ?? []

    return formattedStatus + formattedHeaders + formattedBody
  }

  public func toString() -> String {
    return statusLine() + joinHeaders()
  }

  private func joinHeaders() -> String {
    return headers.map { $0 + ":" + $1 }.joined(separator: "\r\n")
  }

  private func statusLine() -> String {
    return "HTTP/1.1 \(statusCode)\r\n"
  }
}
