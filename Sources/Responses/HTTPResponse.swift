import Foundation
import Util

public struct HTTPResponse {
  public let status: HTTPStatusCode
  public let headers: [String: String]?
  public let body: BytesRepresentable?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"

  public var joinedHeaders: String? {
    return headers?.reduce("") { $0 + ($1.0 + headerDivide + $1.1) + crlf }
  }

  public static func + (lhs: HTTPResponse, rhs: HTTPResponse) -> HTTPResponse {
    let newBody = lhs.mergeBody(with: rhs.body)
    let newHeaders = lhs.mergeHeaders(with: rhs.headers)

    return HTTPResponse(status: rhs.status, headers: newHeaders, body: newBody)
  }

  public init(status: HTTPStatusCode, headers: [String: String]? = nil, body: BytesRepresentable? = nil) {
    self.status = status
    self.headers = headers
    self.body = body
  }

  public func format(dateHelper: DateHelper) -> [UInt8] {
    let dateHeader = "Date: \(dateHelper.rfcTimestamp + crlf)"
    let statusLine = "\(transferProtocol) \(status.description + crlf)"

    return (
      statusLine +
      joinedHeaders +
      dateHeader +
      crlf +
      body
    ).toBytes
  }

  private func mergeBody(with newBody: BytesRepresentable?) -> BytesRepresentable? {
    return self.body.map { $0 + "\n\n" + newBody } ?? newBody
  }

  private func mergeHeaders(with newHeaders: [String: String]?) -> [String: String]? {
    guard var existingHeaders = self.headers else {
      return newHeaders
    }

    newHeaders?.forEach { existingHeaders[$0] = $1 }

    return existingHeaders
  }

}
