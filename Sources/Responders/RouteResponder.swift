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

  public init(routes: [String: Route], data: ResourceData = EmptyResourceData()) {
    self.routes = routes
    self.data = data
  }

  public func response(to request: HTTPRequest) -> HTTPResponse {
    guard let route = routes[request.path] else {
      return HTTPResponse(status: FourHundred.NotFound)
    }

    updateLogsIfValid(request)

    let clientErrorResponder = FourHundredResponder(route: route, data: data)
    let redirectResponder = ThreeHundredResponder(redirectPath: route.redirectPath)
    let successResponder = TwoHundredResponder(route: route, data: data, logs: logs)

    if let clientError = clientErrorResponder.response(to: request) {
      return clientError
    }

    if let customResponse = route.customResponse {
      return customResponse
    }

    if let redirect = redirectResponder.response(to: request) {
      return redirect
    }

    return successResponder.response(to: request)
  }

  private func updateLogsIfValid(_ request: HTTPRequest) {
    if let verb = request.verb {
      logs.append("\(verb.rawValue.uppercased()) \(request.path) HTTP/1.1")
    }
  }

}
