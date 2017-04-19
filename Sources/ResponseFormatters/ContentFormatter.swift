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

    let newHeaders = ["Content-Type": getContentType()]

    return HTTPResponse(
      status: TwoHundred.Ok,
      headers: response.updateHeaders(with: newHeaders),
      body: response.updateBody(with: resource)
    )
  }

  private func getContentType() -> String {
    return path.range(of: ".").map { extStart -> String in
      let ext = path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    } ?? "text/html"
  }

}
