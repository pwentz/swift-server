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

    let contentType = path
                       .range(of: ".")
                       .map(getContentType)

    let newResponse = HTTPResponse(
      status: response.status,
      headers: [
        "Content-Type": contentType ?? "text/html"
      ],
      body: resource
    )

    return response + newResponse
  }

  private func getContentType(_ extStart: Range<String.Index>) -> String {
    let ext = path.substring(from: extStart.upperBound)

    return isAnImage(ext) ?
            "image/\(ext)" :
            "text/plain"
  }

}
