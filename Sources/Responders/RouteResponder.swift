import Foundation
import Util
import Routes
import Requests
import Responses

public class RouteResponder: Responder {
  let routes: [String: Route]
  let data: ControllerData
  var logs: [String] = []

  private let notFoundResponse = HTTPResponse(status: FourHundred.NotFound)
  private let unauthorizedResponse = HTTPResponse(
    status: FourHundred.Unauthorized,
    headers: ["WWW-Authenticate": "Basic realm=\"simple\""]
  )

  private let methodNotAllowedResponse = HTTPResponse(status: FourHundred.MethodNotAllowed)

  public init(routes: [String: Route], data: ControllerData = ControllerData([:])) {
    self.routes = routes
    self.data = data
  }

  public func getResponse(to request: Request) -> Response {
    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    let validResponses = responses(for: request).flatMap { $0 }

    return validResponses[validResponses.startIndex]
  }

  private func responses(for request: Request) -> [Response?] {
    let route = routes[request.path]

    var responses = abruptResponsesByRoute(request: request, route: route)
    route.map { responses.append(responseByVerb(request: request, route: $0)) }

    return responses
  }

  private func responseByVerb(request: Request, route: Route) -> Response {
    var response = HTTPResponse(status: TwoHundred.Ok)

    switch request.verb {
    case .Get:
      let responders = gatherGetResponders(request: request, route: route)
      isAnImage(request.path) ?
        responders.first.map { $0.execute(on: &response) } :
        responders.forEach { $0.execute(on: &response) }

    case .Options:
      let allowedMethods = route
                            .allowedMethods
                            .map { $0.rawValue.uppercased() }
                            .joined(separator: ",")

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

  private func gatherGetResponders(request: Request, route: Route) -> [ResponseFormatter] {
    return [
      ContentResponder(for: request, data: data),
      route.cookiePrefix.map { CookieResponder(for: request, prefix: $0) } ?? ParamsResponder(for: request),
      LogsResponder(for: request, logs: route.includeLogs ? logs : nil),
      DirectoryLinksResponder(for: request, files: route.includeDirectoryLinks ? data.fileNames : nil),
      PartialResponder(for: request)
    ]
  }

  private func abruptResponsesByRoute(request: Request, route: Route?) -> [Response?] {
    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last
    return [
      route.map { _ in nil } ?? notFoundResponse,
      route?.customResponse.map { $0 },
      route?.auth != givenAuth ? unauthorizedResponse : nil ,
      (route?.canRespondTo(request.verb)).flatMap { $0 ? nil : methodNotAllowedResponse },
      redirectResponse(request, route: route)
    ]
  }

  private func foundResponse(location: String) -> Response {
    return HTTPResponse(status: ThreeHundred.Found, headers: ["Location": location])
  }

  private func redirectResponse(_ request: Request, route: Route?) -> Response? {
    return route?.redirectPath.map { redirectPath -> Response in
      if let redirectRoute = routes[redirectPath] {

        return redirectRoute.canRespondTo(request.verb) ?
          foundResponse(location: redirectPath) :
          methodNotAllowedResponse

      }
      else {
        return notFoundResponse
      }
    }
  }

}
