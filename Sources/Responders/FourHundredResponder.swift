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

    if let resource = data.get(request.path), isRangeOutOfBounds(for: resource, rangeHeader) {
      let byteMax = resource.characters.count - 1

      return HTTPResponse(
        status: FourHundred.RangeNotSatisfiable,
        headers: ["Content-Range": "bytes */\(byteMax)"]
      )
    }

    return nil
  }

  private func isRangeOutOfBounds(for resource: String, _ range: (start: Int?, end: Int?)) -> Bool {
    let contentLength = resource.characters.count

    if let endRange = range.end, contentLength < endRange {
      return true
    }

    if let startRange = range.start, contentLength < startRange {
      return true
    }

    return false
  }

}
