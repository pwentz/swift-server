import Routes
import Responses
import Requests

class ThreeHundredResponder {
  let route: Route?

  init(route: Route?) {
    self.route = route
  }

  func getResponse(to request: HTTPRequest) -> HTTPResponse? {
    return route?.redirectPath.flatMap { foundResponse(location: $0) }
  }

  private func foundResponse(location: String) -> HTTPResponse {
    return HTTPResponse(status: ThreeHundred.Found, headers: ["Location": location])
  }

}
