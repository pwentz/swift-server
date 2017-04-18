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
    guard let route = routes[request.path] else {
      return HTTPResponse(status: FourHundred.NotFound)
    }

    let requestLog = request.verb.map { "\($0.rawValue.uppercased()) \(request.path) HTTP/1.1" }
    logs.append(requestLog ?? "INVALID REQUEST METHOD")

    if let clientError = FourHundredResponder(route: route).response(to: request) {
      return clientError
    }

    if let customResponse = route.customResponse {
      return customResponse
    }

    if let redirect = ThreeHundredResponder(route: route).response(to: request) {
      return redirect
    }

    return responseByVerb(request: request, route: route)
  }

  private func responseByVerb(request: HTTPRequest, route: Route) -> HTTPResponse {
    let validResponse = HTTPResponse(status: TwoHundred.Ok)
    switch request.verb {

    case let verb where verb == .Get:
      let formatters = getFormatters(request: request, route: route)

      return isAnImage(request.path) ?
        formatters.first!.addToResponse(validResponse) :
        formatters.reduce(validResponse) { $1.addToResponse($0) }

    case let verb where verb == .Options:
      let allowedMethods = route
                            .allowedMethods
                            .map { $0.rawValue.uppercased() }
                            .joined(separator: ",")

      return HTTPResponse(status: TwoHundred.Ok, headers: ["Allow": allowedMethods])

    case let verb where verb == .Post || verb == .Put:
      data.update(request.path, withVal: request.body)
      return validResponse

    case let verb where verb == .Patch:
      data.update(request.path, withVal: request.body)
      return HTTPResponse(status: TwoHundred.NoContent)

    case let verb where verb == .Delete:
      data.remove(at: request.path)
      return validResponse

    default:
      return validResponse
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
