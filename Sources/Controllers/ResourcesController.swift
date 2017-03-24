import Foundation
import Responses
import Requests
import Util

public class ResourcesController: Controller {
  let contents: [String: [UInt8]]

  public init(contents: [String: [UInt8]]) {
    self.contents = contents
  }

  public func process(_ request: Request) -> Response {
    guard request.verb == "GET" else {
      return Response(status: 405,
                      headers: [:],
                      body: nil)
    }

    let path = request.path
    let pathName = path.substring(from: path.index(after: path.startIndex))

    let status = contents[pathName].map { _ in 200 }

    let contentType = path.range(of: ".").map { extStart -> String in
      let ext = path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    }

    return Response(status: status ?? 404,
                    headers: [
                      "Content-Type": contentType ?? "text/html"
                    ],
                    body: contents[pathName])
  }

}
