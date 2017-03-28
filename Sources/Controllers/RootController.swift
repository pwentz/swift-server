import Responses
import Requests
import Util

public class RootController: FileDataController {
  public static var contents: [String: [UInt8]] = [:]

  public static func setData(contents: [String: [UInt8]]) {
    self.contents = contents
  }

  public static func process(_ request: Request) -> HTTPResponse {
    let fileLinks = contents.keys.map { file in
      "<a href=\"/\(file)\">\(file)</a>"
    }.joined(separator: "<br>")

    return Response(status: 200,
                    headers: ["Content-Type": "text/html"],
                    body: Array(fileLinks.utf8))

  }

}
