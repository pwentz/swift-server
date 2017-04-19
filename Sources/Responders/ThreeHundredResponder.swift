import Routes
import Responses
import Requests

class ThreeHundredResponder {
  let redirectPath: String?

  init(redirectPath: String?) {
    self.redirectPath = redirectPath
  }

  func response(to request: HTTPRequest) -> HTTPResponse? {
    return redirectPath.map { foundResponse(location: $0) }
  }

  private func foundResponse(location: String) -> HTTPResponse {
    return HTTPResponse(status: ThreeHundred.Found, headers: ["Location": location])
  }

}
