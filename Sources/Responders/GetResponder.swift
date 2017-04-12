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

    if data.fileNames().contains(request.pathName) {
      newResponse = handleResourceRequest(for: request)
    }

    if let cookieHeader = request.headers["cookie"] {
      newResponse.appendToBody("mmmm \(getCookieValue(from: cookieHeader))")
    }

    if route.setCookie {
      if let params = request.params {
        String(parameters: params).map { newResponse.appendToHeaders(with: ["Set-Cookie": $0]) }
        newResponse.appendToBody("Eat")
      }
      else {
        newResponse.updateStatus(with: FourHundred.BadRequest)
      }
    }

    if route.includeLogs {
      newResponse.appendToBody(logs.joined(separator: "\n"))
    }

    return newResponse
  }

  private func handleResourceRequest(for request: Request) -> HTTPResponse {
    let contentType = request.path.range(of: ".").map { extStart -> String in
      let ext = request.path.substring(from: extStart.upperBound)

      return isAnImage(ext) ? "image/\(ext)" : "text/plain"
    }

    return HTTPResponse(status: TwoHundred.Ok, headers: ["Content-Type": contentType ?? "text/html"], body: data.getBinary(request.pathName))
  }

  private func getCookieValue(from cookieHeader: String) -> String {
    let separatedCookie = cookieHeader.components(separatedBy: "=")
    return separatedCookie[separatedCookie.index(before: separatedCookie.endIndex)]
  }

}
