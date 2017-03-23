import Foundation
import Responses
import Requests
import Util

public class RootController: Controller {
  let contents: [String: [UInt8]]

  public init(contents: [String: [UInt8]]) {
    self.contents = contents
  }

  public func process(_ request: Request) -> Response {
    let fileLinks = contents.keys.map { file in
      "<a href=\"/\(file)\">\(file)</a>"
    }.joined(separator: "<br>")

    let formattedBody: [UInt8]? = Array(fileLinks.utf8)

    return Response(status: 200,
                    headers: ["Content-Type": "text/html"],
                    body: formattedBody)

  }

}
