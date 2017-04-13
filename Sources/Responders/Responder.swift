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
    guard let route = routes[request.path] else {
      return HTTPResponse(status: FourHundred.NotFound)
    }

    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last

    guard givenAuth == route.auth else {
      return HTTPResponse(status: FourHundred.Unauthorized)
    }

    guard route.allowedMethods.contains(request.verb) else {
      return HTTPResponse(status: FourHundred.MethodNotAllowed)
    }

    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    if request.verb == .Get {
      var response = HTTPResponse(status: TwoHundred.Ok)
      let responders = gatherGetResponders(request: request, route: route)

      GetResponder(responders: responders).execute(on: &response)

      return response
    }

    if request.verb == .Options {
      let allowedMethods = route.allowedMethods.map { $0.rawValue.uppercased() }.joined(separator: ",")
      return HTTPResponse(status: TwoHundred.Ok, headers: ["Allow": allowedMethods])
    }

    return HTTPResponse(status: TwoHundred.Ok)
  }

  private func gatherGetResponders(request: Request, route: Route) -> [RouteResponder] {
    var responders: [RouteResponder] = []

    responders.append(ContentResponder(for: request, data: data))

    if let cookiePrefix = route.cookiePrefix {
      responders.append(CookieResponder(for: request, prefix: cookiePrefix))
    }
    else {
      responders.append(ParamsResponder(for: request))
    }

    responders.append(LogsResponder(for: request, logs: route.includeLogs ? logs : nil))
    responders.append(DirectoryLinksResponder(for: request, files: route.includeDirectoryLinks ? data.fileNames() : nil))
    responders.append(PartialResponder(for: request))

    return responders
  }

}
