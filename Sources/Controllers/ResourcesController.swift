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
      let splitRange = request.headers["range"]!.components(separatedBy: "=")
      let rawRange = splitRange.last!

      let stringContents = String(data: Data(contents[pathName]!),
                                  encoding: .utf8)!

      let chars: [String] = Array(stringContents.characters).map { String($0) }

      let range = getRange(of: rawRange, for: stringContents)

      let finalContents = chars[range].joined(separator: "")


      let body: [UInt8] = Array(finalContents.utf8)

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

  public func getRange(of rawRange: String, for fileContents: String) -> Range<Int> {
    let splitRange = rawRange.components(separatedBy: "-")

    let rangeEnd = Int(splitRange.last!) ?? fileContents.characters.count - 1

    let rangeStart = Int(splitRange.first!) ?? fileContents.characters.count - rangeEnd

    return rangeEnd < rangeStart ? rangeStart..<fileContents.characters.count
                                 : rangeStart..<rangeEnd + 1
  }

}
