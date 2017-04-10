import Foundation
import Responses
import Requests
import Util

public class ResourcesController: Controller {
  let contents: ControllerData

  public init(contents: ControllerData) {
    self.contents = contents
  }

  public func process(_ request: Request) -> Response {
    guard request.verb != .Patch else {
      contents.update(request.pathName, withVal: request.body ?? "")

      return HTTPResponse(status: TwoHundred.NoContent)
    }

    guard request.verb == .Get else {
      return HTTPResponse(status: FourHundred.MethodNotAllowed)
    }

    if let rangeHeader = request.headers["range"] {
      return PartialContentsController(
        content: contents.get(request.pathName) ?? "",
        range: rangeHeader
      ).process(request)
    }

    let contentType = request.path.range(of: ".").map { extStart -> String in
      let ext = request.path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    }

    return HTTPResponse(status: TwoHundred.Ok,
                        headers: [
                          "Content-Type": contentType ?? "text/html"
                        ],
                        body: contents.getBinary(request.pathName))
  }


}
