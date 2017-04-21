import Foundation

extension String: BytesRepresentable {
  public var toBytes: [UInt8] {
    return Array(self.utf8)
  }
}

public extension String {
  var toData: Data {
    return self.toBytes.toData
  }

  init(response: HTTPResponse) {
    let joinedHeaders = response.headers?
                                .map { $0 + response.headerDivide + $1 }
                                .joined(separator: response.crlf) ?? ""

    let statusLine = "\(response.transferProtocol) \(response.statusCode + response.crlf)"

    self.init(statusLine + joinedHeaders)!
  }

}
