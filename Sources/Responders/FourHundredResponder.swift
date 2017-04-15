import Responses
import Requests
import Routes

class FourHundredResponder {
  private let route: Route?

  private let notFoundResponse = HTTPResponse(status: FourHundred.NotFound)
  private let unauthorizedResponse = HTTPResponse(
    status: FourHundred.Unauthorized,
    headers: ["WWW-Authenticate": "Basic realm=\"simple\""]
  )

  private let methodNotAllowedResponse = HTTPResponse(status: FourHundred.MethodNotAllowed)

  public init(route: Route?) {
    self.route = route
  }

  public func responses(to request: Request) -> [HTTPResponse?] {
    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last

    return [
      route.map { _ in nil } ?? notFoundResponse,
      route?.customResponse.map { $0 },
      route?.auth != givenAuth ? unauthorizedResponse : nil ,
      (route?.canRespondTo(request.verb)).flatMap { $0 ? nil : methodNotAllowedResponse }
    ]
  }
}
