import Foundation

public protocol Response {
  var statusCode: String { get }
  var headers: [String: String] { get }
  var body: [UInt8]? { get }
  var formatted: [UInt8] { get }

  init(status: StatusCode, headers: [String: String], body: String?)

  init(status: StatusCode, headers: [String: String], bodyBytes: [UInt8]?)

  func toString() -> String
}

extension Response {
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
