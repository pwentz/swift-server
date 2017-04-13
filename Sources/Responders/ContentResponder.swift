import Responses
import Requests
import Util

class ContentResponder {
  let request: Request
  let data: ControllerData

  public init(for request: Request, data: ControllerData) {
    self.request = request
    self.data = data
  }

  public func execute(on response: inout HTTPResponse) {
    response.appendToHeaders(with: ["Content-Type": getContentType(for: request)])

    data.getBinary(request.pathName).map { response.appendToBody($0) }
  }

  private func getContentType(for request: Request) -> String {
    return request.path.range(of: ".").map { extStart -> String in
      let ext = request.path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    } ?? "text/html"
  }
}
