import Requests
import Responses
import Foundation

class PatchedContentController: Controller {
  static var patchedContent: String = ""
  let contents: [String: [UInt8]]

  public init(contents: [String: [UInt8]]) {
    self.contents = contents
  }

  static public func update(_ request: Request, contents: [String: [UInt8]]) {
    let pathName = request.path.substring(from: request.path.index(after: request.path.startIndex))
    let fileContents = contents[pathName]!

    if let body = request.body {
      patchedContent = body
    }
    else if patchedContent.isEmpty {
      patchedContent = String(data: Data(fileContents), encoding: .utf8)!
    }
  }

  public func process(_ request: Request) -> Response {
    PatchedContentController.update(request, contents: contents)

    if request.verb == "GET" {
      let updatedContent = Array(PatchedContentController.patchedContent.utf8)

      return Response(status: 200,
                      headers: [:],
                      body: updatedContent)
    }
    else {
      return Response(status: 204,
                      headers: [:],
                      body: nil)
    }

  }
}
