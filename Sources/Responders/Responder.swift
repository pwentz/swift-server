import Foundation
import Util
import Routes
import Requests
import Responses

class Responder {
  let routes: [String: Route]
  let data: ControllerData
  var logs: [String] = []

  public init(routes: [String: Route], data: ControllerData) {
    self.routes = routes
    self.data = data
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

    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    if request.verb == .Get {
      return GetResponder(route: route, data: data).respond(to: request, logs: logs)
    }

    if request.verb == .Options {
      let allowedMethods = route.allowedMethods.map { $0.rawValue.uppercased() }.joined(separator: ",")
      return HTTPResponse(status: TwoHundred.Ok, headers: ["Allow": allowedMethods])
    }

    return HTTPResponse(status: TwoHundred.Ok)
  }

}
