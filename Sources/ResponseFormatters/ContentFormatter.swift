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

  public func execute(on response: inout HTTPResponse) {
    guard let resource = data.getBinary(path) else {
      return
    }

    response.appendToHeaders(with: ["Content-Type": getContentType()])

    response.appendToBody(resource)
  }

  private func getContentType() -> String {
    return path.range(of: ".").map { extStart -> String in
      let ext = path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    } ?? "text/html"
  }
}
