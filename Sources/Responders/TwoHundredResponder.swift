import Requests
import Responses
import Routes
import Util
import ResponseFormatters

class TwoHundredResponder {
  let route: Route
  let data: ResourceData
  let logs: [String]

  public init(route: Route, data: ResourceData = EmptyResourceData(), logs: [String] = []) {
    self.route = route
    self.data = data
    self.logs = logs
  }

  public func response(to request: HTTPRequest) -> HTTPResponse {
    let validResponse = HTTPResponse(status: TwoHundred.Ok)
    switch request.verb {

    case let verb where verb == .Get:
      let formatters = getFormatters(request: request, route: route)

      return isAnImage(request.path) ?
        formatters.first!.addToResponse(validResponse) :
        formatters.reduce(validResponse) { $1.addToResponse($0) }

    case let verb where verb == .Options:
      let allowedMethods = route
                            .allowedMethods
                            .map { $0.rawValue.uppercased() }
                            .joined(separator: ",")

      return HTTPResponse(status: TwoHundred.Ok, headers: ["Allow": allowedMethods])

    case let verb where verb == .Post:
      data.update(request.path, withVal: request.body)
      return validResponse

    case let verb where verb == .Put:
      let resource = data.get(request.path)
      data.update(request.path, withVal: request.body)

      return resource == nil ?
        HTTPResponse(status: TwoHundred.Created) :
        validResponse

    case let verb where verb == .Patch:
      data.update(request.path, withVal: request.body)
      let headers = request.headers["if-match"].map { ["ETag": $0] }

      return HTTPResponse(status: TwoHundred.NoContent, headers: headers ?? [:])


    case let verb where verb == .Delete:
      data.remove(at: request.path)
      return validResponse

    default:
      return validResponse
    }
  }

  private func getFormatters(request: HTTPRequest, route: Route) -> [ResponseFormatter] {
    return [
      ContentFormatter(for: request.path, data: data),
      route.cookiePrefix.map { CookieFormatter(for: request, prefix: $0) } ?? ParamsFormatter(for: request.params),
      LogsFormatter(logs: route.includeLogs ? logs : nil),
      DirectoryLinksFormatter(files: route.includeDirectoryLinks ? data.fileNames : nil),
      PartialFormatter(for: request.headers["range"])
    ]
  }

}
