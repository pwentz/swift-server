import Foundation
import Responses
import Requests

public class RootController {
  static public func process(_ request: Request, contents: [String: String]) -> FormattedResponse {
    let fileLinks = contents.keys.map { file in
      "<a href=\"/\(file)\">\(file)</a>"
    }

    return FormattedResponse(status: 200,
                             headers: ["Content-Type": "text/html"],
                             body: fileLinks.joined(separator: "<br>"))
  }
}
