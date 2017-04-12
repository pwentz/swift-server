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
    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    if let routeAuth = route.auth {
      return handleAuthRequest(for: request, routeAuth: routeAuth)
    }
    else if route.setCookie {
      return handleCookieRequest(for: request)
    }
    else if route.includeLogs {
      return HTTPResponse(status: TwoHundred.Ok, body: logs.joined(separator: "\n"))
    }
    else {
      return HTTPResponse(status: TwoHundred.Ok)
    }
  }

  private func handleCookieRequest(for request: Request) -> Response {
    if let params = request.params {
      var headers: [String: String] = [:]
      String(parameters: params).map { headers["Set-Cookie"] = $0 }
      return HTTPResponse(status: TwoHundred.Ok, headers: headers, body: "Eat")
    }
    else {
      return HTTPResponse(status: FourHundred.BadRequest)
    }
  }

  private func handleAuthRequest(for request: Request, routeAuth: String) -> Response {
    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last

    if givenAuth == routeAuth {
      return HTTPResponse(status: TwoHundred.Ok)
    }
    else {
      return HTTPResponse(status: FourHundred.Unauthorized)
    }
  }
}
