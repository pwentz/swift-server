import Foundation
import Util
import Routes
import Requests
import Responses

public class Responder {
  let routes: [String: Route]
  let data: ControllerData
  var logs: [String] = []

  public init(routes: [String: Route], data: ControllerData = ControllerData([:])) {
    self.routes = routes
    self.data = data
  }

  public func respond(to request: Request) -> Response {
    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    for response in gatherImmediateResponses(request: request, route: routes[request.path]) {
      if let confirmedResponse = response {
        return confirmedResponse
      }
    }

    let route: Route! = routes[request.path]

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
      responders.forEach { $0.execute(on: &response) }
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

  private func gatherImmediateResponses(request: Request, route: Route?) -> [Response?] {
    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last
    return [
      route.map { _ in nil } ?? HTTPResponse(status: FourHundred.NotFound),
      route.flatMap { $0.customResponse.map { $0 } },
      route.flatMap { $0.auth != givenAuth ?
        HTTPResponse(status: FourHundred.Unauthorized, headers: ["WWW-Authenticate": "Basic realm=\"simple\""])
        : nil
      },
      route.flatMap { $0.allowedMethods.contains(request.verb) ? nil : HTTPResponse(status: FourHundred.MethodNotAllowed) }
    ]
  }

}
