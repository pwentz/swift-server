public protocol Response {
  var statusCode: String { get }
  var headers: [String: String] { get }
  var body: [UInt8]? { get }
  var formatted: [UInt8] { get }
  var crlf: String { get }
  var headerDivide: String { get }
  var bodyDivide: String { get }
  var transferProtocol: String { get }

  init(status: StatusCode, headers: [String: String], body: BytesRepresentable?)

  mutating func appendToBody(_ newContent: BytesRepresentable)
  mutating func replaceBody(with newContent: BytesRepresentable)
  mutating func appendToHeaders(with newHeaders: [String: String])
  mutating func updateStatus(with newStatus: StatusCode)
}


extension Response {

  public var formatted: [UInt8] {
    let joinedHeaders = headers.map { $0 + headerDivide + $1 }.joined(separator: crlf)
    let statusLine = "\(transferProtocol) \(statusCode + crlf)"
    let formattedBody = body ?? []

    return Array(statusLine.utf8) + Array(joinedHeaders.utf8) + formattedBody
  }

}
