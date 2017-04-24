import Foundation

extension String: BytesRepresentable {
  public var toBytes: [UInt8] {
    return Array(self.utf8)
  }

}

public extension String {
  var count: Int {
    return self.characters.count
  }

  var chars: [String] {
    return self.characters.map { String($0) }
  }

  init(response: HTTPResponse) {
    let statusLine = "\(response.transferProtocol) \(response.status.description + response.crlf)"

    self.init(statusLine + (response.joinedHeaders ?? "") + response.crlf)!
  }

  init?(responseBody: BytesRepresentable) {
    self.init(bytes: responseBody.toBytes, encoding: .utf8)
  }

}
