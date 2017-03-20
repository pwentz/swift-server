import Foundation
import Responses
import Requests
import Util

public class RootController: Controller {
  let contents: [String: String]

  public init(contents: [String: String]) {
    self.contents = contents
  }

  public func process(_ request: Request) -> Response {
    let fileLinks = contents.keys.map { file in
      "<a href=\"/\(file)\">\(file)</a>"
    }

    return Response(status: 200,
                    headers: ["Content-Type": "text/html"],
                    body: fileLinks.joined(separator: "<br>"))

  }
}
