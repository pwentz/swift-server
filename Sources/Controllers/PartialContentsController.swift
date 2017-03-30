import Foundation
import Responses
import Requests
import Util

public class PartialContentsController: Controller {
  let content: String
  let rangeHeader: String

  public init(content: String, range: String) {
    self.content = content
    self.rangeHeader = range
  }

  public func process(_ request: Request) -> Response {
    let splitRange = rangeHeader.components(separatedBy: "=")
    let rawRange = splitRange[splitRange.index(before: splitRange.endIndex)]

    let chars = Array(content.characters).map { String($0) }

    let range = getRange(of: rawRange, length: content.characters.count)

    let partialContents = chars[range].joined(separator: "")

    return HTTPResponse(status: TwoHundred.PartialContent,
                        headers: ["Content-Type": "text/plain"],
                        body: partialContents)
  }

}
