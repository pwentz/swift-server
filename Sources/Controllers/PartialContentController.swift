import Foundation
import Responses
import Requests
import Util

public class PartialContentController: FileDataController {
  public static var contents: [String: [UInt8]] = [:]

  public static func setData(contents: [String: [UInt8]]) {
    self.contents = contents
  }

  public static func process(_ request: Request) -> HTTPResponse {
    let splitRange = request.headers["range"]!.components(separatedBy: "=")
    let stringRange = splitRange.last!

    let stringContents = String(data: Data(contents[request.pathName]!),
                                encoding: .utf8)!

    let chars: [String] = Array(stringContents.characters).map { String($0) }

    let range = getRange(of: stringRange, length: chars.count)

    let responseBody = chars[range].joined(separator: "")

    return Response(status: 206,
                    headers: ["Content-Type": "text/plain"],
                    body: Array(responseBody.utf8))
  }

}
