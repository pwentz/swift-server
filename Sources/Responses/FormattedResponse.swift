public class FormattedResponse {
  public let statusCode: String
  public let headers: [String: String]
  public var body: String

  public init(status: Int, headers: [String: String], body: String) {
    self.statusCode = statusCodes[status] ?? "404 Not Found"


    self.headers = headers
    self.body = "\n\n" + body
  }

  public var formatted: [UInt8] {
    let conjoinedHeaders = headers.map { $0 + ":" + $1 }
    let formattedHeaders = Array(conjoinedHeaders.joined(separator: "\r\n").utf8)
    let formattedStatus: [UInt8] = Array("HTTP/1.1 \(statusCode)\r\n".utf8)
    let formattedBody = Array(body.utf8)

    return formattedStatus + formattedHeaders + formattedBody
  }
}
