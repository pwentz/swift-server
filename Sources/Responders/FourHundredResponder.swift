import Responses
import Requests
import Routes

class FourHundredResponder {
  private let route: Route

  private let unauthorizedResponse = HTTPResponse(
    status: FourHundred.Unauthorized,
    headers: ["WWW-Authenticate": "Basic realm=\"simple\""]
  )

  private let methodNotAllowedResponse = HTTPResponse(status: FourHundred.MethodNotAllowed)

  public init(route: Route) {
    self.route = route
  }

  public func response(to request: HTTPRequest) -> HTTPResponse? {
    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last

    guard route.auth == givenAuth else {
      return unauthorizedResponse
    }

    guard route.canRespondTo(request.verb) else {
      return methodNotAllowedResponse
    }

    return nil
  }

}
