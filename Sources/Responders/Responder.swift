import Foundation
import Routes
import Requests
import Responses

class Responder {
  let routes: [String: Route]
  var logs: [String] = []

  public init(routes: [String: Route]) {
    self.routes = routes
  }

  public func respond(to request: Request) -> Response {
    let route = routes[request.path]!
    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last

    guard givenAuth == route.auth else {
      return HTTPResponse(status: FourHundred.Unauthorized)
    }

    guard route.allowedMethods.contains(request.verb) else {
      return HTTPResponse(status: FourHundred.MethodNotAllowed)
    }

    var newResponse = HTTPResponse(status: TwoHundred.Ok)

    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    if let cookieHeader = request.headers["cookie"] {
      newResponse.appendToBody("mmmm \(getCookieValue(from: cookieHeader))")
    }

    if route.setCookie {
      newResponse = handleCookieRequest(for: request, newResponse) as! HTTPResponse
    }

    if route.includeLogs {
      newResponse.appendToBody(logs.joined(separator: "\n"))
    }

    if request.verb == .Options {
      let allowedMethods = route.allowedMethods.map { $0.rawValue.uppercased() }.joined(separator: ",")
      newResponse.appendToHeaders(with: ["Allow": allowedMethods])
    }

    return newResponse
  }

  private func getCookieValue(from cookieHeader: String) -> String {
    let separatedCookie = cookieHeader.components(separatedBy: "=")
    return separatedCookie[separatedCookie.index(before: separatedCookie.endIndex)]
  }

  private func handleCookieRequest(for request: Request, _ response: Response) -> Response {
    return CookieResponder(for: request).formatResponse(response)
  }

}
