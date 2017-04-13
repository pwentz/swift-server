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

    newResponse.appendToHeaders(with: ["Content-Type": getContentType(for: request)])

    data.getBinary(request.pathName).map { newResponse.appendToBody($0) }

    request.headers["cookie"].map { cookieHeader in
      route.cookiePrefix.map { newResponse.appendToBody("\($0) \(getCookieValue(from: cookieHeader))") }
    }

    request.params.map { params in
      String(parameters: params).map { newResponse.appendToHeaders(with: ["Set-Cookie": $0]) }
      route.cookiePrefix.map { newResponse.appendToBody($0) }
    }

    if route.includeLogs {
      if !isAnImage(request.pathName) {
        newResponse.appendToBody(logs.joined(separator: "\n"))
      }
    }

    if route.includeDirectoryLinks {
      let fileLinks = data.fileNames().map { file in
        "<a href=\"/\(file)\">\(file)</a>"
      }.joined(separator: "<br>")

      newResponse.appendToBody(fileLinks)
    }

    PartialResponder(for: request).execute(on: &newResponse)


    return newResponse
  }

  private func getContentType(for request: Request) -> String {
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
