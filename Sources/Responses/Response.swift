import Foundation

public protocol Response {
  var statusCode: String { get }
  var headers: [String: String] { get }
  var body: [UInt8]? { get }
  var formatted: [UInt8] { get }
  var crlf: String { get }
  var headerDivide: String { get }

  init(status: StatusCode, headers: [String: String], body: String?)

  init(status: StatusCode, headers: [String: String], bodyBytes: [UInt8]?)
}

public protocol Respondable {
  init(response: Response)
}

extension String: Respondable {

  public init(response: Response) {
    let joinedHeaders = response.headers
                                .map { $0 + response.headerDivide + $1 }
                                .joined(separator: response.crlf)

    let statusLine = "HTTP/1.1 \(response.statusCode + response.crlf)"

    self.init(statusLine + joinedHeaders)!
  }

}

extension Response {

  public var formatted: [UInt8] {
    let joinedHeaders = headers.map { $0 + headerDivide + $1 }.joined(separator: crlf)
    let statusLine = "HTTP/1.1 \(statusCode + crlf)"
    let formattedBody = body ?? []

    return Array(statusLine.utf8) + Array(joinedHeaders.utf8) + formattedBody
  }

}
