public class Response {
  public let statusCode: String
  public let headers: [UInt8]
  public let body: [UInt8]

  public init(status: Int, headers: [String: String], body: String) {
    self.statusCode = statusCodes[status] ?? "404 Not Found"

    let conjoinedHeaders = headers.map { $0 + ":" + $1 }

    self.headers = Array(conjoinedHeaders.joined(separator: "\r\n").utf8)
    self.body = Array(( "\n\n" + body ).utf8)
  }

  public var formatted: [UInt8] {
    let formattedStatus: [UInt8] = Array("HTTP/1.1 \(statusCode)\r\n".utf8)

    return formattedStatus + headers + body
  }
}
