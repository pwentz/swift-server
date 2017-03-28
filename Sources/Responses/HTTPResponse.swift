public protocol HTTPResponse {
  var statusCode: String { get }
  var headers: [String: String] { get }
  var body: [UInt8]? { get }

  var formatted: [UInt8] { get }
}

extension HTTPResponse {
  public var formatted: [UInt8] {
    let joinedHeaders = headers.map { $0 + ":" + $1 }.joined(separator: "\r\n")
    let statusLine = "HTTP/1.1 \(statusCode)\r\n"
    let formattedBody = body ?? []

    return Array(statusLine.utf8) + Array(joinedHeaders.utf8) + formattedBody
  }

  public func toString() -> String {
    let joinedHeaders = headers.map { $0 + ":" + $1 }.joined(separator: "\r\n")
    let statusLine = "HTTP/1.1 \(statusCode)\r\n"
    return statusLine + joinedHeaders
  }

}
