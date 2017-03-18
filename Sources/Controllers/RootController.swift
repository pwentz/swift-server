import Foundation
import Responses
import Requests

public class RootController {
  static public func process(_ request: Request, contents: [String: String]) -> Response {
    let fileLinks = contents.keys.map { file in
      "<a href=\"/\(file)\">\(file)</a>"
    }

    return Response(status: 200,
                    headers: ["Content-Type": "text/html"],
                    body: fileLinks.joined(separator: "<br>"))
  }
}
