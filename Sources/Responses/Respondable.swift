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

