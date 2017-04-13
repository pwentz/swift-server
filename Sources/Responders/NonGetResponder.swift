import Util
import Routes
import Requests
import Responses

class NonGetResponder: RouteResponder {
  let route: Route
  let data: ControllerData
  let request: Request

  public init(for request: Request, route: Route, data: ControllerData) {
    self.request = request
    self.route = route
    self.data = data
  }

  func execute(on response: inout HTTPResponse) {
    switch request.verb {
    case .Options:
      let allowedMethods = route.allowedMethods.map { $0.rawValue.uppercased() }.joined(separator: ",")
      response.appendToHeaders(with: ["Allow": allowedMethods])

    case .Post, .Put:
      data.update(request.pathName, withVal: request.body ?? "")

    case .Patch:
      data.update(request.pathName, withVal: request.body ?? "")
      response.updateStatus(with: TwoHundred.NoContent)

    case .Delete:
      data.remove(at: request.pathName)

    default:
      break
    }
  }
}
