import Foundation
import Util
import Routes
import Requests
import Responses
import ResponseFormatters

public class RouteResponder: Responder {
  let routes: [String: Route]
  let data: ResourceData
  var logs: [String] = []

  public init(routes: [String: Route], data: ResourceData = ResourceData([:])) {
    self.routes = routes
    self.data = data
  }

  public func getResponse(to request: HTTPRequest) -> HTTPResponse {
    let requestLog = request.verb.map { "\($0.rawValue.uppercased()) \(request.path) HTTP/1.1" }
    logs.append(requestLog ?? "INVALID REQUEST")

    let validResponses = responses(for: request).flatMap { $0 }

    return validResponses[validResponses.startIndex]
  }

  private func responses(for request: HTTPRequest) -> [HTTPResponse?] {
    let route = routes[request.path]

    let clientErrorResponses = FourHundredResponder(route: route).responses(to: request)

    let remainingResponses = [
      ThreeHundredResponder(route: route).getResponse(to: request),
      route.map { responseByVerb(request: request, route: $0) }
    ]

    return clientErrorResponses + remainingResponses
  }

  private func responseByVerb(request: HTTPRequest, route: Route) -> HTTPResponse {
    let response = HTTPResponse(status: TwoHundred.Ok)

    switch request.verb {
    case let verb where verb == .Get:
      let responders = getFormatters(request: request, route: route)
      return isAnImage(request.path) ?
        responders.first!.addToResponse(response) :
        responders.reduce(response) { $1.addToResponse($0) }

    case let verb where verb == .Options:
      let allowedMethods = route
                            .allowedMethods
                            .map { $0.rawValue.uppercased() }
                            .joined(separator: ",")

      return HTTPResponse(status: TwoHundred.Ok, headers: ["Allow": allowedMethods])

    case let verb where verb == .Post || verb == .Put:
      data.update(request.path, withVal: request.body)
      return response

    case let verb where verb == .Patch:
      data.update(request.path, withVal: request.body)
      return HTTPResponse(status: TwoHundred.NoContent)

    case let verb where verb == .Delete:
      data.remove(at: request.path)
      return response

    default:
      return response
    }
  }

  private func getFormatters(request: HTTPRequest, route: Route) -> [ResponseFormatter] {
    return [
      ContentFormatter(for: request.path, data: data),
      route.cookiePrefix.map { CookieFormatter(for: request, prefix: $0) } ?? ParamsFormatter(for: request.params),
      LogsFormatter(logs: route.includeLogs ? logs : nil),
      DirectoryLinksFormatter(files: route.includeDirectoryLinks ? data.fileNames : nil),
      PartialFormatter(for: request.headers["range"])
    ]
  }

}
