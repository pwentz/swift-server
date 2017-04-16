import Util
import Routes
import Requests
import Responses
import ResponseFormatters

public class RouteResponder: Responder {
  let routes: [String: Route]
  let data: ControllerData
  var logs: [String] = []

  public init(routes: [String: Route], data: ControllerData = ControllerData([:])) {
    self.routes = routes
    self.data = data
  }

  public func getResponse(to request: HTTPRequest) -> HTTPResponse {
    logs.append("\(request.verb.rawValue.uppercased()) \(request.path) HTTP/1.1")

    let validResponses = responses(for: request).flatMap { $0 }

    return validResponses[validResponses.startIndex]
  }

  private func responses(for request: HTTPRequest) -> [HTTPResponse?] {
    let route = routes[request.path]

    var responses = FourHundredResponder(route: route).responses(to: request)
    responses.append(ThreeHundredResponder(route: route).getResponse(to: request))
    route.map { responses.append(responseByVerb(request: request, route: $0)) }

    return responses
  }

  private func responseByVerb(request: HTTPRequest, route: Route) -> HTTPResponse {
    var response = HTTPResponse(status: TwoHundred.Ok)

    switch request.verb {
    case .Get:
      let responders = getFormatters(request: request, route: route)
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

  private func getFormatters(request: HTTPRequest, route: Route) -> [ResponseFormatter] {
    return [
      ContentFormatter(for: request, data: data),
      route.cookiePrefix.map { CookieFormatter(for: request, prefix: $0) } ?? ParamsFormatter(for: request),
      LogsFormatter(for: request, logs: route.includeLogs ? logs : nil),
      DirectoryLinksFormatter(for: request, files: route.includeDirectoryLinks ? data.fileNames : nil),
      PartialFormatter(for: request)
    ]
  }

}
