import Foundation
import Responses
import Requests
import Util

public class ResourcesController {
  static public func process(_ request: Request, contents: [String: String]) -> Response {
    let path = request.path
    let pathName = path.substring(from: path.index(after: path.startIndex))

    let fileContents = contents[pathName] ?? ""
    let status = fileContents.isEmpty ? 404 : 200

    let formattedImage = path.range(of: ".").map {
      "<img src=\"data:image/\(path.substring(from: $0.upperBound));base64,\(fileContents)\"/>"
    }

    return Response(status: status,
                    headers: ["Content-Type": "text/html"],
                    body: isAnImage(path) ? formattedImage ?? "Image extension not found."
                                          : fileContents)

  }
}
