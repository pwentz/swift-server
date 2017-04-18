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
    let cookieBody = request.headers["cookie"].map { cookie in
      "\(prefix) \(getCookieValue(from: cookie))"
    }

    let cookieHeaders = request.params.flatMap { params -> [String: String]? in
      String(parameters: params).map { ["Set-Cookie": $0] }
    }

    return HTTPResponse(
      status: TwoHundred.Ok,
      headers: cookieHeaders.map { response.updateHeaders(with: $0) } ?? response.headers,
      body: formatBody(cookieBody).flatMap { response.updateBody(with: $0.toData) }
    )
  }

  private func getCookieValue(from cookieHeader: String) -> String {
    let separatedCookie = cookieHeader.components(separatedBy: "=")
    return separatedCookie[separatedCookie.index(before: separatedCookie.endIndex)]
  }

  private func formatBody(_ cookieBody: String?) -> String? {
    let prefixedBody = request.params.map { _ in prefix }

    return cookieBody.map {
      $0 + " " + (prefixedBody ?? "")
    }?.trimmingCharacters(in: .whitespaces) ?? prefixedBody
  }
}
