import Foundation
import Util
import Routes
import Requests
import Responses

class GetResponder {
  let route: Route
  let data: ControllerData

  public init(route: Route, data: ControllerData) {
    self.route = route
    self.data = data
  }

  public func respond(to request: Request, logs: [String]) -> Response {
    var newResponse = HTTPResponse(status: TwoHundred.Ok)

    if let fileData = data.getBinary(request.pathName) {
      let contentType = getFileContentType(for: request)
      newResponse.appendToHeaders(with: ["Content-Type": contentType])
      newResponse.appendToBody(fileData)
    }

    if let cookieHeader = request.headers["cookie"] {
      newResponse.appendToBody("mmmm \(getCookieValue(from: cookieHeader))")
    }

    if let params = request.params {
      if route.setCookie {
        String(parameters: params).map { newResponse.appendToHeaders(with: ["Set-Cookie": $0]) }
        newResponse.appendToBody("Eat")
      }
    }

    if route.includeLogs {
      if !isAnImage(request.pathName) {
        newResponse.appendToBody(logs.joined(separator: "\n"))
      }
    }

    if let rangeHeader = request.headers["range"] {
      let partialContent = newResponse.body.flatMap {
        String(data: Data(bytes: $0), encoding: .utf8)?.trimmingCharacters(in: .newlines)
      }.map { currentBody -> String in
        let splitRange = rangeHeader.components(separatedBy: "=")
        let rawRange = splitRange[splitRange.index(before: splitRange.endIndex)]

        let chars = Array(currentBody.characters).map { String($0) }

        let range = getRange(of: rawRange, length: currentBody.characters.count)

        return chars[range].joined(separator: "")
      }

      newResponse.updateStatus(with: TwoHundred.PartialContent)
      newResponse.replaceBody(with: partialContent ?? "")
    }

    if route.includeDirectoryLinks {
      let fileLinks = data.fileNames().map { file in
        "<a href=\"/\(file)\">\(file)</a>"
      }.joined(separator: "<br>")

      newResponse.appendToBody(fileLinks)
    }

    return newResponse
  }

  private func getFileContentType(for request: Request) -> String {
    return request.path.range(of: ".").map { extStart -> String in
      let ext = request.path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    } ?? "text/html"
  }

  private func getCookieValue(from cookieHeader: String) -> String {
    let separatedCookie = cookieHeader.components(separatedBy: "=")
    return separatedCookie[separatedCookie.index(before: separatedCookie.endIndex)]
  }

}
