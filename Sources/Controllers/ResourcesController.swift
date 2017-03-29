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
    guard request.verb != "PATCH" else {
      contents.update(request.pathName, withVal: request.body ?? "")

      return Response(status: 204, headers: [:], body: nil)
    }

    guard request.headers["range"] == nil else {
      return PartialContentsController(
        content: contents.get(request.pathName)
      ).process(request)
    }

    guard request.verb == "GET" else {
      return Response(status: 405, headers: [:], body: nil)
    }

    let contentType = request.path.range(of: ".").map { extStart -> String in
      let ext = request.path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    }

    return Response(status: 200,
                    headers: [
                      "Content-Type": contentType ?? "text/html"
                    ],
                    body: contents.getBinary(request.pathName))
  }


}
