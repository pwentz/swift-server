import Routes
import Responses
import Requests

class ThreeHundredResponder {
  let route: Route?

  init(route: Route?) {
    self.route = route
  }

  func getResponse(to request: Request) -> HTTPResponse? {
    return route?.redirectPath.flatMap { redirectPath -> HTTPResponse? in
        foundResponse(location: redirectPath)
    }
  }

  private func foundResponse(location: String) -> HTTPResponse {
    return HTTPResponse(status: ThreeHundred.Found, headers: ["Location": location])
  }
}
