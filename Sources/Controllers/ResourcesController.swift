import Foundation
import Responses
import Requests
import Util

public class ResourcesController {
  static public func process(_ request: Request, contents: [String: String]) -> FormattedResponse {
    let pathName = request.path.substring(from: request.path.index(after: request.path.startIndex))

    let fileContents = contents[pathName] ?? ""
    let status = fileContents.isEmpty ? 404 : 200

    let formattedImage = request.path.range(of: ".").map { fileExtIndex -> String in
      let ext = request.path.substring(from: fileExtIndex.upperBound)

      return "<img src=\"data:image/\(ext);base64,\(fileContents)\"/>"
    }

    return FormattedResponse(status: status,
                             headers: ["Content-Type": "text/html"],
                             body: isAnImage(request.path) ? formattedImage ?? "Image extension not found."
                                                           : fileContents)

  }
}
