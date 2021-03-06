import Requests
import Responses
import Routes
import Util
import ResponseFormatters

class TwoHundredResponder {
  let route: Route
  let data: ResourceData
  let logs: [String]

  private var allowedMethods: String {
    return route
            .allowedMethods
            .map { $0.rawValue.uppercased() }
            .joined(separator: ",")
  }

  public init(route: Route, data: ResourceData = EmptyResourceData(), logs: [String] = []) {
    self.route = route
    self.data = data
    self.logs = logs
  }

  public func response(to request: HTTPRequest) -> HTTPResponse {
    let successResponse = HTTPResponse(status: TwoHundred.Ok)
    switch request.verb {

    case .some(.Get):
      let formatters = gatherFormatters(request: request, route: route)

      return isAnImage(request.path) ?
        formatters.first!.addToResponse(successResponse) :
        formatters.reduce(successResponse) { $1.addToResponse($0) }

    case .some(.Options):
      return HTTPResponse(status: TwoHundred.Ok, headers: ["Allow": allowedMethods])

    case .some(.Post):
      data.update(request.path, withVal: request.body)
      return successResponse

    case .some(.Put):
      let resource = data[request.path]
      data.update(request.path, withVal: request.body)

      return resource == nil ?
        HTTPResponse(status: TwoHundred.Created) :
        successResponse

    case .some(.Patch):
      data.update(request.path, withVal: request.body)
      let headers = request.headers["if-match"].map { ["ETag": $0] }

      return HTTPResponse(status: TwoHundred.NoContent, headers: headers)

    case .some(.Delete):
      data.remove(at: request.path)
      return successResponse

    default:
      return successResponse
    }
  }

  private func gatherFormatters(request: HTTPRequest, route: Route) -> [ResponseFormatter] {
    return [
      ContentFormatter(for: request.path, data: data),
      route.cookiePrefix.map { CookieFormatter(for: request, prefix: $0) } ?? ParamsFormatter(for: request.params),
      LogsFormatter(logs: route.includeLogs ? logs : nil),
      DirectoryLinksFormatter(files: route.includeDirectoryLinks ? data.fileNames : nil),
      PartialFormatter(for: request.headers["range"])
    ]
  }

}
