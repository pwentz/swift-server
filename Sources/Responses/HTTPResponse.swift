import Foundation

public struct HTTPResponse {
  public let status: HTTPStatusCode
  public let headers: [String: String]?
  public let body: BytesRepresentable?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"
  public let bodyDivide: String = "\n\n"

  public static func + (lhs: HTTPResponse, rhs: HTTPResponse) -> HTTPResponse {
    let newBody = lhs.updateBody(with: rhs.body)
    let newHeaders = lhs.updateHeaders(with: rhs.headers)

    return HTTPResponse(status: rhs.status, headers: newHeaders, body: newBody)
  }

  public init(status: HTTPStatusCode, headers: [String: String]? = nil, body: BytesRepresentable? = nil) {
    self.status = status
    self.headers = headers
    self.body = body
  }

  public var formatted: [UInt8] {
    let joinedHeaders = headers?.map { $0 + headerDivide + $1 }.joined(separator: crlf) ?? ""
    let statusLine = "\(transferProtocol) \(status.description + crlf)"
    let formattedBody = body.map { bodyDivide.plus($0) }?.toBytes ?? []

    return statusLine.toBytes + joinedHeaders.toBytes + formattedBody
  }

  private func updateBody(with newBody: BytesRepresentable?) -> BytesRepresentable? {
    return self.body.map { $0.plus(bodyDivide).plus(newBody) } ?? newBody
  }

  private func updateHeaders(with newHeaders: [String: String]?) -> [String: String]? {
    guard var existingHeaders = self.headers else {
      return newHeaders
    }

    newHeaders?.forEach { existingHeaders[$0] = $1 }

    return existingHeaders
  }

}
