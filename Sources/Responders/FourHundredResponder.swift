import Responses
import Requests
import Routes

class FourHundredResponder {
  private let route: Route

  public init(route: Route) {
    self.route = route
  }

  public func response(to request: HTTPRequest) -> HTTPResponse? {
    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last

    guard route.auth == givenAuth else {
      return HTTPResponse(
        status: FourHundred.Unauthorized,
        headers: ["WWW-Authenticate": "Basic realm=\"simple\""]
      )
    }

    guard route.canRespondTo(request.verb) else {
      return HTTPResponse(status: FourHundred.MethodNotAllowed)
    }

    return nil
  }

}
