import Foundation
import Responses
import Requests
import Util

public class ResourcesController: FileDataController, PersistentDataController {
  public static var contents: [String: [UInt8]] = [:]

  public static func setData(contents: [String: [UInt8]]) {
    if self.contents.isEmpty {
      self.contents = contents
    }
  }

  public static func update(_ request: Request) {
    if let body = request.body {
      let formattedContent = Array(body.utf8)
      contents.updateValue(formattedContent, forKey: request.pathName)
    }
  }

  public static func process(_ request: Request) -> HTTPResponse {
    guard request.verb != "PATCH" else {
      update(request)
      return EmptyResponse(status: 204)
    }

    guard request.headers["range"] == nil else {
      PartialContentController.setData(contents: contents)
      return PartialContentController.process(request)
    }

    guard request.verb == "GET" else {
      return EmptyResponse(status: 405)
    }

    let status = contents[request.pathName].map { _ in 200 }

    let contentType = request.path.range(of: ".").map { extStart -> String in
      let ext = request.path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    }

    return Response(status: status ?? 404,
                    headers: [
                      "Content-Type": contentType ?? "text/html"
                    ],
                    body: contents[request.pathName])
  }

}
