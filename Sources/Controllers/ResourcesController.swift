import Foundation
import Responses
import Requests
import Util

public class ResourcesController: Controller {
  let contents: [String: [UInt8]]

  public init(contents: [String: [UInt8]]) {
    self.contents = contents
  }

  public func process(_ request: Request) -> Response {
    let path = request.path
    let pathName = path.substring(from: path.index(after: path.startIndex))

    guard request.verb == "GET" else {
      return Response(status: 405,
                      headers: [:],
                      body: nil)
    }

    guard path != "/partial_content.txt" else {
      let rangeHeader = request.headers["range"]!
      let rawRange = rangeHeader.components(separatedBy: "=").last!
      let rangeStart = Int(rawRange.components(separatedBy: "-").first!) ?? 0

      let stringContents = String(data: Data(contents[pathName]!),
                                  encoding: .utf8)!

      let partialContents = stringContents.substring(from: stringContents.index(stringContents.startIndex,
                                                                                offsetBy: rangeStart))

      let body: [UInt8] = Array(partialContents.utf8)

      return Response(status: 206,
                      headers: ["Content-Type": "text/plain"],
                      body: body)
    }

    let status = contents[pathName].map { _ in 200 }

    let contentType = path.range(of: ".").map { extStart -> String in
      let ext = path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    }

    return Response(status: status ?? 404,
                    headers: [
                      "Content-Type": contentType ?? "text/html"
                    ],
                    body: contents[pathName])
  }

}
