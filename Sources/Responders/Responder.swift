import Foundation
import Util
import Routes
import Requests
import Responses

class Responder {
  let routes: [String: Route]
  let data: ControllerData
  var logs: [String] = []

  public init(routes: [String: Route], data: ControllerData = ControllerData([:])) {
    self.routes = routes
    self.data = data
  }

  public func respond(to request: Request) -> Response {
    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    guard let route = routes[request.path] else {
      return HTTPResponse(status: FourHundred.NotFound)
    }

    if let customResponse = route.customResponse {
      return customResponse
    }

    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last

    guard givenAuth == route.auth else {
      return HTTPResponse(status: FourHundred.Unauthorized)
    }

    guard route.allowedMethods.contains(request.verb) else {
      return HTTPResponse(status: FourHundred.MethodNotAllowed)
    }

    if let redirectPath = route.redirectPath {
      if let redirectRoute = routes[redirectPath] {
        if redirectRoute.allowedMethods.contains(request.verb) {
          return HTTPResponse(status: ThreeHundred.Found, headers: ["Location": redirectPath])
        }
        else {
          return HTTPResponse(status: FourHundred.MethodNotAllowed)
        }
      }
      else {
        return HTTPResponse(status: FourHundred.NotFound)
      }
    }

    var response = HTTPResponse(status: TwoHundred.Ok)

    if request.verb == .Get {
      let responders = gatherGetResponders(request: request, route: route)
      GetResponder(responders: responders).execute(on: &response)
    }
    else {
      NonGetResponder(for: request, route: route, data: data).execute(on: &response)
    }

    return response
  }

  private func gatherGetResponders(request: Request, route: Route) -> [RouteResponder] {
    return [
      ContentResponder(for: request, data: data),
      route.cookiePrefix.map { CookieResponder(for: request, prefix: $0) } ?? ParamsResponder(for: request),
      LogsResponder(for: request, logs: route.includeLogs ? logs : nil),
      DirectoryLinksResponder(for: request, files: route.includeDirectoryLinks ? data.fileNames : nil),
      PartialResponder(for: request)
    ]
  }

}
