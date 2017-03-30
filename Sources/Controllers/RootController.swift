import Responses
import Requests
import Util

public class RootController: Controller {
  let contents: ControllerData

  public init(contents: ControllerData) {
    self.contents = contents
  }

  public func process(_ request: Request) -> Response {
    let fileLinks = contents.fileNames().map { file in
      "<a href=\"/\(file)\">\(file)</a>"
    }.joined(separator: "<br>")

    return HTTPResponse(status: TwoHundred.Ok,
                        headers: ["Content-Type": "text/html"],
                        body: fileLinks)

  }

}
