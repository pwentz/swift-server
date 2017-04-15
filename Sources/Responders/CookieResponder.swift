import Foundation
import Responses
import Requests

class CookieResponder: ResponseFormatter {
  let prefix: String
  let request: Request

  public init(for request: Request, prefix: String) {
    self.request = request
    self.prefix = prefix
  }

  public func execute(on response: inout HTTPResponse) {
    request.headers["cookie"].map { response.appendToBody("\(prefix) \(getCookieValue(from: $0))") }

    request.params.map { params in
      String(parameters: params).map { response.appendToHeaders(with: ["Set-Cookie": $0]) }
      response.appendToBody(prefix)
    }
  }

  private func getCookieValue(from cookieHeader: String) -> String {
    let separatedCookie = cookieHeader.components(separatedBy: "=")
    return separatedCookie[separatedCookie.index(before: separatedCookie.endIndex)]
  }
}
