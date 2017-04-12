import Foundation
import Routes
import Requests
import Responses

class Responder {
  let routes: [String: Route]

  public init(routes: [String: Route]) {
    self.routes = routes
  }

  public func respond(to request: Request) -> Response {
    let route = routes[request.path]!

    if let routeAuth = route.auth {
      return handleAuthRequest(for: request, routeAuth: routeAuth)
    }
    else {
      return HTTPResponse(status: TwoHundred.Ok)
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
