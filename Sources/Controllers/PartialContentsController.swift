import Foundation
import Responses
import Requests
import Util

public class PartialContentsController: Controller {
  let content: String

  public init(content: String) {
    self.content = content
  }

  public func process(_ request: Request) -> Response {
    let splitRange = request.headers["range"]!.components(separatedBy: "=")

    let chars: [String] = Array(content.characters).map { String($0) }

    let range = getRange(of: splitRange.last!, length: content.characters.count)

    let finalContents = chars[range].joined(separator: "")

    return Response(status: 206,
                    headers: ["Content-Type": "text/plain"],
                    body: Array(finalContents.utf8))
  }
}
