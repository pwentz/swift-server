public class Response {
  public let statusCode: String
  public let headers: [String: String]
  public let body: [UInt8]?

  public init(status: Int, headers: [String: String], body: [UInt8]?) {
    self.statusCode = statusCodes[status] ?? "404 Not Found"

    self.headers = headers
    self.body = body.map { Array("\n\n".utf8) + $0 }
  }

  public var formatted: [UInt8] {
    let joinedHeaders = headers.map { $0 + ":" + $1 }.joined(separator: "\r\n")
    let statusLine = "HTTP/1.1 \(statusCode)\r\n"
    let formattedHeaders = Array(joinedHeaders.utf8)
    let formattedStatus = Array(statusLine.utf8)
    let formattedBody = body ?? []

    return formattedStatus + formattedHeaders + formattedBody
  }

  public func toString() -> String {
    let joinedHeaders = headers.map { $0 + ":" + $1 }.joined(separator: "\r\n")
    let statusLine = "HTTP/1.1 \(statusCode)\r\n"
    return statusLine + joinedHeaders
  }

}
