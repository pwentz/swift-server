import Routes
import Responses
import Requests

class ThreeHundredResponder {
  let route: Route

  init(route: Route) {
    self.route = route
  }

  func response(to request: HTTPRequest) -> HTTPResponse? {
    return route.redirectPath.map { foundResponse(location: $0) }
  }

  private func foundResponse(location: String) -> HTTPResponse {
    return HTTPResponse(status: ThreeHundred.Found, headers: ["Location": location])
  }

}
