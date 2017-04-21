import Responses
import Requests
import Routes
import Util

class FourHundredResponder {
  private let route: Route
  private let data: ResourceData

  public init(route: Route, data: ResourceData = EmptyResourceData()) {
    self.route = route
    self.data = data
  }

  public func response(to request: HTTPRequest) -> HTTPResponse? {
    let givenAuth = request.headers["authorization"]?.components(separatedBy: " ").last
    let rangeHeader = parseRangeHeader(request.headers["range"])

    guard route.auth == givenAuth else {
      return HTTPResponse(
        status: FourHundred.Unauthorized,
        headers: ["WWW-Authenticate": "Basic realm=\"simple\""]
      )
    }

    guard route.canRespondTo(request.verb) else {
      return HTTPResponse(status: FourHundred.MethodNotAllowed)
    }

    if request.shouldHaveBody, request.body == nil {
      return HTTPResponse(status: FourHundred.BadRequest)
    }

    if let resource = data[request.path], isRangeOutOfBounds(for: resource.count, rangeHeader) {
      let byteMax = resource.count - 1

      return HTTPResponse(
        status: FourHundred.RangeNotSatisfiable,
        headers: ["Content-Range": "bytes */\(byteMax)"]
      )
    }

    return nil
  }

  private func isRangeOutOfBounds(for contentLength: Int, _ range: (start: Int?, end: Int?)) -> Bool {
    if let endRange = range.end, contentLength < endRange {
      return true
    }

    if let startRange = range.start, contentLength < startRange {
      return true
    }

    return false
  }

}
