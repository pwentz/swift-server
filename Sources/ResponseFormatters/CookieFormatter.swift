import Foundation
import Responses
import Requests

public class CookieFormatter: ResponseFormatter {
  let prefix: String
  let request: HTTPRequest

  public init(for request: HTTPRequest, prefix: String) {
    self.request = request
    self.prefix = prefix
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    let cookieBody = request
                       .headers["cookie"]
                       .map(toPrefixedCookie)

    let cookieHeaders = request
                         .params
                         .flatMap(String.init)
                         .map { ["Set-Cookie": $0] }

    let prefixedBody = request.params != nil ? prefix : nil

    let newResponse = HTTPResponse(
      status: response.status,
      headers: cookieHeaders,
      body: cookieBody ?? prefixedBody
    )

    return response + newResponse
  }

  private func toPrefixedCookie(_ cookie: String) -> String {
    let cookieVal = cookie.components(separatedBy: "=").last
    return "\(prefix) \(cookieVal ?? "")"
  }

}
