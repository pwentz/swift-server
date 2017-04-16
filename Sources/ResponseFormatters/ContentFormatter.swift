import Responses
import Requests
import Util

public class ContentFormatter: ResponseFormatter {
  let request: HTTPRequest
  let data: ControllerData

  public init(for request: HTTPRequest, data: ControllerData) {
    self.request = request
    self.data = data
  }

  public func execute(on response: inout HTTPResponse) {
    data.getBinary(request.path).map { resource in
      response.appendToHeaders(with: ["Content-Type": getContentType(for: request)])

      response.appendToBody(resource)
    }
  }

  private func getContentType(for request: HTTPRequest) -> String {
    return request.path.range(of: ".").map { extStart -> String in
      let ext = request.path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    } ?? "text/html"
  }
}
