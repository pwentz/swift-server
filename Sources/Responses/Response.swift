import Foundation

public struct Response: HTTPResponse {
  public let statusCode: String
  public let headers: [String: String]
  public let body: [UInt8]?

  public init(status: Int, headers: [String: String], body: [UInt8]?) {
    self.statusCode = statusCodes[status] ?? "404 Not Found"

    self.headers = headers
    self.body = body.map { Array("\n\n".utf8) + $0 }
  }

}

public struct EmptyResponse: HTTPResponse {
  public let statusCode: String
  public let headers: [String: String] = [:]
  public let body: [UInt8]? = nil

  public init(status: Int) {
    self.statusCode = statusCodes[status]!
  }

}
