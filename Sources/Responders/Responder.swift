import Foundation
import Util
import Routes
import Requests
import Responses

public class Responder {
  let routes: [String: Route]
  let data: ControllerData
  var logs: [String] = []

  private let notFoundResponse = HTTPResponse(status: FourHundred.NotFound)
  private let unauthorizedResponse = HTTPResponse(status: FourHundred.Unauthorized, headers: ["WWW-Authenticate": "Basic realm=\"simple\""])
  private let methodNotAllowedResponse = HTTPResponse(status: FourHundred.MethodNotAllowed)

  public init(routes: [String: Route], data: ControllerData = ControllerData([:])) {
    self.routes = routes
    self.data = data
  }

  public func respond(to request: Request) -> Response {
    return responses(for: request).flatMap { $0 }.first!
  }

  public func responses(for request: Request) -> [Response?] {
    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    let route = routes[request.path]

    var responses = gatherImmediateResponses(request: request, route: route)
    route.map { responses.append(responseByVerb(request: request, route: $0)) }

    return responses
  }

  private func responseByVerb(request: Request, route: Route) -> Response {
    var response = HTTPResponse(status: TwoHundred.Ok)

    switch request.verb {
    case .Get:
      let responders = gatherGetResponders(request: request, route: route)
      responders.forEach { $0.execute(on: &response) }

    case .Options:
      let allowedMethods = route.allowedMethods.map { $0.rawValue.uppercased() }.joined(separator: ",")
      response.appendToHeaders(with: ["Allow": allowedMethods])

    case .Post, .Put:
      data.update(request.pathName, withVal: request.body ?? "")

    case .Patch:
      data.update(request.pathName, withVal: request.body ?? "")
      response.updateStatus(with: TwoHundred.NoContent)

    case .Delete:
      data.remove(at: request.pathName)

    default:
      break
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
      route.map { _ in nil } ?? notFoundResponse,
      route?.customResponse.map { $0 },
      route?.auth != givenAuth ? unauthorizedResponse : nil ,
      (route?.canRespondTo(request.verb)).flatMap { $0 ? nil : methodNotAllowedResponse },

      route?.redirectPath.map { redirectPath in
        routes[redirectPath].map { redirectRoute in

          redirectRoute.canRespondTo(request.verb) ?
            foundResponse(location: redirectPath) :
            methodNotAllowedResponse

        } ?? notFoundResponse
      }
    ]
  }

  private func foundResponse(location: String) -> Response {
    return HTTPResponse(status: ThreeHundred.Found, headers: ["Location": location])
  }

}
