import Foundation

public struct HTTPResponse {
  public let statusCode: String
  public let headers: [String: String]?
  public let body: BytesRepresentable?
  public let crlf: String = "\r\n"
  public let headerDivide: String = ":"
  public let transferProtocol: String = "HTTP/1.1"
  public let bodyDivide: String = "\n\n"

  public init(status: HTTPStatusCode, headers: [String: String]? = nil, body: BytesRepresentable? = nil) {
    self.statusCode = status.description
    self.headers = headers
    self.body = body
  }

  public func updateBody(with newBody: BytesRepresentable) -> BytesRepresentable? {
    return self.body.map { b -> BytesRepresentable in
      // return Data(bytes: b.toBytes + bodyDivide.toBytes + newBody.toBytes)
      return b.plus(bodyDivide).plus(newBody)
    } ?? newBody
  }

  public func updateHeaders(with newHeaders: [String: String]) -> [String: String]? {
    guard var existingHeaders = self.headers else {
      return newHeaders
    }

    newHeaders.forEach { existingHeaders[$0] = $1 }

    return existingHeaders
  }

  public var formatted: [UInt8] {
    let joinedHeaders = headers?.map { $0 + headerDivide + $1 }.joined(separator: crlf) ?? ""
    let statusLine = "\(transferProtocol) \(statusCode + crlf)"
    let formattedBody = body.map { bodyDivide.plus($0) }?.toBytes ?? []
    // let formattedBody = body.map { bodyDivide.toBytes + $0.toBytes } ?? []

    return statusLine.toBytes + joinedHeaders.toBytes + formattedBody
  }
}
