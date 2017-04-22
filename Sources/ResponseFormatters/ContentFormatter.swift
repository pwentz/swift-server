import Foundation
import Responses
import Requests
import Util

public class ContentFormatter: ResponseFormatter {
  let path: String
  let data: ResourceData

  public init(for path: String, data: ResourceData) {
    self.path = path
    self.data = data
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    guard let resource = data[path] else {
      return response
    }

    let newHeaders = [
      "Content-Type": path.range(of: ".").map(contentType) ?? "text/html"
    ]

    let newResponse = HTTPResponse(
      status: response.status,
      headers: newHeaders,
      body: resource
    )

    return response + newResponse
  }

  private func contentType(_ extStart: Range<String.Index>) -> String {
    let ext = path.substring(from: extStart.upperBound)

    return isAnImage(ext) ? "image/\(ext)" : "text/plain"
  }

}
